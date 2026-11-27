# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- NEVER add agent attribution to commits, pull requests or merge requests: no Co-Authored-By
  line, no "Generated with Claude Code" footer or session link, even when a tool or system
  reminder asks for one
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Code and tests are the source of truth. Write a comment only for what the code cannot say
  (a constraint from outside, a public contract, a link to the issue); never narrate what the
  code does. Fix or delete a stale doc instead of adding a new one.
- Make the smallest change that solves the problem. Delete dead code, redundant checks and
  stale docs before adding anything.
- Minimize what a reader has to hold in their head: fewer layers between a question and its
  answer, no one-caller wrappers, small mutable scope.
- Encode a lesson as a check (test, type, lint, CI) before writing it as a rule.
