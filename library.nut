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

class LibDirection extends AILibrary
{
	function GetAuthor()      { return "OpenTTD NoAI Community"; }
	function GetName()        { return "Direction"; }
	function GetShortName()   { return "CLDF"; }
	function GetDescription() { return "A collection of direction functions. Rev:" + revision; }
	function GetVersion()     { return version; }
	function GetAPIVersion()  { return "1.0"; }
	function GetDate()        { return "2010-06-06"; }
	function CreateInstance() { return "Direction"; }
	function GetCategory()    { return "AILib"; }
}

RegisterLibrary(LibDirection());
