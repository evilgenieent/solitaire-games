#!/bin/sh
#
# Copyright 2012 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

BUILDDIR=..
DOMAIN=solitaire-games

for f in `find $TARGET -type f -name "*.po"`
    do
        LANG=${f%.*}
        EXTENSION=${f#*.}
        mkdir -p $BUILDDIR/locale/$LANG/LC_MESSAGES
        msgfmt $f -o $BUILDDIR/locale/$LANG/LC_MESSAGES/$DOMAIN.mo
    done
