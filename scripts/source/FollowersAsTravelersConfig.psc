Scriptname FollowersAsTravelersConfig extends SKI_ConfigBase  

int installID
int uninstallID
int[] followersIDS

int PageIndex

int Function GetVersion()
	return 20190303
EndFunction 

Event OnVersionUpdate(int a_version)
	if (CurrentVersion == 0) ; new game
		;
	elseif (a_version != CurrentVersion)
		OnConfigInit()
		; MainQuest.Reboot()
	endif
EndEvent

Event OnConfigInit()
	Pages = new string[9]
	Pages[0] = "Config"
	
	Pages[1] = "1-24"
	Pages[2] = "25-48"
	Pages[3] = "49-72"
	Pages[4] = "73-96"
	Pages[5] = "97-120"
	Pages[6] = "121-144"

	Pages[7] = "1-24 Place"
	Pages[8] = "25-48 Place"
	Pages[9] = "49-72 Place"
	Pages[10] = "73-96 Place"
	Pages[11] = "97-120 Place"
	Pages[12] = "121-144 Place"
	
	followersIDS = new int[24]
EndEvent

Event OnPageReset(string page)
	if (page == "" || page == "Config")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		installID = AddToggleOption("Start/Apply", false)
		uninstallID = AddToggleOption("Stop/Uninstall", false)
	else
		PageIndex = Pages.Find(page) - 1
		int flistidx
		if (PageIndex > 3) ; place page
			flistidx = (PageIndex - 4) * 24
		else
			flistidx = PageIndex * 24
		endif
		
		SetCursorFillMode(LEFT_TO_RIGHT)
		SetCursorPosition(0)
		
		Actor act
		string name
		string place
		
		int i = 0
		int n = flistidx
		int max = n + 24
		while n != max
			act = FaTActorList.GetAt(n) as Actor
			if (act)
				name = act.GetLeveledActorBase().GetName()
				
				if (PageIndex > 3) ; place page
					place = act.GetParentCell().GetName()
					AddTextOption(name, place)
				else
					int rank = act.GetFactionRank(FaTSearchedFaction)
					if (rank == 0)
						followersIDS[i] = AddToggleOption(name, false)
					elseif (rank > 0)
						followersIDS[i] = AddToggleOption(name, true)
					endif
				endif
			else
				AddTextOption("-", "")
			endif
			n += 1
			i += 1
		endWhile
	endif
EndEvent

Event OnOptionSelect(int option)
	if (option == installID)
		ShowMessage("Close MCM menu and look notification.", false)
		FaTScript.TravelAll()
	elseif (option == uninstallID)
		ShowMessage("Close MCM menu and look notification.", false)
		FaTScript.CleanAll()
		
	elseif (followersIDS.Find(option) > -1)
		int idx = followersIDS.Find(option)
		int flistidx = (PageIndex * 24) + idx
		Actor act = FaTActorList.GetAt(flistidx) as Actor
		
		int rank = act.GetFactionRank(FaTSearchedFaction)
		if (rank == 0)
			FaTScript.TravelStart(act)
			SetToggleOptionValue(option, true)
		elseif (rank > 0)
			FaTScript.TravelStop(act, false)
			SetToggleOptionValue(option, false)
		else
			; debug.trace("[FaT] FactionRank " + rank)
		endif
	endif
EndEvent

FollowersAsTravelersMain Property FaTScript Auto

FormList Property FaTActorList  Auto  
Faction Property FaTSearchedFaction  Auto  
