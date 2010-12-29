/*
	Note :
	* Special thanks goes to Leif Linse (Zuu), who had originally written these codes.
	* This library should be compatible with SuperLib.Direction
	* The biggest difference (interface) was on "Turn" function.
	* You could see in the last few line, about how to do "Turn"
	  as same way as SuperLib.Direction Turn
*/

/*
	This file is part of AI Library - Direction
	Copyright (C) 2010  OpenTTD NoAI Community

	AI Library - Direction is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public
	License as published by the Free Software Foundation; either
	version 2 of the License, or (at your option) any later version.

	AI Library - Direction is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public
	License along with AI Library - Direction; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

require("version.nut");

print("Using AILib.Direction version " + revision);
print("Author           : OpenTTD NoAI Community");
print("License          : GPL version 2.0");
print("Original coder   : Leif Linse (Zuu)");
print("");

// internal direction constants
enum _dir_int {
	DIR_N = 0
	DIR_NE = 1
	DIR_E  = 2
	DIR_SE = 3
	DIR_S  = 4
	DIR_SW = 5
	DIR_W  = 6
	DIR_NW = 7
	DIR_FIRST = 0
	DIR_LAST = 7
	DIR_INVALID = 8
}

/**
 * Library class
 */
class Direction
{
	/// North
	static DIR_N = _dir_int.DIR_N;

	/// North East
	static DIR_NE = _dir_int.DIR_NE;

	/// East
	static DIR_E  = _dir_int.DIR_E;

	/// South East
	static DIR_SE = _dir_int.DIR_SE;

	///South
	static DIR_S  = _dir_int.DIR_S;

	///South West
	static DIR_SW = _dir_int.DIR_SW;

	///West
	static DIR_W  = _dir_int.DIR_W;

	///North West
	static DIR_NW = _dir_int.DIR_NW;

	/* Special values */
	///First Direction
	static DIR_FIRST = _dir_int.DIR_FIRST;

	///Last Direction
	static DIR_LAST = _dir_int.DIR_LAST;

	///Invalid Direction
	static DIR_INVALID = _dir_int.DIR_INVALID;

	///Used to turn dir 45 deg
	static TURN_45 = 1;

	///Used to turn dir 90 deg
	static TURN_90 = 2;

	///Used to turn dir 180 deg
	static OPPOSITE = 4;

	///Used to turn dir clock wise
	static CLOCKWISE = 1;

	///Used to turn dir anti clockwise
	static ANTI_CLOCKWISE = -1;

	/**
	 * Translates a direction value into a human readable string that
	 * can be used for logging.
	 * @param dir Direction
	 * @return String of direction
	 */
	static function GetDirString(dir) {
		switch (dir) {
			case _dir_int.DIR_N:  return "N";
			case _dir_int.DIR_NE: return "NE";
			case _dir_int.DIR_E:  return "E";
			case _dir_int.DIR_SE: return "SE";
			case _dir_int.DIR_S:  return "S";
			case _dir_int.DIR_SW: return "SW";
			case _dir_int.DIR_W:  return "W";
			case _dir_int.DIR_NW: return "NW";
			default:
				throw("Direction::GetDirString: invalid direction: " + dir);
				return -1;
		}
	}

	/**
	 * Check if dir is main direction (NW, SW, SE or NE)
	 * @param dir direction
	 * @return true if the direction is a main direction
	 */
	static function IsMainDir(dir) {
		switch (dir) {
				/* fall through */
			case _dir_int.DIR_NE:
			case _dir_int.DIR_SE:
			case _dir_int.DIR_SW:
			case _dir_int.DIR_NW:
				return true;
			default :
				return false;
		}
	}

	/**
	 * Check if dir is a diagonal direction (N, W, S or E)
	 * @param dir direction
	 * @return true if the direction is a diagonal direction
	 */
	static function IsDiagonalDir(dir) {
		switch (dir) {
				/* fall through */
			case _dir_int.DIR_N:
			case _dir_int.DIR_E:
			case _dir_int.DIR_S:
			case _dir_int.DIR_W:
				return true;
			default :
				return false;
		}
	}

	/**
	 * Get all 8 direction as AIList
	 * @param dir direction
	 * @return AIList with all directions in random order
	 */
	static function GetAllDirsInRandomOrder() {
		local dir_list = AIList();
		for (local dir = _dir_int.DIR_FIRST; dir != _dir_int.DIR_LAST + 1; dir++) {
			dir_list.AddItem(dir, AIBase.Rand());
		}
		return dir_list;
	}

	/**
	 * Get 4 main direction as AIList
	 * @param dir direction
	 * @return AIList with all main directions in random order
	 */
	static function GetMainDirsInRandomOrder() {
		local dir_list = AIList();
		local idir = import("AILib.Direction", "", 1);
		for (local dir = idir.DIR_FIRST; dir != idir.DIR_LAST + 1; dir++) {
			if (!idir.IsMainDir(dir)) continue;
			dir_list.AddItem(dir, AIBase.Rand());
		}
		return dir_list;
	}

	/**
	 * Get 4 main direction as AIList
	 * @param dir direction
	 * @return AIList with all diagonal directions in random order
	 */
	static function GetDiagonalDirsInRandomOrder() {
		local dir_list = AIList();
		local idir = import("AILib.Direction", "", 1);
		for (local dir = idir.DIR_FIRST; dir != idir.DIR_LAST + 1; dir++) {
			if (!idir.IsDiagonalDir(dir)) continue;
			dir_list.AddItem(dir, AIBase.Rand());
		}
		return dir_list;
	}

