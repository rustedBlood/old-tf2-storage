/**
* File: War3Source_Raven.sp
* Description: Raven's Private Race for War3Source.
* Author(s): Remy Lebeau (Adapted from xDr.HaaaaaaaXx Terran Space Marine)
*/

#pragma semicolon 1
#include <sourcemod>
#include <sdktools_tempents>
#include <sdktools_functions>
#include <sdktools_tempents_stocks>
#include <sdktools_entinput>
#include <sdktools_sound>
#include "W3SIncs/War3Source_Interface"

// War3Source stuff
new thisRaceID;

// Chance/Data Arrays
new Float:M4A1Chance[6] = { 0.0, 0.2, 0.4, 0.6, 0.8, 1.0 };
new Float:DamageMultiplier[6] = { 0.0, 0.2, 0.4, 0.6, 0.8, 1.0 };
new Float:StimAttackSpeed[6] = { 1.0, 1.1, 1.2, 1.3, 1.4, 1.5 };
new Float:StimSpeed[6] = { 1.0, 1.1, 1.2, 1.3, 1.4, 1.5 };
new Health[6] = { 0, 25, 50, 75, 100, 125 };
new HaloSprite, BeamSprite;
new bool:bAmmo[MAXPLAYERS];
new Clip1Offset;

new SKILL_M4A1, SKILL_HP, SKILL_DMG, ULT_STIM;

public Plugin:myinfo = 
{
    name = "War3Source Race - Raven",
    author = "xDr.HaaaaaaaXx / Remy Lebeau",
    description = "Raven's Private race for War3Source.",
    version = "1.0.0.1",
    url = ""
};

public OnMapStart()
{
    HaloSprite = PrecacheModel( "materials/sprites/halo01.vmt" );
    BeamSprite = PrecacheModel( "materials/sprites/lgtning.vmt" );
    HookEvent( "weapon_reload", WeaponReloadEvent );
    PrecacheModel("models/player/ssg/raven_ct/slow.mdl", true);
    PrecacheModel("models/player/ssg/raven_t/slow.mdl", true);
}

public OnPluginStart()
{
    Clip1Offset = FindSendPropOffs( "CBaseCombatWeapon", "m_iClip1" );
}

public OnWar3PluginReady()
{
    thisRaceID = War3_CreateNewRace( "Raven [PRIVATE]", "raven" );
    
    SKILL_M4A1 = War3_AddRaceSkill( thisRaceID, "Rage Quitter", "A chance to create a P90 (with 1000 bullets).", false, 5 );    
    SKILL_HP = War3_AddRaceSkill( thisRaceID, "Kill Me If You Can", "You get a LOT more HP.", false, 5 );    
    SKILL_DMG = War3_AddRaceSkill( thisRaceID, "P90 Rockets", "You can do more dmg to enemy.", false, 5 );
    ULT_STIM = War3_AddRaceSkill( thisRaceID, "Just Cause 1k Bullets Is Not Enough", "Damage yourself a little in returns for super fast fire rate.", true, 5 );
    War3_CreateRaceEnd( thisRaceID );
}

public InitPassiveSkills( client )
{
    if( War3_GetRace( client ) == thisRaceID )
    {
        new client_team = GetClientTeam( client );
        if (client_team == TEAM_T)
        {
            //SetEntityModel(client, "models/player/ssg/raven_t/slow.mdl");
        }
        if (client_team == TEAM_CT)
        {
            //SetEntityModel(client, "models/player/ssg/raven_ct/slow.mdl");
        }
        new hp_level = War3_GetSkillLevel( client, thisRaceID, SKILL_HP );
        if( hp_level > 0 )
        {
            //War3_SetMaxHP( client, Health[hp_level] );
            War3_SetBuff(client, iAdditionalMaxHealth, thisRaceID, Health[hp_level]);
        }
        if( War3_GetMaxHP( client ) > GetClientHealth( client ) )
        {
            War3_HealToMaxHP( client, ( War3_GetMaxHP( client ) - GetClientHealth( client ) ) );
        }
        War3_SetBuff( client, fMaxSpeed, thisRaceID, 1.0 );
        War3_SetBuff( client, fAttackSpeed, thisRaceID, 1.0 );
        
    }
}

public OnRaceChanged( client, oldrace, newrace )
{
    if( newrace == thisRaceID )
    {
        if( IsPlayerAlive( client ) )
        {
            InitPassiveSkills( client );
        }
    }
    else
    {
        W3ResetAllBuffRace( client, thisRaceID );
    }
}

public OnSkillLevelChanged( client, race, skill, newskilllevel )
{
    InitPassiveSkills( client );
}

