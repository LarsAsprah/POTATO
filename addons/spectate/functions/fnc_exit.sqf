/*
 * Author: AACO
 * Function used to exit spectator
 * Should only be called by events
 *
 * Arguments:
 * Nothing
 *
 * Return Value:
 * Nothing
 *
 * Examples:
 * [] call potato_spectate_fnc_exit;
 *
 * Public: Yes
 */

#include "script_component.hpp"
TRACE_1("Params",_this);

if (GVAR(running)) then {
    // remove spectate chat channel
    setCurrentChannel SIDE_CHANNEL_INDEX;
    (missionNamespace getVariable QGVAR(channel)) radioChannelRemove [GVAR(unit)];

    // enable other chats
    [true] call FUNC(setChannels);

    // Handle cameras/lights
    GVAR(cam) cameraEffect ["Terminate", "BACK"];
    player switchCamera "INTERNAL";
    deleteVehicle GVAR(cam);

    { deleteVehicle _x; } forEach GVAR(camLights);
    GVAR(camLights) = [];

    // reset spectator view distance
    setViewDistance GVAR(oldViewDistance);

    // disable ACRE spectate
    [false] call acre_api_fnc_setSpectator;

    // remove sepectator event handlers
    [GVAR(thingsToDrawEH)] call CBA_fnc_removePerFrameHandler;
    GVAR(thingsToDrawEH) = nil;

    [GVAR(straggleUpdateEH)] call CBA_fnc_removePerFrameHandler;
    GVAR(straggleUpdateEH) = nil;

    removeMissionEventHandler ["Draw3D", GVAR(draw3DEH)];
    GVAR(draw3DEH) = nil;

    removeMissionEventHandler ["EachFrame", GVAR(camTick)];
    GVAR(camTick) = nil;

    // enable post process effects
    BIS_fnc_feedback_allowPP = true;

    // close display
    OVERLAY closeDisplay 1;

    // mark spectator as stopped
    GVAR(running) = false;

    // remove events from active units
    [false] call FUNC(setEventsOnActiveUnits);

    // remove advanced throwing EH
    [QACEGVAR(advanced_throwing,throwFiredXEH), GVAR(advancedThrowingEH)] call CBA_fnc_removeEventHandler;
    GVAR(advancedThrowingEH) = nil;
};
