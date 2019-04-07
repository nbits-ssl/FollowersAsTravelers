Scriptname FollowersAsTravelersMain extends Quest  

Function TravelAll()
	int idx = 100
	int retrycount = 5
	
	while idx > 0
		FaTSearchQuest.Stop()
		Utility.Wait(0.5)
		FaTSearchQuest.Start()
		Utility.Wait(0.2)
		Actor target = TargetRef.GetActorRef()
		
		if (target)
			self.TravelStart(target)
			retrycount = 5 ; reset
			Utility.Wait(2.0)
		elseif (retrycount > 0)
			debug.notification("FaT: no target, retry(" + retrycount + ")")
			retrycount -= 1
			Utility.Wait(2.0)
		else
			int n = FaTActorList.GetSize()
			debug.notification("FaT: Completed, total " + n + " Followers As Travellers")
			idx = 0 ; end loop
		endif
		
		idx -= 1
	endwhile
EndFunction

Function CleanAll()
	Actor act
	int n = FaTActorList.GetSize()
	while n >= 0
		n -= 1
		act = FaTActorList.GetAt(n) as Actor
		if (act)
			self.TravelStop(act, true)
		endif
	endwhile
	FaTActorList.Revert()
	debug.notification("FaT: Completed")
EndFunction

Function TravelStart(Actor target)
	string name = target.GetLeveledActorBase().GetName()
	
	target.AddToFaction(FaTSearchedFaction)
	target.SetFactionRank(FaTSearchedFaction, 1)
	ActorUtil.AddPackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	FaTActorList.AddForm(target)
	debug.notification("FaT: " + name + " goes on a trip")
	
	if (!target.IsEssential() && target.GetLeveledActorBase().IsUnique())
		target.GetActorBase().SetEssential(true)
		target.SetFactionRank(FaTSearchedFaction, 2)
		; debug.notification("FaT: " + name + " +Essential")
	endif
	
	target.EvaluatePackage()
EndFunction

Function TravelStop(Actor target, bool _remove)
	string name = target.GetLeveledActorBase().GetName()
	
	ActorUtil.RemovePackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	if (_remove)
		debug.notification("FaT: " + name + "'s travel stoppped & removed")
	else
		debug.notification("FaT: " + name + "'s travel stoppped")
	endif
	
	if (target.GetFactionRank(FaTSearchedFaction) == 2)
		target.GetActorBase().SetEssential(false)
		; debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " -Essential")
	endif
	if (_remove)
		target.RemoveFromFaction(FaTSearchedFaction)
	else
		target.SetFactionRank(FaTSearchedFaction, 0)
	endif
	
	target.EvaluatePackage()
EndFunction

Quest Property FaTSearchQuest  Auto  
ReferenceAlias Property TargetRef  Auto  
Faction Property FaTSearchedFaction  Auto  
Package Property FaTMultiLocTravelInnsAndJarls  Auto  
FormList Property FaTActorList  Auto  
