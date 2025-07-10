# Contributing to ARK Team Admin & Recovery Toolkit

Welcome! Contributions to the toolkit are encouraged and appreciated. Please read this guide for best practices.

## Coding Style

- Use Bash best practices: quote variables, avoid `eval` unless necessary, check exit statuses, handle errors gracefully.
- Keep functions modular and well-documented.
- Use the logging and color output functions for user feedback.

## Adding Hardware Detection/Drivers

1. Add a new `detect_*` function in the script.
2. Add it to the main detection section.
3. If it uses an AUR package, use the `aur_install_prompt` helper.
4. Update the summary reporting so users see the new check.

## Pull Requests

- Fork, branch, and open PRs for all changes.
- Test your changes using `--dry-run` and on real hardware if possible.
- Update the README and this file if you add new features.
- Use clear commit messages.

## Issues and Feature Requests

- Use GitHub Issues for bugs or feature requests.
- Use the discussion board for community brainstorming, hardware reports, etc.

Thank you for helping make ARK Team Admin & Recovery Toolkit awesome!
