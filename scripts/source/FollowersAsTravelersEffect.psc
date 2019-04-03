Scriptname FollowersAsTravelersEffect extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	self._init()
EndEvent

Function _init()
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

Function TravelStart(Actor target)
	target.AddToFaction(FaTSearchedFaction)
	ActorUtil.AddPackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	FaTActorList.AddForm(target)
	debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " goes on a trip")
	
	if (!target.IsEssential() && target.GetLeveledActorBase().IsUnique())
		target.GetActorBase().SetEssential(true)
		target.SetFactionRank(FaTSearchedFaction, 1)
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " +Essential")
	endif
EndFunction

Function TravelStop(Actor target)
	ActorUtil.RemovePackageOverride(target, FaTMultiLocTravelInnsAndJarls)
	debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + "'s travel stoppped")
	
	if (target.GetFactionRank(FaTSearchedFaction) == 1)
		target.GetActorBase().SetEssential(false)
		target.SetFactionRank(FaTSearchedFaction, 0)
		debug.notification("FaT: " + target.GetLeveledActorBase().GetName() + " -Essential")
	endif
EndFunction

Quest Property FaTSearchQuest  Auto  
ReferenceAlias Property TargetRef  Auto  
Faction Property FaTSearchedFaction  Auto  
Package Property FaTMultiLocTravelInnsAndJarls  Auto  
FormList Property FaTActorList  Auto  