	/* If these function fails they return Direction.DIR_INVALID */

	/**
	 * Get a direction on move from a tile to adjacent tile
	 * @param tile Starting tile
	 * @param adjacent_tile Next tile
	 * @return the direction you have to go from tile to it adjacent
	 * @pre adjacent_tile must be adjacent fom tile
	 */
	static function GetDirectionToAdjacentTile(tile, adjacent_tile {
		local rel_x = AIMap.GetTileX(adjacent_tile) - AIMap.GetTileX(tile);
		local rel_y = AIMap.GetTileY(adjacent_tile) - AIMap.GetTileY(tile);

		local rel_dir = [
							[_dir_int.DIR_N, [-1, -1]],
							[_dir_int.DIR_NE, [-1,  0]],
							[_dir_int.DIR_E,  [-1,  1]],
							[_dir_int.DIR_SE, [ 0,  1]],
							[_dir_int.DIR_S,  [ 1,  1]],
							[_dir_int.DIR_SW, [ 1,  0]],
							[_dir_int.DIR_W,  [ 1, -1]],
							[_dir_int.DIR_NW, [ 0, -1]]
						];

		foreach(dir in rel_dir) {
			local rel = dir[1];
			local X = 0;
			local Y = 1;
			if (rel[X] == rel_x && rel[Y] == rel_y) return dir[0];
		}

		return _dir_int.DIR_INVALID;
	}

	/* Returns the direction you have to move from tile1 to reach tile2.
	 * This function do not require tile1 and tile2 to be adjacent, but
	 * they must be exactly in one of the eight directions.
	 */

	/**
	 * Get a direction on move from a tile1 to tile2
	 * @param tile1 Starting tile
	 * @param tile2 Next tile
	 * @return the direction you have to go from tile1 to tile2
	 */
	static function GetDirectionToTile(tile1, tile2) {
		local rel_x = AIMap.GetTileX(tile2) - AIMap.GetTileX(tile1);
		local rel_y = AIMap.GetTileY(tile2) - AIMap.GetTileY(tile1);
		if (rel_x == 0 && rel_y == 0) {
			return _dir_int.DIR_INVALID;
		} else if (abs(rel_x) >= 1 && abs(rel_y) >= 1) {
			// Neither of NE, NW, SW, SE
			if (abs(rel_x) == abs(rel_y)) {
				// Same amplitude of rel_x and rel_y => N, W, S or E.
				if (rel_x <= -1 && rel_y <= -1) return _dir_int.DIR_N;
				if (rel_x <= -1 && rel_y >=  1) return _dir_int.DIR_E;
				if (rel_x >=  1 && rel_y >=  1) return _dir_int.DIR_S;
				if (rel_x >=  1 && rel_y <= -1) return _dir_int.DIR_W;
				// Error
				return _dir_int.DIR_INVALID;
			} else {
				// Not a valid direction
				return _dir_int.DIR_INVALID;
			}
		} else {
			// either rel_x or rel_y is 0 and the other has a value > 0.
			if (rel_x < 0) return _dir_int.DIR_NE;
			if (rel_y > 0) return _dir_int.DIR_SE;
			if (rel_x > 0) return _dir_int.DIR_SW;
			if (rel_y < 0) return _dir_int.DIR_NW;
			// Error
			return _dir_int.DIR_INVALID;
		}
		// Error
		return _dir_int.DIR_INVALID;
	}

	/**
	 * Turn direction
	 * @param dir Current direction
	 * @param type TURN_45 deg or TURN_90 deg
	 * @param direction CLOCKWISE or ANTI_CLOCKWISE
	 * @param num Number of turn. Negative value would reverse direction.
	 * @return new direction after turn
	 */
	static function Turn(dir, type, direction, num) {
		local delta_dir = _dir_int.DIR_LAST - _dir_int.DIR_FIRST + 1;
		local count = num * direction; // 90 = 45 * 2
		local new_dir = count * type + dir;
		if (new_dir > _dir_int.DIR_LAST) {
			new_dir = new_dir % delta_dir;
		} else {
			while (new_dir < _dir_int.DIR_FIRST) {
				new_dir += delta_dir;
			}
		}
		return new_dir;
	}

	//
	// theese functions are only for "compatibility mode" with
	// pre-exist SupperLib. You should be able to write them
	// inside your AI instead
	/*
	static function TurnDirClockwise45Deg(dir, num_45_deg)
	{
		local idir = import("AILib.Direction","",1);
		return idir.Turn(dir, idir.TURN_45, idir.CLOCKWISE, num_45_deg);
	}

	static function TurnDirAntiClockwise45Deg(dir, num_45_deg)
	{
		local idir = import("AILib.Direction","",1);
		return idir.Turn(dir, idir.TURN_45, idir.ANTI_CLOCKWISE, num_45_deg);
	}

	static function TurnDirClockwise90Deg(dir, num_90_deg)
	{
		local idir = import("AILib.Direction","",1);
		return idir.Turn(dir, idir.TURN_90, idir.CLOCKWISE, num_90_deg);
	}

	static function TurnDirAntiClockwise90Deg(dir, num_90_deg)
	{
		local idir = import("AILib.Direction","",1);
		return idir.Turn(dir, idir.TURN_90, idir.ANTI_CLOCKWISE, num_90_deg);
	}

	static function OppositeDir(dir)
	{
		local idir = import("AILib.Direction","",1);
		return idir.Turn(dir, idir.TURN_90, idir.CLOCKWISE, 2);
	}
	*/
}
