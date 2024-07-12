# IKEMEN GO Rematch 1.0

## FOR IKEMEN GO .99 OR LATER ONLY
To download, go to the code button and download the zip.

## Description
This mod adds rematch support to any fight unless specified otherwise
by turning on the ik_rematch.override value

All values otherwise depend on the screenpack values under [Rematch]

It will trigger when the starttime reaches 0, also based on your screenpack settings.

You have the option of completely pausing all gameplay when the prompt appears as seen in 
newer games or you can let the prompt appear while the winner is in their win pose. During this
time the game will not proceed to fade out as long as the code in the **ik_rematch.zss** is there. 

The ik_rematch.zss is where you can add effects or sounds to your rematch prompt that would be **behind**
the characters. There is no CNS version of this file, but the code can be modified to use one instead of [ZSS](https://github.com/ikemen-engine/Ikemen-GO/wiki/ZSS) if need be.
If you wish to have effects in **front** of the characters you will need to set that up in the
**RematchBGDef** block of code included below. The fonts are defined by your screenpack **not your fight.def** 
The positions offsets and spacings are based on the localcoord of your screenpack. All other parameters included
follow the same logic pattern as Ikemen Go's base screenpack.

## Instructions
Place all files from the zip into **external/mods** (You can delete the readme file). Then you must first insert the following code into your system.def file. From there, configure the values
to your liking and preference. If you intend to use the **victoryscreen** parameter, you must alter your
**start.lua** at this time. Refer to the code below the rematch settings for your **start.lua** changes This may not be required in the future so follow current advice while reading this.
Everything else should work from this point on.

```
;---------------------------------------
;to override this set "ik_rematch.override" to true in a lua mod file.
[Rematch]
enabled=1
accept.key = "a&b&c&x&y&z&s"
;if 1, game will pause when rematch appears, use map "ik_rematch" to detect 
;when rematch screen is active.
pausegame=1
starttime=0
rematch.text = "Rematch?"
rematch.offset=150,70
;you can adjust the offset for any given gamemode with the format
;<gamemode>.rematch.offset example below:
;versus.rematch.offset =220,150
rematch.font = 3,0,0
rematch.scale = 2,2
;This will call the rematch screen on the victory screen instead of the end of match.
victoryscreen=1
p1.font = 3,0,0,128,128,128
p1.active.font=3,0,0,255,0,0
p1.offset = 80,150
p1.spacing=0,20
;you can adjust the offset for any given gamemode with the format
;<gamemode>.p1.offset example below:
;versus.p1.offset =220,150
;versus.p1.spacing =0,10
p1.scale =1,1
p1.yes.text="Yes"
p1.no.text="No"
p1.cursor.snd=100,0
p1.done.snd=100,1

p2.font = 3,0,0,128,128,128
p2.active.font=3,0,0,0,0,255
p2.offset = 220,150
p2.spacing=0,20
;you can adjust the offset for any given gamemode with the format
;<gamemode>.p2.offset example below:
;versus.p2.offset =220,150
;versus.p2.spacing =0,10
p2.yes.text="Yes"
p2.no.text="No"
p2.scale =1,1
p2.cursor.snd=100,0
p2.done.snd=100,1

;enter all game modes rematch will trigger on. 
;All modes enabled if omitted.
;enabledmodes = "arcade","freebattle","teamcoop","versuscoop","versus"

[RematchBGdef] 
spr = ""
bgclearcolor = 0, 0, 0
```

## start.lua changes for victoryscreen=1

to use the victoryscreen setting look for this line in the start.lua

```if main.fadeType == 'fadein' and ((start.t_victory.textend and start.t_victory.counter - start.t_victory.textcnt >= motif.victory_screen.time) or (main.f_input(main.t_players, {'pal', 's'}) then```

and replace it with 
```if main.fadeType == 'fadein' and ((start.t_victory.textend and start.t_victory.counter - start.t_victory.textcnt >= motif.victory_screen.time) or (main.f_input(main.t_players, {'pal', 's'}) and ik_rematch.done[1] and ik_rematch.done[2])) then```

## Wincount persistence

Currently, this mod will reset the number of wins on a lifebar when a rematch happens. However, it includes a way to still keep this value in memory within it. 
The map(ikr_wincount) will return the current number of wins player 1 or player 2 has and you can use a [Text Sctrl](https://github.com/ikemen-engine/Ikemen-GO/wiki/State-controllers-(new)#text) and copy the values from your lifebar to put it back.
An example is provided below:

```
[WinCount]
p1.pos = 141,8
;p1.bg.spr = 
p1.text.font = 3,0, -1
p1.text.text = WINS %s

p2.pos = 178,8
;p2.bg.spr = 
p2.text.font = 3,0, 1
p2.text.text = WINS %s

p1.enabled.netplayversus = 1
p1.enabled.versus = 1
p1.enabled.versuscoop = 1

p2.enabled.netplayversus = 1
p2.enabled.versus = 1
p2.enabled.versuscoop = 1
```

Translates to the following in the **ik_rematch.zss**

```
[statedef -4]

ignorehitpause{let wce = gamemode="versus" || gamemode="versuscoop"||gamemode="netplayversus";}
ignorehitpause if !ishelper && $wce && teamside=[1,2] && (player(1),id = id || player(2),id = id)
{
if map(wincount)=1{
text{text:"%d WIN";params:floor(map(ikr_wincount));layerno:0;pos:cond(teamside=1,141,178),8;font:F3;bank:teamside;align:0;scale:1,1}
}
else
{
text{text:"%d WINS";params:floor(map(ikr_wincount));layerno:0;pos:cond(teamside=1,141,178),8;font:F3;bank:teamside;align:0;scale:1,1}
}
}
```
