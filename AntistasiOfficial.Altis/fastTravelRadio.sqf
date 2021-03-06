private ["_roads","_pos","_posicion","_grupo"];

_markers = markers + [guer_respawn] - campsFIA;

_esHC = false;

if (count hcSelected player > 1) exitWith {hint localize "STR_HINTS_FTR_YCSOGOTFT"};
if (count hcSelected player == 1) then {_grupo = hcSelected player select 0; _esHC = true} else {_grupo = group player};

_jefe = leader _grupo;

if ((_jefe != player) and (!_esHC)) exitWith {hint localize "STR_HINTS_FTR_OAGLCAFFT"};

if (({isPlayer _x} count units _grupo > 1) and (!_esHC)) exitWith {hint localize "STR_HINTS_FTR_YCFTWOPIYG"};

if (player != player getVariable ["owner",player]) exitWith {hint localize "STR_HINTS_FTR_YCFTWYACAI"};

_chequeo = false;
{_enemigo = _x;
{if (((side _enemigo == side_red) or (side _enemigo == side_green)) and (_enemigo distance _x < 500) and (not(captive _enemigo))) exitWith {_chequeo = true}} forEach units _grupo;
if (_chequeo) exitWith {};
} forEach allUnits;

if (_chequeo) exitWith {Hint localize "STR_HINTS_FTR_YCFTWENTG"};

{if ((vehicle _x!= _x) and ((isNull (driver vehicle _x)) or (!canMove vehicle _x))) then
	{
	if (not(vehicle _x isKindOf "StaticWeapon")) then {_chequeo = true};
	}
} forEach units _grupo;

if (_chequeo) exitWith {Hint localize "STR_HINTS_FTR_YCFTIYDHADIAY"};

posicionTel = [];

if (_esHC) then {hcShowBar false};
hint localize "STR_HINTS_FTR_COTZYWTT";
openMap true;
onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

_posicionTel = posicionTel;

if (count _posicionTel > 0) then
	{
	_base = [_markers, _posicionTel] call BIS_Fnc_nearestPosition;

	if (_base in mrkAAF) exitWith {hint localize "STR_HINTS_FTR_YCFTTAECZ"; openMap [false,false]};

	//experimental
	if (_base in campsFIA) exitWith {hint localize "STR_HINTS_FTR_YCFTTC"; openMap [false,false]};
	//if (_base in puestosFIA) exitWith {hint localize "STR_HINTS_FTR_YCFTTRNW"; openMap [false,false]};

	{
		if (((side _x == side_red) or (side _x == side_green)) and (_x distance (getMarkerPos _base) < 500) and (not(captive _x))) then {_chequeo = true};
	} forEach allUnits;

	if (_chequeo) exitWith {Hint localize "STR_HINTS_FTR_YCFTTAAUAOWE"; openMap [false,false]};

	if (_posicionTel distance getMarkerPos _base < 50) then
		{
		_posicion = [getMarkerPos _base, 10, random 360] call BIS_Fnc_relPos;
		_distancia = round (((position _jefe) distance _posicion)/200);
		if (!_esHC) then {disableUserInput true; cutText ["Fast traveling, please wait","BLACK",2]; sleep 2;} else {hcShowBar false;hcShowBar true;hint format [localize "STR_HINTS_FTR_MG1TD",groupID _grupo]; sleep _distancia;};
		_forzado = false;
		if (!isMultiplayer) then {if (not(_base in forcedSpawn)) then {_forzado = true; forcedSpawn = forcedSpawn + [_base]}};
		if (!_esHC) then {sleep _distancia};
		{
		_unit = _x;
		//_unit hideObject true;
		_unit allowDamage false;
		if (_unit != vehicle _unit) then
			{
			if (driver vehicle _unit == _unit) then
				{
				sleep 3;
				_tam = 10;
				while {true} do
					{
					_roads = _posicion nearRoads _tam;
					if (count _roads < 1) then {_tam = _tam + 10};
					if (count _roads > 0) exitWith {};
					};
				_road = _roads select 0;
				_pos = position _road findEmptyPosition [1,50,typeOf (vehicle _unit)];
				vehicle _unit setPos _pos;
				};
			if ((vehicle _unit isKindOf "StaticWeapon") and (!isPlayer (leader _unit))) then
				{
				_pos = _posicion findEmptyPosition [1,50,typeOf (vehicle _unit)];
				vehicle _unit setPosATL _pos;
				};
			}
		else
			{
			if (!isNil {_unit getVariable "ASunconscious"}) then
				{
				if (!(_unit getVariable "ASunconscious")) then
					{
					_posicion = _posicion findEmptyPosition [1,50,typeOf _unit];
					_unit setPosATL _posicion;
					if (isPlayer leader _unit) then {_unit setVariable ["ASrearming",false]};
					_unit doWatch objNull;
					_unit doFollow leader _unit;
					};
				}
			else
				{
				_posicion = _posicion findEmptyPosition [1,50,typeOf _unit];
				_unit setPosATL _posicion;
				};
			};

		//_unit hideObject false;
		} forEach units _grupo;
		if (!_esHC) then {disableUserInput false;cutText ["You arrived to destination","BLACK IN",3]} else {hint format [localize "STR_HINTS_FTR_G1ATD",groupID _grupo]};
		if (_forzado) then {forcedSpawn = forcedSpawn - [_base]};
		sleep 5;
		{_x allowDamage true} forEach units _grupo;
		}
	else
		{
		Hint localize "STR_HINTS_FTR_YMCNMUYC";
		};
	};
openMap false;