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
		act = FaTActorList.GetAt(n) as Actor
		self.TravelStop(act, true)
		n -= 1
	endwhile
	FaTActorList.Revert()
	debug.notification("FaT: Completed")
EndFunction

Function TravelStart(Actor target)
	if (FaTActorList.Find(target) != -1)
		return ; fail safe
	endif
	
	target.AddToFaction(FaTSearchedFaction)
	target.SetFactionRank(FaTSearchedFaction, 1)
	ActorUtil.AddPackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	FaTActorList.AddForm(target)
	debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " goes on a trip")
	
	if (!target.IsEssential() && target.GetLeveledActorBase().IsUnique())
		target.GetActorBase().SetEssential(true)
		target.SetFactionRank(FaTSearchedFaction, 2)
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " +Essential")
	endif
	
	target.EvaluatePackage()
EndFunction

Function TravelStop(Actor target, bool _remove)
	ActorUtil.RemovePackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	if (_remove)
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + "'s travel stoppped & removed")
	else
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + "'s travel stoppped")
	endif
	
	if (target.GetFactionRank(FaTSearchedFaction) == 2)
		target.GetActorBase().SetEssential(false)
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " -Essential")
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
