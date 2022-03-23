# Yuni leads Landsol - Modbuddy project and WWise project

This mod aims to be a good (though still having some unsolvable issues) example for creating a custom leader and civilization for Sid Meier's Civilization VI. It was published to Steam Workshop, but I decided to distribute it only through GitHub for now. 

All art assets and music files are extracted from the mobile game Princess Connect Re:Dive (with some modifications to make them fit in Civ6), I don't own copyright of them.

Codes that I wrote can be seen as if they're in public domain, so that you can copy, edit, redistribute them or do whatever you want.

A built version of this mod will be uploaded to Releases Soon™.

# About Wwise project

The Wwise project included in this repository can be used as a template for adding background music and leader speeches to your custom leaders and civilizations.

This project won't be finished without [Wwiser](https://github.com/bnnm/wwiser), a Wwise soundbank parser. I used this handy tool to understand what exactly a music soundbank should be.

The project itself tries to replicate how official Vietnam and Portugal civilization plays their music. This method has some issues (e.g. if you stay at diplomacy screen for long, sometimes music of main game will start to play automatically without stopping the music of the diplomacy screen; sometimes you can only hear music of your playing civilization in multiplayer game; etc.), but the way that other official civilizations play their music has compatibility issues (you have to recreate Interactive Music Hierarchy for ALL OFFICIAL CIVS AND ALL MOD CIVS YOU ARE USING to let the music works properly), letting the "Portuguese method" being the only method suitable for most modders.

To make your music play properly, here are some keypoints:
1.  Ensure that all your Music Segments has a Custom Cue named ExitCustom. The cue tells the game engine when to switch another track, so without setting cues the music will stop playing after one track. Many modders set their music to loop forever, but you won't hear music from other civilizations if you do so.
2.  All the Switch Containers named like "id658623902" are dummy containers which perform as references to in-game civilization and leader (diplomacy screen) music (so that music from official civilizations and other mod civs that properly implemented their music will play). All settings in these dummy containers SHOULD NOT BE INCLUDED in the final soundbank you build, so what you need to do is to create them, edit their ShortID to the proper value, and don't touch them again. They will be used when you are setting audio Events.
3.  Renaming a exist item in Hierarchies WILL NOT change its ShortID (The fastest way to regenerate ShortIDs of your items is to duplicate them, save once, delete the old items and rename the duplication). The names of items are not saved into the final soundbank, so the ShortIDs of your items will be the only names of them in the eyes of the game. This should be taken into account when you are creating another mod with custom music to prevent conflicts.
4.  Make sure every Event is set properly. Every Event has a set of settings for itself, some of the settings need special attention. If fade in/out time is not set properly, there will be glitchs when switching target civilizations in diplomacy screen.

It's similar to set leader speeches for custom mods. 