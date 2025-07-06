# Gentoo Overlay Development Guide

## Project Overview
This guide is specifically tailored for Gentoo projects. It assumes the repository root contains a typical Gentoo overlay structure, including `profiles/eapi`.
This repository is a Gentoo overlay containing custom ebuilds for packages not available in the official Gentoo portage tree.

## Ebuild Guidelines

### Core Principles
- Adhere strictly to Gentoo's ebuild standards and best practices.
- Use `EAPI=8` for all new ebuilds unless a specific package requires backward compatibility.
- Include a proper copyright header with the current year in all relevant files.
- Provide a comprehensive `metadata.xml` file for every package.

### Directory Structure
- Place ebuilds in their appropriate category directories (e.g., `app-editors/`, `dev-go/`).
- Ensure a `Manifest` file is present for every package.
- Create a `metadata.xml` file with an accurate package description and maintainer details.
- Follow the upstream project's versioning scheme.

### Common Ebuild Patterns
- For binary packages, define `SRC_URI` with a descriptive filename.
- Specify all build-time and run-time dependencies in `DEPEND` and `RDEPEND`.
- Set appropriate `KEYWORDS` (e.g., `~amd64`, `~arm64`).
- For binary packages, configure `RESTRICT` correctly (e.g., `bindist`, `mirror`, `strip`).
- Include the `QA_PREBUILT` variable for any pre-compiled files.

### Bumping Package Versions
- **CRITICAL RULE:** Before attempting to determine a package's new version or `SRC_URI`, you **MUST** first check the `Special Cases` section below. If the package is listed there, you **MUST** follow the specific instructions provided and **MUST NOT** use any other method (like GitHub API or web search) to find the version or download link.
- When the user asks which packages need to be upgraded, or does not specify the name of the package to be upgraded, you **MUST** first check for relevant issues on GitHub. To do this, you will run `git remote -v`, and for each remote URL that points to a GitHub repository, you will fetch the open issues using the API (`https://api.github.com/repos/OWNER/REPO/issues`).
- **MANDATORY BRANCH PROMPT:** Before upgrading any ebuild, you **MUST** always prompt the user if they want to create a new branch for the commit. This new branch should generally be named after the actual package name. This is a non-negotiable requirement that must be followed for every ebuild upgrade.
- To get the `SRC_URI`, refer to the previous version's ebuild. For GitHub-based projects, you can find the latest release via the GitHub API: `https://api.github.com/repos/[organization]/[project]/releases/latest`. The information from the GitHub API is considered authoritative and does not require confirmation with a web search. Always prioritize using `curl` for GitHub API requests; use `web_fetch` only if `curl` is unavailable on the system. For other sources, you may need to ask the user for the update retrieval method.
- Create the new ebuild by copying the existing one.
- **Important:** Do not manually replace variables like `${PV}` (Package Version) in the ebuild file. These are automatically populated by Gentoo's package manager based on the ebuild's filename.
- Update all version-specific variables (e.g., `BUILD_ID`, `SRC_URI` hashes).
- Verify if there are any new dependencies or removed features in the new version.
- Regenerate the manifest using: `ebuild <package>.ebuild manifest --force`
- Test the ebuild installation with: `ebuild <package>.ebuild configure`
- Run QA checks using: `pkgcheck scan --verbose <package>.ebuild`
- Remove the old ebuild file. you **MUST** use `git rm` instead of `rm` to ensure the change is tracked by Git.
- Regenerate the manifest again to remove the old entry: `ebuild <package>.ebuild manifest --force`
- After a successful upgrade and commit, if a new branch was created for the upgrade, prompt the user if they want to delete this branch.
- If a new branch was used for an upgrade, and the user wants to upgrade another package, they **MUST** first switch back to the `master` branch before creating a new branch for the second upgrade.

### Special Cases
- **app-editors/cursor**: **MANDATORY INSTRUCTION.** To get the latest version, you **MUST** execute the following command exactly as written, and then parse its raw JSON output to extract the version and download URL. You **MUST NOT** modify this command or attempt to infer its behavior. This is the only authoritative source: `curl -s -L "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=latest"`

### Cleaning Obsolete Packages (treeclean)
- Remove the entire package directory: `[category]/[package]`.
- Search the repository for any lingering references to the package and remove them (make sure to respect .gitignore).

### Committing Changes



#### Commit Workflow Sequence

Follow this sequence strictly for every commit:

1.  **Stage Changes:** Stage only the relevant files using `git add [specific files]`. When upgrading a package, only add the necessary files (e.g., new ebuild, manifest, metadata changes). **NEVER use `git add .`** which could stage unintended files. If uncertain about which files to stage, ask the user for confirmation.
2.  **Commit:**
    *   For `.ebuild` changes, use `pkgdev commit --signoff`. **CRITICAL: You MUST NOT use the `--message` or `-m` flag.** `pkgdev` automatically generates the required commit message; using these flags interferes with the correct, automated workflow.
    *   For other changes, use `git commit --signoff` with a semantic message.
3.  **Verify Commit:** Ensure the commit was successful.
4.  **Handle Related Issues (MANDATORY for Package Upgrades):** After a package upgrade commit, perform the following:

    1. **Identify Remote Hosts:** Run `git remote -v` to inspect all remote URLs.
    2. **GitHub-Specific Workflow:** For each remote URL that points to a GitHub repository (i.e., contains `github.com`):
        1. **Parse Repository:** Extract the `OWNER/REPO` from the URL.
        2. **Fetch Open Issues:** Use `curl` to call the GitHub Issues API (`https://api.github.com/repos/OWNER/REPO/issues`) for that repository.
    3. **Filter and Present:** Consolidate the issues gathered from all remotes. Compare the upgraded package's name with the issue titles. Present a numbered list of potential matches (Title + URL) to the user.
        4. **Confirm and Close:** Ask the user to select an issue to close from the list. If they do, amend the commit with the corresponding `Closes: [issue URL]` trailer.
    3. **Default Workflow (for non-GitHub remotes):** If the remote is not hosted on GitHub, simply ask the user if they want to close a related issue. If they provide a URL, amend the commit.
    4. **Proceed:** If no relevant issues are found or the user provides no URL, or if the commit is not a package upgrade, proceed to the next step.
5.  **Add Co-Author (MANDATORY):** **Immediately after** the previous step, you **MUST** ask the user if they want to add the assistant as a co-author. If they agree, amend the commit with the appropriate `Co-authored-by:` trailer based on the AI assistant being used (see Global Rules section for specific formats).
6.  **Verify Commit Message (MANDATORY):** After amending the commit, you **MUST** run `git show --format=%B -s` to inspect the full commit message and ensure all required trailers (e.g., `Closes:`, `Co-authored-by:`) are present and correctly formatted. If any are missing or incorrect, you **MUST** re-amend the commit to fix them.
7.  **Push to Remote:** **Only after** completing all the above steps, get the current branch name and ask the user if they want to push the changes to the remote.
8.  **Display Repository Link (MANDATORY):** **Immediately after** successfully pushing to the remote, you **MUST** display the repository access link to allow the user to verify the changes. Extract the repository URL from `git remote -v` and convert it to a web-accessible format:
    - For GitHub SSH URLs (`git@github.com:owner/repo.git`): Convert to `https://github.com/owner/repo`
    - For GitLab SSH URLs (`git@gitlab.com:owner/repo.git`): Convert to `https://gitlab.com/owner/repo`
    - For other Git hosting services: Apply similar SSH-to-HTTPS conversion patterns
    - For HTTPS URLs: Use as-is after removing `.git` suffix if present
    - Display as: "Changes pushed successfully! Repository: [URL]"
