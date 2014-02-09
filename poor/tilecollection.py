# -*- coding: utf-8-unix -*-

# Copyright (C) 2014 Osmo Salomaa
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""A collection of map tiles visible on screen."""

__all__ = ("TileCollection",)


class Tile:

    """Properties of a map tile."""

    def __init__(self, uid):
        """Initialize a :class:`Tile` object."""
        self.x = -1
        self.y = -1
        self.zoom = -1
        self.uid = uid


class TileCollection:

    """A collection of map tiles visible on screen."""

    def __init__(self):
        """Initialize a :class:`TileCollection` object."""
        self._tiles = []

    def get_free(self, xmin, xmax, ymin, ymax, zoom):
        """Return a random tile outside bounds."""
        for tile in self._tiles:
            if (tile.zoom != zoom or
                tile.x + 1 < xmin or
                tile.x > xmax or
                tile.y + 1 < ymin or
                tile.y > ymax):
                return tile

        # If no free tile found, initialize a new one.
        tile = Tile(len(self._tiles)+1)
        self._tiles.append(tile)
        return(tile)

    def has(self, x, y, zoom):
        """Return ``True`` if collection contains tile at position."""
        for tile in self._tiles:
            if (tile.zoom == zoom and tile.x == x and tile.y == y):
                return True
        return False
