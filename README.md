# Progress Indicator Plasmoid

This is a customizable progress indicator widget/plasmoid for KDE Plasma 5. It can help you monitor task progress or track your preparation rate for an exam.

## Screenshots

![Compact mode screenshot](/screenshots/compact.png)
![Expanded compact mode screenshot](/screenshots/expanded.png)
![Full mode screenshot](/screenshots/full.png)

## Installation

This applet can be installed on systems running KDE Plasma 5.24 or higher, but it has not been tested on Plasma 6.

The .plasmoid file can be installed from Plasma Widgets Explorer or with `kpackagetool5 -i <filename>` command. Alternatively you can run `kpackagetool5 -i .` from inside the package directory.

## Usage

It has two layouts based on the available space. When placed on a panel, it shows only the task name, a progress bar and the progress level (%). Clicking on it expands the applet and shows the full layout, where you can edit the task name, total steps, and completed steps. When placed on the desktop, it always shows the full layout.
