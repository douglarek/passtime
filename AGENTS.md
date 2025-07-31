# Gentoo Overlay Development Guidelines

## Global Rules

1. **Commit Co-authorship:** After every successful `git commit`, automatically run:
   ```
   git commit --amend --no-edit --trailer="Co-authored-by: [AI_ASSISTANT_NAME] <noreply@[AI_PLATFORM]>"
   ```
   * For crush: `Co-authored-by: crush <noreply@charm.land>`
   * For opencode: `Co-authored-by: opencode <noreply@opencode.ai>`
   * For Gemini CLI: `Co-authored-by: gemini <noreply@google.ai>`
   * For Claude Code: `Co-authored-by: claude <noreply@anthropic.com>`
   * For GitHub Copilot: `Co-authored-by: copilot <noreply@github.com>`

2. **Semantic Commit Messages:** Use the Conventional Commits format: `<type>(<scope>): <subject>`
   * **Example:** `feat: add hat wobble`
   * **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

3. **Force Push Confirmation:** ALWAYS ask for user confirmation before `git push --force`

---

## Gentoo Overlay Development Guide

This guide is for Gentoo overlay projects with a typical structure (e.g., `profiles/eapi`). This repository contains custom ebuilds.

### Ebuild Guidelines

#### Core Principles
* Adhere to Gentoo ebuild standards
* Use `EAPI=8` for new ebuilds (unless backward compatibility is required)
* Include copyright headers and `metadata.xml` for all packages
* Follow upstream versioning

#### Directory Structure
* Place ebuilds in `[category]/[package]`
* Ensure `Manifest` and `metadata.xml` files are present

#### Common Ebuild Patterns
* **Binary Packages:** Define `SRC_URI` with descriptive filenames
* **Dependencies:** Specify `DEPEND` and `RDEPEND`
* **Keywords:** Set `KEYWORDS` (e.g., `~amd64`)
* **Restrictions:** Configure `RESTRICT` (e.g., `bindist`)
* **Pre-compiled Files:** Use `QA_PREBUILT`

#### Dependency Management Rules
1. **Package Search:** When adding dependencies, use `emerge --search [package]` to fuzzy search for relevant packages. If multiple results exist and it's unclear which package to use, MUST ask the user to specify which package they need.

2. **Dependency Ordering:** All dependencies in `DEPEND`, `RDEPEND`, and `BDEPEND` should be sorted in alphabetical order by package atom (string sort order).

---

### Bumping Package Versions

1. **Check Special Cases FIRST:** Before determining a new version or `SRC_URI`, consult the `Special Cases` section below. If listed, follow its instructions ONLY.

2. **Identify Upgrade Needs:** If the user asks which packages need upgrading, or doesn't specify, check GitHub issues:
   * Run `git remote -v`
   * For each GitHub remote (`github.com`), fetch open issues via `curl -sL https://api.github.com/repos/OWNER/REPO/issues`
   * Present potential matches (Title + URL) to the user

3. **Branch Prompt (MANDATORY):** ALWAYS ask the user if they want to create a new branch for the commit, typically named after the package

4. **Get `SRC_URI`:**
   * Refer to the previous ebuild
   * For GitHub projects, use `curl -sL https://api.github.com/repos/[organization]/[project]/releases/latest`. This is authoritative
   * If `.github/workflows/overlay.toml` exists and a package `source` is `regex`, use its `url` with `curl -sL [url]`

5. **Create New Ebuild:** Copy the existing ebuild. Do NOT manually replace `${PV}`

6. **Update Variables:** Update version-specific variables (e.g., `BUILD_ID`, `SRC_URI` hashes)

7. **Verify Dependencies/Features:** Check for new dependencies or removed features

8. **Pre-Commit Quality Assurance (MANDATORY):**
   1. **Regenerate Manifest:** `ebuild <package>.ebuild manifest --force`
   2. **Run QA Check:** `pkgcheck scan --verbose <package>.ebuild`
   3. **Fix Errors:** Repeat if `pkgcheck` reports errors
   4. **Commit:** Proceed only after `pkgcheck` passes

