# Gentoo Overlay Development Guide

## Project Overview
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
- To get the `SRC_URI`, refer to the previous version's ebuild. For GitHub-based projects, you can find the latest release via the GitHub API: `https://api.github.com/repos/[organization]/[project]/releases/latest`. Always prioritize using `curl` for GitHub API requests; use `web_fetch` only if `curl` is unavailable on the system. For other sources, you may need to ask the user for the update retrieval method.
- Create the new ebuild by copying the existing one.
- **Important:** Do not manually replace variables like `${PV}` (Package Version) in the ebuild file. These are automatically populated by Gentoo's package manager based on the ebuild's filename.
- Update all version-specific variables (e.g., `BUILD_ID`, `SRC_URI` hashes).
- Verify if there are any new dependencies or removed features in the new version.
- Regenerate the manifest using: `ebuild <package>.ebuild manifest --force`
- Test the ebuild installation with: `ebuild <package>.ebuild configure`
- Run QA checks using: `pkgcheck scan --verbose <package>.ebuild`
- Remove the old ebuild file.
- Regenerate the manifest again to remove the old entry: `ebuild <package>.ebuild manifest --force`
- Prompt the user to stage the changes and commit them using `pkgdev commit --signoff`, which will auto-generate a commit message.
- Ask the user if they want to push the changes to a remote branch or open a pull request (e.g., `git push origin <current-branch>:<package-branch>`).

### Cleaning Obsolete Packages (treeclean)
- Remove the entire package directory: `[category]/[package]`.
- Search the repository for any lingering references to the package and remove them (make sure to respect .gitignore).
- Prompt the user to stage the changes and commit them using `pkgdev commit --signoff`.
- Ask the user if they want to push the changes or open a pull request.