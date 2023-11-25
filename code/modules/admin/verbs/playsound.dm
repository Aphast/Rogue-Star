var/list/sounds_cache = list()

/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))	return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	sounds_cache += S

	if(tgui_alert(usr, "Do you ready?\nSong: [S]\nNow you can also play this sound using \"Play Server Sound\".", "Confirmation request", list("Play","Cancel")) == "Cancel")
		return

	var/our_volume = tgui_input_number(usr, "How loud? (1-100)", title = "Volume", default = 100, max_value = 100, min_value = 0)

	if(!our_volume)
		return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	for(var/mob/M in player_list)
		if(M.is_preference_enabled(/datum/client_preference/play_admin_midis))
			M << sound(uploaded_sound, channel = VOLUME_CHANNEL_ADMIN_SOUNDS , volume = our_volume * M.client.get_preference_volume_channel(VOLUME_CHANNEL_ADMIN_SOUNDS))

	feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	var/our_volume = tgui_input_number(usr, "How loud? (1-100)", title = "Volume", default = 100, max_value = 100, min_value = 0)

	if(!our_volume)
		return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(src.mob, S, our_volume , 0, 0, preference = /datum/client_preference/play_admin_midis, volume_channel = VOLUME_CHANNEL_ADMIN_SOUNDS)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_z_sound(S as sound)
	set category = "Fun"
	set name = "Play Z Sound"
	if(!check_rights(R_SOUNDS))	return
	var/target_z = mob.z
	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	sounds_cache += S

	if(tgui_alert(usr, "Do you ready?\nSong: [S]\nNow you can also play this sound using \"Play Server Sound\".", "Confirmation request", list("Play","Cancel")) == "Cancel")
		return

	var/our_volume = tgui_input_number(usr, "How loud? (1-100)", title = "Volume", default = 100, max_value = 100, min_value = 0)

	if(!our_volume)
		return

	log_admin("[key_name(src)] played sound [S] on Z[target_z]")
	message_admins("[key_name_admin(src)] played sound [S] on Z[target_z]", 1)
	for(var/mob/M in player_list)
		if(M.is_preference_enabled(/datum/client_preference/play_admin_midis) && M.z == target_z)
			M << sound(uploaded_sound, channel = VOLUME_CHANNEL_ADMIN_SOUNDS , volume = our_volume * M.client.get_preference_volume_channel(VOLUME_CHANNEL_ADMIN_SOUNDS))

	feedback_add_details("admin_verb","PZS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "--CANCEL--"
	sounds += sounds_cache

	var/melody = tgui_input_list(usr, "Select a sound from the server to play", "Server sound list", sounds, "--CANCEL--")

	if(melody == "--CANCEL--")	return

	play_sound(melody)
	feedback_add_details("admin_verb","PSS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
/client/proc/cuban_pete()
	set category = "Fun"
	set name = "Cuban Pete Time"

	message_admins("[key_name_admin(usr)] has declared Cuban Pete Time!", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'cubanpetetime.ogg'

	for(var/mob/living/carbon/human/CP in human_mob_list)
		if(CP.real_name=="Cuban Pete" && CP.key!="Rosham")
			to_chat(CP, "Your body can't contain the rhumba beat")
			CP.gib()


/client/proc/bananaphone()
	set category = "Fun"
	set name = "Banana Phone"

	message_admins("[key_name_admin(usr)] has activated Banana Phone!", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'bananaphone.ogg'


/client/proc/space_asshole()
	set category = "Fun"
	set name = "Space Asshole"

	message_admins("[key_name_admin(usr)] has played the Space Asshole Hymn.", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'sound/music/space_asshole.ogg'


/client/proc/honk_theme()
	set category = "Fun"
	set name = "Honk"

	message_admins("[key_name_admin(usr)] has creeped everyone out with Blackest Honks.", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'honk_theme.ogg'*/
