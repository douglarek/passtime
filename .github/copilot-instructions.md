# GitHub Copilot Instructions for Gentoo Overlay

## Project Context
This is a Gentoo overlay repository called "passtime" containing custom ebuilds for various packages not available in the official Gentoo portage tree.

## Ebuild Guidelines

### General Principles
- Follow Gentoo's ebuild standards and best practices
- Use EAPI=8 for all new ebuilds unless specific compatibility requirements exist
- Include proper copyright headers with current year
- Add comprehensive metadata.xml files for all packages

### File Structure
- Place ebuilds in appropriate category directories (app-editors/, dev-go/, etc.)
- Include Manifest files for all packages
- Add metadata.xml with proper descriptions and maintainer information
- Use proper versioning scheme following upstream releases

### Common Patterns
- For binary packages, use proper SRC_URI with meaningful filenames
- Include all necessary dependencies in DEPEND/RDEPEND
- Use appropriate KEYWORDS (~amd64, ~arm64, etc.)
- Set RESTRICT appropriately for binary packages (bindist, mirror, strip)
- Include proper QA_PREBUILT for binary packages

### Version Bumps
- When creating new versions, copy from existing ebuild
- Update version-specific variables (BUILD_ID, SRC_URI hashes, etc.)
- Check for new dependencies or removed features
- Test ebuild compilation and installation

### Specific Package Types

#### AppImage Packages (like Cursor)
- Extract AppImage contents in src_unpack()
- Handle desktop files and icons properly
- Include shell completion files when available
- Use proper symlinks for executables

#### Go Packages
- Use go-module.eclass for dependency management
- Include proper go.sum and go.mod handling
- Set appropriate build flags and target architectures
- Additionally, for Go packages with vendored dependencies:
    * If SRC_URI contains vendor archives ('*-vendor.tar.gz' or '*-deps.tar.gz'), check upstream for version updates regularly
    * Update both the main source URL and vendor archive to match the latest upstream release
    * Regenerate vendor archives if maintaining them locally

#### Binary Packages
- Verify checksums and signatures when possible
- Handle library dependencies carefully
- Include proper RPATH handling if needed

## Code Style
- Use tabs for indentation in ebuilds
- Follow bash scripting best practices
- Include meaningful comments for complex operations
- Use die statements for error handling except internal commands like edo, emake, etc.

## Testing
- Always test ebuilds before committing
- Use `ebuild <package>.ebuild manifest` to generate Manifest
- Verify installation with `ebuild <package>.ebuild install`
- Check for QA violations and warnings with `pkgcheck scan --commits --net`

## Documentation
- Update package descriptions to be clear and informative
- Include upstream URLs and relevant links
- Document any patches or modifications applied
- Note any known issues or limitations

## Security
- Verify source authenticity when possible
- Use HTTPS for all download URLs if possible
- Include proper license information
- Handle sensitive files appropriately

## Upgrade Process
When upgrading packages, follow this structured version bump process:

1. Copy the existing latest ebuild to a new version file
2. Update the version number and any version-specific variables
3. Check for new dependencies or upstream changes
4. Test the new ebuild thoroughly:
    - Run `ebuild <package>.ebuild manifest` to generate checksums
    - Run `ebuild <package>.ebuild test` to verify functionality
5. Stage your changes with `git add <file>`
6. Commit with a descriptive message using `pkgdev commit --signoff`
7. Perform final QA checks with `pkgcheck scan --commits --net`

## Version Detection Best Practices
### General GitHub Projects
For GitHub-hosted projects, use the GitHub API to fetch the latest version:
- Endpoint: `https://api.github.com/repos/<owner>/<repo>/releases/latest`
- Extract the `tag_name` field to get the latest version
- This is the recommended approach for most GitHub projects

### Special handling for specific packages:
* Cursor: Update BUILD_ID by querying the API endpoint `https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=latest`
* GoldenDict-NG: Update MY_PV by fetching the latest release from `https://api.github.com/repos/xiaoyifang/goldendict-ng/releases/latest` and extracting the `tag_name` field