# Changelog

## Unreleased

## 0.4.0 (2022-09-29)

*   Drop Ruby 2.5 support.
*   Add Ruby 3.1 support.
*   Add `#initialize_regular_file` method.
*   Update development dependencies.
*   Resolve new RuboCop offenses.
*   Add `bundle-audit` CI task.

## 0.3.1 (2021-04-16)

*   Fix Ruby warnings (and specs fails).

## 0.3.0 (2021-04-16)

*   Remake the question from "Do you want to edit?" to "What to do?".
*   Add `replace-and-edit` answer.
*   Change menu layout from inline to rows with numbers.
    I have no idea how to make easier shortcut for `replace-and-edit`.
*   Add Ruby 3 support and CI.
*   Update development dependencies.

## 0.2.0 (2020-09-30)

*   Abort program on try to edit file without `$EDITOR` environment variable.
    Don't rely on external code, also abort only on try to edit.
*   Update dependencies.
*   Improve Cirrus CI config.

## 0.1.0 (2020-06-02)

*   Initial release.
