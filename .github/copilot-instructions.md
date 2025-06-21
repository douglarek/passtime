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
- QA checks are automatically performed by `pkgdev push`

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

1. **Version Detection**: Check for the latest upstream version using GitHub API or package-specific endpoints
2. **Copy Ebuild**: Copy the existing latest ebuild to a new version file
3. **Update Variables**: Update version number and any version-specific variables
4. **Dependencies Check**: Verify for new dependencies or upstream changes
5. **Generate Manifest**: Run `ebuild <package>.ebuild manifest` to generate checksums
6. **Test Ebuild**: Run `ebuild <package>.ebuild test` to verify functionality
7. **Stage Changes**: Use `git add <file>` to stage your changes
8. **Commit Changes**: Use `pkgdev commit --signoff` (without -m) to auto-generate commit message
9. **Add Co-author**: Use `git commit --amend` to add GitHub Copilot as co-author:
   ```bash
   git commit --amend -m "package/name: add X.Y.Z

   🤖 Generated with [GitHub Copilot](https://github.com/features/copilot)

   Signed-off-by: Your Name <your.email@domain.com>
   Co-authored-by: GitHub Copilot <copilot@github.com>"
   ```
10. **Push Changes**: Use `pkgdev push` to push to remote repository
11. **Clean Up**: Remove old versions and regenerate Manifest if needed
12. **Final QA**: `pkgdev push` automatically performs QA checks during push

## Version Detection Best Practices
### General GitHub Projects
For GitHub-hosted projects, use the GitHub API to fetch the latest version:
- Endpoint: `https://api.github.com/repos/<owner>/<repo>/releases/latest`
- Extract the `tag_name` field to get the latest version
- This is the recommended approach for most GitHub projects

### Special handling for specific packages:
* **Cursor**: Update BUILD_ID by querying the API endpoint `https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=latest`
* **GoldenDict-NG**: Update MY_PV by fetching the latest release from `https://api.github.com/repos/xiaoyifang/goldendict-ng/releases/latest` and extracting the `tag_name` field

### Automated Version Checking
- Use nvchecker for automated version monitoring
- GitHub issues are automatically created when new versions are detected
- Close issues after successful version updates
- Monitor for frequent updates that may require automation

## Commit Workflow Best Practices

### Standard Commit Process
1. **Auto-generated Messages**: Always use `pkgdev commit --signoff` without `-m` flag to let pkgdev generate appropriate commit messages
2. **Add Co-authorship**: Use `git commit --amend` to add GitHub Copilot as co-author
3. **Template Format**:
   ```
   package/name: action description
   
   [Optional detailed description]

   🤖 Generated with [GitHub Copilot](https://github.com/features/copilot)

   Signed-off-by: Your Name <email@example.com>
   Co-authored-by: GitHub Copilot <copilot@github.com>
   ```

### Common Commit Types
`pkgdev commit --signoff` automatically generates appropriate commit messages. Only use manual commit messages when `pkgdev` cannot auto-generate them:

- `package/name: add X.Y.Z` - Adding new version
- `package/name: drop X.Y.Z` - Removing old version  
- `package/name: bump to X.Y.Z` - Version update with significant changes
- `package/name: fix ...` - Bug fixes
- `package/name: update dependencies` - Dependency updates

### Push Process
- For ebuild changes: Always use `pkgdev push` instead of `git push`
- For documentation/non-ebuild changes: Use regular `git push`
- `pkgdev push` ensures proper QA checks are performed on ebuild changes
- Address any warnings or errors before finalizing

## Troubleshooting

### Common Issues
- **Manifest Generation Failures**: Ensure all SRC_URI are accessible and checksums match
- **QA Violations**: Address warnings from `pkgdev push` output
- **Build Failures**: Check dependencies and build environment
- **Push Failures**: Resolve any QA issues before pushing

### Error Recovery
- Use `git reset --soft HEAD~1` to undo last commit if needed
- Regenerate Manifest files after fixing SRC_URI issues
- Clean up temporary files with `ebuild <package>.ebuild clean`
- Use varaible substitution correctly in ebuilds (e.g., `${PV}`, `${P}`)

### Quality Assurance
- `pkgdev push` automatically runs QA checks before pushing
- Test installation on clean system when possible
- Verify all dependencies are correctly specified
- Check for proper file permissions and locations