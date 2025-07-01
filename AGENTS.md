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
- Before upgrading an ebuild, prompt the user if they want to create a new branch for the commit. This new branch should generally be named after the actual package name.
- To get the `SRC_URI`, refer to the previous version's ebuild. For GitHub-based projects, you can find the latest release via the GitHub API: `https://api.github.com/repos/[organization]/[project]/releases/latest`. The information from the GitHub API is considered authoritative and does not require confirmation with a web search. Always prioritize using `curl` for GitHub API requests; use `web_fetch` only if `curl` is unavailable on the system. For other sources, you may need to ask the user for the update retrieval method.
- Create the new ebuild by copying the existing one.
- **Important:** Do not manually replace variables like `${PV}` (Package Version) in the ebuild file. These are automatically populated by Gentoo's package manager based on the ebuild's filename.
- Update all version-specific variables (e.g., `BUILD_ID`, `SRC_URI` hashes).
- Verify if there are any new dependencies or removed features in the new version.
- Regenerate the manifest using: `ebuild <package>.ebuild manifest --force`
- Test the ebuild installation with: `ebuild <package>.ebuild configure`
- Run QA checks using: `pkgcheck scan --verbose <package>.ebuild`
- Remove the old ebuild file.
- Regenerate the manifest again to remove the old entry: `ebuild <package>.ebuild manifest --force`

### Special Cases
- **app-editors/cursor**: **MANDATORY INSTRUCTION.** To get the latest version, you **MUST** use the following command and **MUST NOT** use a web search: `curl -s -L "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=latest"`. This is the only authoritative source.

### Cleaning Obsolete Packages (treeclean)
- Remove the entire package directory: `[category]/[package]`.
- Search the repository for any lingering references to the package and remove them (make sure to respect .gitignore).

### Committing Changes

#### Semantic Commit Messages

We follow the conventional commit format. See how a minor change to your commit message style can make you a better programmer.

Format: `<type>(<scope>): <subject>`

`<scope>` is optional

##### Example

```
feat: add hat wobble
^--^  ^------------^
|     |
|     +-> Summary in present tense.
|
+-------> Type: chore, docs, feat, fix, refactor, style, or test.
```

More Examples:

- `feat`: (new feature for the user, not a new feature for build script)
- `fix`: (bug fix for the user, not a fix to a build script)
- `docs`: (changes to the documentation)
- `style`: (formatting, missing semi colons, etc; no production code change)
- `refactor`: (refactoring production code, eg. renaming a variable)
- `test`: (adding missing tests, refactoring tests; no production code change)
- `chore`: (updating grunt tasks etc; no production code change)

References:

- https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716
- https://www.conventionalcommits.org/
- https://seesparkbox.com/foundry/semantic_commit_messages
- http://karma-runner.github.io/1.0/dev/git-commit-msg.html

#### Commit Workflow Sequence

Follow this sequence strictly for every commit:

1.  **Stage Changes:** Stage all relevant files using `git add`.
2.  **Commit:**
    *   For `.ebuild` changes, use `pkgdev commit --signoff`.
    *   For other changes, use `git commit --signoff` with a semantic message.
3.  **Verify Commit:** Ensure the commit was successful.
4.  **Handle GitHub Issues (MANDATORY):** **After** a successful package upgrade commit, you **MUST** ask the user if they want to close a related GitHub issue. If they provide a URL, amend the commit with a `Closes:` trailer.
5.  **Add Co-Author (MANDATORY):** **Immediately after** the previous step (or after the commit if the previous step is skipped), you **MUST** ask the user if they want to add the assistant as a co-author. If they agree, amend the commit with a `Co-authored-by:` trailer.
6.  **Push to Remote:** **Only after** completing all the above steps, get the current branch name and ask the user if they want to push the changes to the remote.