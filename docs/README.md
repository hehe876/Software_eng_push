# docs/

The subfolders here are gitignored — see `docs/.gitignore`. They hold
binary course deliverables: the SRS, WBS, Gantt chart, and diagrams. Kept
locally for reference and for submission, not pushed to GitHub, because Git
stores a whole new copy of a binary file on every edit and the diffs are
unreadable anyway. The folder structure itself stays tracked so a fresh
clone shows where things belong.

| Folder | Contents |
| --- | --- |
| `srs/` | The Software Requirements Specification. Source of truth for scope — every feature README and task brief points back to a `REQ-<feature>.<number>` label defined here. |
| `wbs/` | The Work Breakdown Structure. |
| `gantt/` | The Gantt chart (`.xlsx`). Sprint dates in the main `README.md` are copied from this. |
| `images/` | Diagrams — ER diagram, architecture diagram, and anything else generated for the report. |

## Setting up your local copy

These files live on the shared drive, not in Git. Download the current
versions from there into the matching folder above. If you're not sure
you have the latest version of something, ask in the group chat before
using it in a document.

## Notes worth keeping in mind

- The SRS is the source of truth for scope. Requirement labels follow
  `REQ-<feature>.<number>` (e.g. `REQ-3.2`) — check the actual number in
  `docs/srs/` before citing one in a PR or planner, don't guess.
- The ER diagram in `images/` must stay in sync with `db/schema.sql`. If
  the schema changes, the diagram needs updating too (and vice versa).
- **Do not run the Gantt `.xlsx` through a converter or an automated
  recalculation step.** It strips the conditional-formatting fill colours
  that draw the bars, and you'll end up with a spreadsheet of numbers and
  no chart.
- Diagrams were generated from Python scripts via `cairosvg`. If one needs
  to change, regenerate it from the script — don't hand-edit the PNG.
