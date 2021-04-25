Stack Exchange Activity Archiver is a small program to scrape and save your own questions, answers, and comments on Stack Exchange sites like Stack Overflow. Such an archive provides a backup in case your writing is deleted, and allows you to search your writing with a text editor. The items are collected into a JSON file. Chat-room activity is not collected.

To run the program, install it with ``pip install stack_archiver`` and then use a command like

::

    python3 -m stack_archiver ~/my_se_backup.json stackoverflow:1451346,softwarerecs:29171,stats:14076

Say ``python3 -m stack_archiver --help`` for command-line options.  The program doesn't require authentication. Run the program periodically as a cron job, or as part of your backup process, to keep the archive up to date.

License
============================================================

This program is copyright 2021 Kodi B. Arfer.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the `GNU General Public License`_ for more details.

.. _`GNU General Public License`: http://www.gnu.org/licenses/
