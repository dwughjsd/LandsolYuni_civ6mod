# Little Lead-rical Leader Pack- Modbuddy project and Wwise project

This mod aims to be a good (though still having some unsolvable issues) example for creating a custom leader and civilization for Sid Meier's Civilization VI. The built playable mod is released on Steam Workshop as Little Leadrical Leader Pack.

All art assets and music files are extracted from the mobile game Princess Connect Re:Dive (with some modifications to make them fit in Civ6), I don't own copyright of them.

Codes that I wrote can be seen as if they're in public domain, so that you can copy, edit, redistribute them or do whatever you want.

Simply copy `LandsolLittleLeadricalRelease` folder to mods directory of Civ6 if you just simply want to play prebuilt mod.

Separated projects for Yuni, Kokkoro (Princess) and Kyoka are DEPRECATED and will no longer receive updates. They are still good (and sometimes might be better) examples for mod projects though.

# About Wwise project

The Wwise project included in this repository can be used as a template for adding background music and leader speeches to your custom leaders and civilizations.

This project won't be finished without [Wwiser](https://github.com/bnnm/wwiser), a Wwise soundbank parser. I used this handy tool to understand how exactly a music soundbank should be.

The project itself tries to replicate how 2 official civilizations, Vietnam and Portugal, play their music. This method has some issues (E.g. (1) if you stay at diplomacy screen for long, sometimes music of main game will start to play automatically without stopping the music of the diplomacy screen; (2) sometimes you can only hear music of your playing civilization in multiplayer game; etc. Yes, the two official civs has EXACTLY the same behaviors, so blame Firaxis for all these problems), but the way that other official civilizations play their music has compatibility issues (you have to recreate Interactive Music Hierarchy for ALL OFFICIAL CIVS AND ALL MOD CIVS YOU ARE USING to let the music works properly), letting the "Portuguese method" being the only method suitable for most modders.

To make your music play properly, here are some keypoints:
1.  Ensure that ALL your Music Segments has a Custom Cue named **ExitCustom**. The cue tells the game engine when to switch to another music track, so without setting these custom cues the music will stop playing after one track is finished. Many modders set their music to loop forever as a workaround to the issue, but you won't hear music from other civilizations if you do so.
2.  All the Switch Containers named like "id658623902" are dummy containers which perform as references to in-game civilization and leader (diplomacy screen) music (so that music from official civilizations and other mod civs that properly implemented their music will play). All settings in these dummy containers WILL NOT BE INCLUDED in the final soundbank you build, so what you need to do is to create them, edit their ShortID (with a text editor) to the proper value, and don't touch them again. These dummies will be used when you are setting audio Events. The game engine will properly control in-game music once you have set the right ID.
3.  Renaming an existed item in Hierarchies and Event Actions WILL NOT change its ShortID (The fastest way to regenerate ShortIDs of your items is to duplicate them, save once, delete the old items and rename the duplication). The names of items are not saved into the final soundbank, so the ShortIDs of your items will be the only names of them in the eyes of the game. This should be taken into account when you are creating another mod with custom music to prevent conflicts.
4.  Make sure every Event is set properly. Every Event has a set of parameter settings itself, some of the settings need special attention. For example, if fade in/out time is not set properly, there will be glitchs when switching target civilizations in diplomacy screen.
5.  "Use Game Parameter" settings in the Game_Location switch group is completely useless. The settings is even not saved into the final soundbank needed, but into the generated Init.bnk. It's an old myth in music modding, but it's actually of no use at all.
6.  For a single civilization all the music track should be of the SAME sample rate and sampling precision (48kHz/16bit recommended). Some tracks will not play properly if the formats of them are inconsistent.

It's similar to set leader speeches for custom mods, however you need a 3D model for your leader to actually play his/her voice. KevinLiu made a model containing a canvas for still images, so that Yuni's leader speeches can be played. You can use .fgx and .wig files (they can be used directly when copied to your own mods with only renaming is needed, but you need to edit .geo files with a text editor to correctly refer to your renamed .fgx and .wig files) in the ModBuddy project to help creating your own pseudo-3D leaders. Another key for speeches is that you need to create a .xml metadata file of your speeches soundbank. It's recommended to set your Wwise project to Generate Per Bank Metadata File (in `Project/Project Settings/Soundbanks` or simply press `Shift+K` and switch to `Soundbanks` tab) so that you can easily create the XML needed.