9. **Check Old Version Stability (MANDATORY):** Before deciding whether to remove old ebuild:
   * Read the old ebuild's `KEYWORDS` line
   * **If old version has stable keywords** (e.g., `amd64` without `~` prefix): MUST ASK user if they want to delete the old version
   * **If old version has no stable keywords but upgrade crosses major/minor versions** (e.g., `1.2.3` → `1.3.0` or `1.2.3` → `2.0.0`): MUST ASK user if they want to delete the old version
     - For semantic versioning (MAJOR.MINOR.PATCH), only MAJOR or MINOR version changes count as cross-version upgrades
     - PATCH-only changes (e.g., `0.3.13` → `0.3.22`) do NOT count as cross-version upgrades
   * **Otherwise:** Can proceed with deletion automatically

10. **Commit Logic:**
   * **Single Commit Approach (Recommended):** Add new ebuild, remove old ebuild, and regenerate manifest in one commit
   * **Two Commit Approach:**
     1. First commit: Add new ebuild + manifest regeneration
     2. Second commit: Remove old ebuild + manifest regeneration
     * Both commits MUST include `Part-of: [GitHub issue URL]` trailer
     * Only the **FIRST commit (add new version)** should include `Closes: [GitHub issue URL]`

11. **Remove Old Ebuild (if approved):** Use `git rm` for the old ebuild file

12. **Regenerate Manifest (Post-Removal):** After removing the old ebuild, run `ebuild <new-package-version>.ebuild manifest --force` to clean the `Manifest` file

13. **Branch Deletion (MANDATORY):** If a new branch was created, ALWAYS prompt the user to delete it after a successful upgrade and commit. Ask: "Would you like to delete the [branch-name] branch and return to master? (y/n)"

14. **Multiple Upgrades:** If upgrading another package, ensure the user switches back to the `master` branch first

---

### Special Cases

---

### Cleaning Obsolete Packages (treeclean)
* Remove the entire package directory: `[category]/[package]`
* Search for all references to the package name globally
* Remove references from:
  - README.md (package table entries)
  - AGENTS.md (Special Cases section)
  - .github/workflows/overlay.toml (package configuration)
  - Any other files found by search

---

### Committing Changes

Follow this sequence strictly for every commit:

1. **Stage Changes:** Use `git add [specific files]`. For package upgrades, only stage necessary files (new ebuild, manifest, metadata). **NEVER use `git add .`**

2. **Commit:**
   * For `.ebuild` changes: `pkgdev commit --signoff`. **DO NOT use `--message` or `-m`**
   * For other changes: `git commit --signoff` with a semantic message

3. **Verify Commit:** Ensure the commit was successful

4. **Handle Related Issues (MANDATORY for Package Upgrades):**
   * **Identify Remotes:** Run `git remote -v`
   * **GitHub Remotes:** For each `github.com` remote:
     * Extract `OWNER/REPO`
     * Fetch open issues: `curl -sL https://api.github.com/repos/OWNER/REPO/issues`
     * Present a numbered list of potential matches (Title + URL) to the user
     * Ask the user to select an issue to close. If selected, amend the commit with `Closes: [issue URL]`
   * **Non-GitHub Remotes:** Ask the user if they want to close a related issue. If they provide a URL, amend the commit
   * **Proceed:** If no issues are found/provided, or not a package upgrade, proceed

5. **Verify Commit Message (MANDATORY):** After amending, run `git show --format=%B -s` to inspect the full commit message. Ensure all required trailers (e.g., `Closes:`, `Co-authored-by:`) are present and correctly formatted. Re-amend if needed

6. **Push to Remote:** Get the current branch name. Ask the user if they want to push changes to the remote

7. **Display Repository Link (MANDATORY):** After successful push, display the repository access link
   * Extract URL from `git remote -v`
   * Convert SSH to HTTPS (e.g., `git@github.com:owner/repo.git` → `https://github.com/owner/repo`)
   * Display as: "Changes pushed successfully! Repository: [URL]"

8. **Branch Cleanup (MANDATORY):** After successful push, if working on a feature branch:
   * Ask: "Would you like to delete the [branch-name] branch and return to master? (y/n)"
   * If yes:
     * Switch to master: `git checkout master`
     * Delete branch: `git branch -d [branch-name]`
   * Remind user that future package upgrades should start from master
