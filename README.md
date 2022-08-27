# Yuni leads Landsol - Modbuddy project and Wwise project

This mod aims to be a good (though still having some unsolvable issues) example for creating a custom leader and civilization for Sid Meier's Civilization VI. The built playable mod is released on Steam Workshop as Little Leadrical Leader Pack.

All art assets and music files are extracted from the mobile game Princess Connect Re:Dive (with some modifications to make them fit in Civ6), I don't own copyright of them.

Codes that I wrote can be seen as if they're in public domain, so that you can copy, edit, redistribute them or do whatever you want.

See Releases if you just simply want to play prebuilt mod.

# About Wwise project

The Wwise project included in this repository can be used as a template for adding background music and leader speeches to your custom leaders and civilizations.

This project won't be finished without [Wwiser](https://github.com/bnnm/wwiser), a Wwise soundbank parser. I used this handy tool to understand how exactly a music soundbank should be.

The project itself tries to replicate how 2 official civilizations, Vietnam and Portugal, play their music. This method has some issues (E.g. (1) if you stay at diplomacy screen for long, sometimes music of main game will start to play automatically without stopping the music of the diplomacy screen; (2) sometimes you can only hear music of your playing civilization in multiplayer game; etc. Yes, the two official civs has EXACTLY the same behaviors, so blame Firaxis for all these problems), but the way that other official civilizations play their music has compatibility issues (you have to recreate Interactive Music Hierarchy for ALL OFFICIAL CIVS AND ALL MOD CIVS YOU ARE USING to let the music works properly), letting the "Portuguese method" being the only method suitable for most modders.

To make your music play properly, here are some keypoints:
1.  Ensure that ALL your Music Segments has a Custom Cue named **ExitCustom**. The cue tells the game engine when to switch to another music track, so without setting these custom cues the music will stop playing after one track is finished. Many modders set their music to loop forever as a workaround to the issue, but you won't hear music from other civilizations if you do so.
2.  All the Switch Containers named like "id658623902" are dummy containers which perform as references to in-game civilization and leader (diplomacy screen) music (so that music from official civilizations and other mod civs that properly implemented their music will play). All settings in these dummy containers WILL NOT BE INCLUDED in the final soundbank you build, so what you need to do is to create them, edit their ShortID to the proper value, and don't touch them again. These dummies will be used when you are setting audio Events. The game engine will properly control in-game music once you have set the right ID.
3.  Renaming an existed item in Hierarchies WILL NOT change its ShortID (The fastest way to regenerate ShortIDs of your items is to duplicate them, save once, delete the old items and rename the duplication). The names of items are not saved into the final soundbank, so the ShortIDs of your items will be the only names of them in the eyes of the game. This should be taken into account when you are creating another mod with custom music to prevent conflicts.
4.  Make sure every Event is set properly. Every Event has a set of parameter settings itself, some of the settings need special attention. For example, if fade in/out time is not set properly, there will be glitchs when switching target civilizations in diplomacy screen.
5.  "Use Game Parameter" settings in the Game_Location switch group is completely useless. The settings is even not saved into the final soundbank needed, but into the generated Init.bnk. It's an old myth in music modding, but it's actually of no use at all.

It's similar to set leader speeches for custom mods, however you need a 3D model for your leader to actually play his/her voice. KevinLiu made a model containing a canvas for still images, so that Yuni's leader speeches can be played. You can use .fgx and .wig files (they can be used directly when copied to your own mods with only renaming is needed, but you need to edit .geo files with a text editor to correctly refer to your renamed .fgx and .wig files) in the ModBuddy project to help creating your own pseudo-3D leaders. Another key for speeches is that you need to create a .xml file with the same name with your speeches soundbank. Most lines in this XML file can be copied from Wwise-generated SoundBanks.xml, and you can check how the Landsol_Speech.xml of Yuni is to set your own one.