# 关于 Wwise 工程

本仓库中包含的 Wwise 工程可作为为你的领袖和文明添加背景音乐和语音的模板。本工程在 [Wwiser](https://github.com/bnnm/wwiser) ，一款 Wwise soundbank 解析器，的帮助下完成。我用这个好用的小玩意儿研究出了音乐 soundbank 应该是什么样的。

本工程试图复原越南和葡萄牙两个文明播放音乐的方式。本法存在一些问题（例如：。1.如果你在外交面板等待一段时间，有时候主游戏画面的音乐会突然开始播放，和外交面板的音乐重叠；2.偶尔在多人游戏中只能听到自己文明的音乐，等等。没错，这两个文明的音乐有完全相同的问题，这是F社造成的），但其它官方文明的播放方式存在兼容性问题（需要重建所有官方文明和所有 mod 文明的 Interactive Music Hierarchy），因此葡萄牙法成为了对绝大多数 modder 而言唯一的合适方案。

要让音乐正常播放，需要以下要点：
1.  所有的 Music Segment 都需要添加一个名为 **ExitCustom** 的 Custom Cue。 这个时间戳是通知游戏引擎更换新曲目的，所以如果没有设置好，音乐就会在一曲结束后停止。早先许多 modder 会将自己的音乐设为无限循环，以此来规避这个问题，但这就会导致其它文明的音乐无法播放。
2.  所有名称形如“id658623902”的 Switch Container 都是虚设的 container，作用是引用游戏内的文明/领袖音乐播放机制（这样就可以正常播放游戏内的其它音乐）。不需要设置这些 container 的任何设置，因为最终构建出来的 soundbank 不会保留任何相关设置。总之，重建它们，把它们的 ShortID （用文本编辑器）改为合适的值以后，就不要再动了。在 Wwise 配置音频 Event 的时候，这些虚设的 container 就能派上用场，而游戏引擎在你设置了正确的 ID 的情况下就能正确控制音乐播放。
3.  重命名工程的 Hierarchy 和 Event 中已有的条目和不会改变它们的 ShortID （最快的给你的项目重新生成 ShortID 的方法是原地复制一份，保存一遍，删掉旧项，重命名新项）。条目的名称不会被保存到最终生成的 soundbank 中，所以实际上 ShortID 是游戏引擎眼中仅有的识别各种音频元素的方式。如果你正在写第二个 mod，就需要考虑这个问题，以免冲突。
4.  Event 的配置务必要妥当。每个 Event 都有一组参数设置，其中有一些需要特别注意。比如说如果淡入淡出时间设置不正确的话，在外交面板切文明的时候音频就会出问题。
5.  Game_Location switch group 的 "Use Game Parameter" 选项完全没有作用。这些设置会被存入 Init.bnk 而不是我们需要的 soundbank。这个选项是 mod 界古老的传说，但实际上它起不到任何作用。
6.  单个文明的所有音频应该使用相同的采样率和采样精度（推荐48kHZ/16bit）。如果格式不一致，有时候会有部分音乐播不出来。

领袖语音的设置方式类似，但你需要一个3D模型才能让领袖能说话。KevinLiu 做了一个带有单张画布的模型，可以用来显示静态图像，这使得优妮播放语音成为可能。你可以使用本工程的 .fgx 和 .wig 文件（可以直接复制使用，改名即可。不过 .geo 文件需要用文本编辑器改动，才能正确地引用你改名的文件）制作属于你自己的伪3D领袖。还有一个要点是需要为你的语音生成 .xml 元数据文件。建议把你的 Wwise 工程设置为 Generate Per Bank Metadata File （在 `Project/Project Settings/Soundbanks` ，或者直接按 `Shift+K` 再切换到 `Soundbanks` 选项卡），这样就可以弄出需要的 XML 了。