public OnWar3EventSpawn( client )
{
    new race = War3_GetRace( client );
    if( race == thisRaceID )
    {
        bAmmo[client] = false;
        
        new skill_m4a1 = War3_GetSkillLevel( client, thisRaceID, SKILL_M4A1 );
        if( skill_m4a1 > 0 && GetRandomFloat( 0.0, 1.0 ) <= M4A1Chance[skill_m4a1] )
        {
            GivePlayerItem( client, "weapon_xm1014" );
            CreateTimer( 1.0, SetWepAmmo, client );
            bAmmo[client] = true;
        }
        InitPassiveSkills( client );
    }
}

public OnWar3EventDeath( victim, attacker )
{
    W3ResetAllBuffRace( victim, thisRaceID );
}

public Action:SetWepAmmo( Handle:timer, any:client )
{
    new race = War3_GetRace( client );
    if( ValidPlayer( client, true ) && race == thisRaceID )
    {
        new wep_ent = W3GetCurrentWeaponEnt( client );
        SetEntData( wep_ent, Clip1Offset, 30, 4 );

    }
}

public OnWar3EventPostHurt(victim, attacker, Float:damage, const String:weapon[32], bool:isWarcraft)
{
    if( W3GetDamageIsBullet() && ValidPlayer( victim, true ) && ValidPlayer( attacker, true ) && GetClientTeam( victim ) != GetClientTeam( attacker ) )
    {
        if( War3_GetRace( attacker ) == thisRaceID )
        {
            new skill_dmg = War3_GetSkillLevel( attacker, thisRaceID, SKILL_DMG );
            if( !Hexed( attacker, false ) && skill_dmg > 0 && GetRandomFloat( 0.0, 1.0 ) <= 0.30 )
            {
                new String:wpnstr[32];
                GetClientWeapon( attacker, wpnstr, 32 );
                if( !StrEqual( wpnstr, "weapon_knife" ) && !W3HasImmunity( victim, Immunity_Skills  ) )
                {
                    new Float:start_pos[3];
                    new Float:target_pos[3];
                
                    GetClientAbsOrigin( attacker, start_pos );
                    GetClientAbsOrigin( victim, target_pos );
                
                    start_pos[2] += 40;
                    target_pos[2] += 40;
                
                    TE_SetupBeamPoints( start_pos, target_pos, BeamSprite, HaloSprite, 0, 0, 1.0, 3.0, 6.0, 0, 0.0, { 100, 255, 55, 255 }, 0 );
                    TE_SendToAll();
                    
                    War3_DealDamage( victim, RoundToFloor( damage * DamageMultiplier[skill_dmg] ), attacker, DMG_BULLET, "space_marine_crit" );
                
                    W3PrintSkillDmgHintConsole( victim, attacker, War3_GetWar3DamageDealt(), SKILL_DMG );
                    W3FlashScreen( victim, RGBA_COLOR_RED );
                }
            }
        }
    }
}

public WeaponReloadEvent( Handle:event, const String:name[], bool:dontBroadcast )
{
    new client = GetClientOfUserId( GetEventInt( event, "userid" ) );
    new race = War3_GetRace( client );
    if( race == thisRaceID )
    {
        new skill_m4a1 = War3_GetSkillLevel( client, race, SKILL_M4A1 );
        if( skill_m4a1 > 0 && bAmmo[client] )
        {
            CreateTimer( 3.5, SetWepAmmo, client );
        }
    }
}

public OnUltimateCommand( client, race, bool:pressed )
{
    if( race == thisRaceID && pressed && IsPlayerAlive( client ) && !Silenced( client ) )
    {
        new ult_level = War3_GetSkillLevel( client, race, ULT_STIM );
        if( ult_level > 0 )
        {
            War3_DealDamage( client, 20, client, DMG_BULLET, "space_marine_stim" );
            
            War3_SetBuff( client, fMaxSpeed, thisRaceID, StimSpeed[ult_level] );
            War3_SetBuff( client, fAttackSpeed, thisRaceID, StimAttackSpeed[ult_level] );
            
            CreateTimer( 15.0, StopStim, client );
        }
        else
        {
            W3MsgUltNotLeveled( client );
        }
    }
}

public Action:StopStim( Handle:timer, any:client )
{
    new race = War3_GetRace( client );
    if( ValidPlayer( client, true ) && race == thisRaceID )
    {
        War3_SetBuff( client, fMaxSpeed, thisRaceID, 1.0 );
        War3_SetBuff( client, fAttackSpeed, thisRaceID, 1.0 );
    }
}