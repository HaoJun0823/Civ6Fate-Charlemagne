-----------------------------------------------------------------------------------------
-- Jan 5, 2019 By HaoJun0823
-- This script comes from https://forums.civfanatics.com/threads/tutorial-adding-music-to-your-mod-civilization.621830/
-- Thanks FurionHuang,Gedemon,HerdByFate,raen.
-- Today, there is still no perfect way to add music.
-- If someone can know how to do it, please reply at the address above, thank you!
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Gedemon's Script
-- Override the restart button

--2019/01/05
--If you click the Cancel button, the menu will be transparent and cannot be closed.
--So I canceled this menu and if it was triggered incorrectly, the auto save can still be called back.

--2019/08/13
--For Red Style.

-----------------------------------------------------------------------------------------
local LEADER_NAME = "LEADER_CHARLEMAGNE_SABER" --Set your Leader
local LEADER_EXTRA_NAME = "LEADER_CHARLEMAGNE_SABER_EXTRA" --For Red Style.

function OnReallyRestart()
    -- Start a fresh game using the existing game configuration.

	LuaEvents.RestartGame() -- add the function(s) you want to call before restarting a game to this lua event : LuaEvents.RestartGame.Add(myFunction)
    Network.RestartGame()
end

function OnEnterGame()   -- override the default callback once all the files are loaded...
    ContextPtr:LookUpControl("/InGame/TopOptionsMenu/RestartButton"):RegisterCallback( Mouse.eLClick, OnReallyRestart )   
end


-----------------------------------------------------------------------------------------
-- FurionHuang's Script
-- Stop the music when exit game.
-----------------------------------------------------------------------------------------


function OnUIExitGame()
    stopMusic()
end

function OnPlayerDefeatStopMusic( player, defeat, eventID)
    --print("Defeat Event Activated.");
   stopMusic()
end

function OnTeamVictoryStopMusic(team, victory, eventID)
    --print("Victory Event Activated.");
   stopMusic()
end

function OnOpenDiplomacyActionView(otherPlayerID)
	local playerConfig:table = PlayerConfigurations[otherPlayerID]
	local leaderName = playerConfig:GetLeaderTypeName()

	if £¨leaderName == LEADER_NAME or leaderName == LEADER_EXTRA_NAME£© and otherPlayerID == Game.GetLocalPlayer() then
		 UI.PlaySound("Play_Leader_Music_CHARLEMAGNE_SABER");
	end
	
		

end

function DiplomacyActionView_ShowIngameUI()	
	--Now you need stop your played music.
	stopMusic()
end

----------Events----------
function init() -- I can write this to optimize the event.

	
  print("Initialization event loading.")

  local localPlayerID:number = Game.GetLocalPlayer();
  local playerConfig:table = PlayerConfigurations[localPlayerID]
  local leaderName = playerConfig:GetLeaderTypeName()
 
  if leaderName == LEADER_NAME or leaderName == LEADER_EXTRA_NAME then -- Consistent with the above variables
	-- There are local machine things.
	Events.LeaveGameComplete.Add(OnUIExitGame);
	Events.PlayerDefeat.Add(OnPlayerDefeatStopMusic);
	Events.TeamVictory.Add(OnTeamVictoryStopMusic);
	Events.LoadScreenClose.Add(OnEnterGame);
	LuaEvents.RestartGame.Add(OnUIExitGame);
	print(leaderName.." is local player, add event finished!")
	else
	print(leaderName.." not local player, don't need add event!")
	

  end

	--There are global game things(Other player need listen diplomacuy music)
	--So you need add a stop Diplomacy Music event for Play_Music event.
	LuaEvents.DiplomacyRibbon_OpenDiplomacyActionView.Add(OnOpenDiplomacyActionView);
	--Events.GamePauseStateChanged.Add(OnGamePauseStateChanged);
	LuaEvents.DiplomacyActionView_ShowIngameUI.Add(DiplomacyActionView_ShowIngameUI);
	--LuaEvents.TopPanel_OpenDiplomacyActionView.Add(OnOpenDiplomacyActionView);	
	--LuaEvents.DiploScene_SceneClosed.Add(stopDiplomacyMusic);
	--Events.UserRequestClose.Add( stopDiplomacyMusic );


	print("Event loaded.")
end

init()
-----------------------------------------------------------------------------------------
-- Done.
-----------------------------------------------------------------------------------------
function stopMusic() -- Use this method to stop music to fix something or you can write to other methods.

 UI.PlaySound("Stop_Music_CHARLEMAGNE_SABER_FRANCIA");
 UI.PlaySound("Stop_Leader_Music_CHARLEMAGNE_SABER");


end


