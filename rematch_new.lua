--IKEMEN GO Rematch 1.5
--This mod adds rematch support to any fight unless specified otherwise
--by turning on the ik_rematch.override value
--All values otherwise depend on the rematch.def values under [Rematch]

local function createfont(t)

local s = textImgNew()

if t.font ==nil then
t.font = motif.Fnt[2]
end

textImgSetFont(s,t.font)
if t.localcoord==nil then
t.localcoord={ t.window[3],t.window[4]}
end

textImgSetFont(s, motif.Fnt[1])
textImgSetLocalcoord(s,  t.localcoord[1] , t.localcoord[2])



--textImgSetColor(s,  255, t.g or 255, t.b or 255, t.a or 256)
textImgSetText(s, "test")
textImgSetPos(s, t.x or 100, t.y or 100)
textImgSetScale(s, t.scaleX or 1, t.scaleY or 1)
textImgSetFocalLength(s,t.flength or 2048)


--textImgDebug(s, 'new font')
return s
end

local function updatefont(s,t)
textImgReset(s)

-- Other functions are optional - use them only if you want to change the default values.
if t.text ~=nil then
textImgSetText(s, t.text)
end



if t.font ~=nil then

local fnt = motif.Fnt[t.font]
textImgSetFont(s,fnt)
end



textImgSetAccel(s, t.ax or 0, t.ay or 0)
textImgSetAlign(s, t.align or 0)
textImgSetBank(s, t.bank or 0)
textImgSetColor(s, t.r or 256, t.g or 256, t.b or 256, t.a or 256)
textImgSetPos(s, t.x or 0, t.y or 0)
textImgAddPos(s,t.sx or 0,t.sy or 0)
textImgSetFriction(s, t.fx or 0, t.fy or 0)
textImgSetLayerno(s, t.layer or 0)
if t.xDist then
textImgSetMaxDist(s, t.xDist , t.yDist)
end
textImgSetScale(s, t.scaleX or 1, t.scaleY or 1)

textImgSetTextDelay(s, t.delay or 0)
textImgSetTextSpacing(s, t.spx or 0,t.spy or 0 )
textImgSetTextWrap(s, t.wrap or 0)
textImgSetVelocity(s, t.vx or 0, t.vy or 0)
if t.source then
textImgApplyVel(s, t.source or 0)
end

textImgSetXShear(s, t.xshear or 0)
textImgSetAngle(s, t.angle or 0)
textImgSetXAngle(s, t.xangle or 0)
textImgSetYAngle(s, t.yangle or 0)
--textImgSetProjection(s, t.projection)
--textImgSetFocalLegth(s, t.length or 1)

end

--It will trigger when the starttime reaches 0, also based on your screenpack settings.
local tt = gameOption("Common.States")
table.insert(tt, "external/mods/ik_rematch.zss")
modifyGameOption("Common.States", tt)

ik_rematch = {}
ik_rematch.sd=loadIni('external/mods/rematch.def')

--ik_rematch.sd.rematchbgdef.BGDef = bgNew('data/xjl/system.sff', 'external/mods/rematch.def', 'rematch', nil, 1)

local starttime =0
if ik_rematch.sd.rematch ~= nil then

ik_rematch.main = {TextSpriteData=createfont(
	{
	fontTuple=ik_rematch.sd.rematch.font,
	window={0,0,motif.info.localcoord[1],motif.info.localcoord[2]}
	})}
	
starttime=  ik_rematch.sd.rematch.starttime
end
ik_rematch.p = {}
ik_rematch.pa={}
ik_rematch.override=false
ik_rematch.wincount={0,0}



local hv =0

local txt_yes = {}
for i = 1, 2 do
	table.insert(txt_yes,{TextSpriteData=createfont(
	{
	window={0,0,motif.info.localcoord[1],motif.info.localcoord[2]}
	})})

	 --main.f_createTextImg(motif.select_info, 'selected_p'..i)
end

local txt_no =  {}
for i = 1, 2 do
	table.insert(txt_no,{TextSpriteData=createfont(
	{
	window={0,0,motif.info.localcoord[1],motif.info.localcoord[2]}
	})})

	 --main.f_createTextImg(motif.select_info, 'selected_p'..i)
end

ik_rematch.cursor={true,true}
ik_rematch.done={false,false}
local fade =false
local winadd=false

function ik_rematch.rematchend()

return ik_rematch.done[1] and ik_rematch.done[2]
end

local function rematchmode(p)
local result = false

if ik_rematch.sd.rematch.enabledmodes==nil then
return true
end

 for _, v in pairs(ik_rematch.sd.rematch.enabledmodes) do
        if v == gamemode() then 
            result = true 
        end
    end


return result
end

local function rematchtxtpos(p)

if p== nil then
if ik_rematch.sd.rematch[gamemode()] == nil then
return ik_rematch.sd.rematch.rematch.offset
end

 return ik_rematch.sd.rematch[gamemode()].rematch.offset
else

if ik_rematch.sd.rematch[gamemode()] == nil then

return {ik_rematch.sd.rematch['p'..p].offset,ik_rematch.sd.rematch['p'..p].spacing}
end

 return {ik_rematch.sd.rematch[gamemode()]['p'..p].offset,ik_rematch.sd.rematch[gamemode()]['p'..p].spacing}
 end
end

local enabled =true

function ik_rematch.run()

if ik_rematch.sd.rematch ==nil then
return 
end

if rematchmode() then
for i =1,2 do
player(i)
mapSet('ikr_wincount',ik_rematch.wincount[i],'set')
end

end



if not ik_rematch.override and roundstart() then

enabled=rematchmode()
starttime = ik_rematch.sd.rematch.starttime or 1

if start.t_victory~=nil then
start.t_victory.active=false
end
start.victoryInit=false
ik_rematch.cursor={true,true}
ik_rematch.done={false,false}
fade=false
for i =1,2 do
player(i)
mapSet('ik_rematch',0,'set')
mapSet('ik_rematch_on',0,'set')
end
winadd=false
hv =0
end

local canRematch = (((player(1) and ailevel()==0 and lose()) or (player(2) and ailevel()==0 and lose()))  or (gamemode('watch') or gamemode('freebattle'))) and enabled

if  matchover() then
for i =1,2 do
player(i)
mapSet('ik_rematch_on',1,'set')
end

	   if not winadd then
		if player(1) and win() then

	   ik_rematch.wincount[1] = ik_rematch.wincount[1]+1
	   else
	    ik_rematch.wincount[2] = ik_rematch.wincount[2]+1
	   end
	   winadd=true
	   end
end

if not ik_rematch.override and ik_rematch.sd.rematch.victoryscreen==0 then




if  ik_rematch.sd.rematch.enabled>=1 and matchover() and (roundstate()==4 )  and (canRematch or map('ik_rematch')>0) then 
if starttime>0 then
starttime=starttime-1

else

if not ik_rematch.rematchend() then
for i =1,2 do
player(i)
mapSet('ik_rematch',1,'set')
end

end
end



if (player(1) and  map('ik_rematch') >0 and starttime==0 ) and (not ik_rematch.rematchend()) then
if not fade and (ik_rematch.sd.rematch.pausegame>=1 ) then
togglePause(true)
fade=true
end

--bgDraw(ik_rematch.sd.rematchbgdef.BGDef, 0)


		updatefont(ik_rematch.main.TextSpriteData,{
							font =   ik_rematch.sd.rematch.rematch.font[1],
							bank =   ik_rematch.sd.rematch.rematch.font[2],
							align =   ik_rematch.sd.rematch.rematch.font[3],
							text =  ik_rematch.sd.rematch.rematch.text,
							x =      rematchtxtpos()[1],
							y =      rematchtxtpos()[2],
							scaleX = ik_rematch.sd.rematch.rematch.scale[1],
							scaleY = ik_rematch.sd.rematch.rematch.scale[2],
							r =      ik_rematch.sd.rematch.rematch.font[4],
							g =      ik_rematch.sd.rematch.rematch.font[5],
							b =      ik_rematch.sd.rematch.rematch.font[6],
							layer= 2
						})

	textImgDraw(ik_rematch.main.TextSpriteData)
	for side =1,2 do
	player(side) 
		if (ailevel()==0 or gamemode('watch')) then
			if not ik_rematch.done[side] then
					
				if getInput({side}, ik_rematch.sd.rematch.accept.key) then
					sndPlay(motif.Snd, ik_rematch.sd.rematch['p'..side].done.snd[1], ik_rematch.sd.rematch['p'..side].done.snd[2])
					ik_rematch.done[side]=true
				end
			
				if (commandGetState(main.t_cmd[side], '$U')  or commandGetState(main.t_cmd[side], '$D'))   then
				
					sndPlay(motif.Snd, ik_rematch.sd.rematch['p'..side].cursor.snd[1], ik_rematch.sd.rematch['p'..side].cursor.snd[2])
					if ik_rematch.cursor[side] then
						ik_rematch.cursor[side]=false
					else
						ik_rematch.cursor[side]=true
					end
				end
					
		end

		if ik_rematch.cursor[side] then
			updatefont(txt_yes[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].active.font[1],
				bank =   ik_rematch.sd.rematch['p'..side].active.font[2],
				align =  ik_rematch.sd.rematch['p'..side].active.font[3],
				text =  ik_rematch.sd.rematch['p'..side].yes.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].active.font[4],
				g =      ik_rematch.sd.rematch['p'..side].active.font[5],
				b =      ik_rematch.sd.rematch['p'..side].active.font[6],
				layer= 2
				})
				
				updatefont(txt_no[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].font[1],
				bank =   ik_rematch.sd.rematch['p'..side].font[2],
				align =  ik_rematch.sd.rematch['p'..side].font[3],
				text =  ik_rematch.sd.rematch['p'..side].no.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				sx=rematchtxtpos(side)[2][1],
				sy=rematchtxtpos(side)[2][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].font[4],
				g =      ik_rematch.sd.rematch['p'..side].font[5],
				b =      ik_rematch.sd.rematch['p'..side].font[6],
				layer= 2
				})
			else
				updatefont(txt_yes[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].font[1],
				bank =   ik_rematch.sd.rematch['p'..side].font[2],
				align =  ik_rematch.sd.rematch['p'..side].font[3],
				text =  ik_rematch.sd.rematch['p'..side].yes.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].font[4],
				g =      ik_rematch.sd.rematch['p'..side].font[5],
				b =      ik_rematch.sd.rematch['p'..side].font[6],
				layer= 2
				})
				
				updatefont(txt_no[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].active.font[1],
				bank =   ik_rematch.sd.rematch['p'..side].active.font[2],
				align =  ik_rematch.sd.rematch['p'..side].active.font[3],
				text =  ik_rematch.sd.rematch['p'..side].no.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				sx=rematchtxtpos(side)[2][1],
				sy=rematchtxtpos(side)[2][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].active.font[4],
				g =      ik_rematch.sd.rematch['p'..side].active.font[5],
				b =      ik_rematch.sd.rematch['p'..side].active.font[6],
				layer= 2
				})
			end
			textImgDraw(txt_yes[side].TextSpriteData)
			textImgDraw(txt_no[side].TextSpriteData)
					else
					    ik_rematch.done[side] =true
					end
					
		end
		if ik_rematch.rematchend() then
		togglePause(false)
		main.pauseMenu = false
		closeMenu()
		if ik_rematch.cursor[1] and ik_rematch.cursor[2] then
		
		reload()
		else
		for i =1,2 do
		player(i)
		mapSet('ik_rematch_on',0,'set')
		end

		end
		end
end

end
end
end

 
 
 local victoryend=false
function ik_rematch.victory() 

if ik_rematch.sd.rematch ==nil then
return 
end


if start.t_victory ~=nil then
victoryend = start.t_victory.textend
end
 
if ik_rematch.sd.rematch.victoryscreen==0 or ik_rematch.sd.rematch.endabled==0 then
ik_rematch.done={true,true}
end

if not ik_rematch.override and ik_rematch.sd.rematch.victoryscreen>=1 then

local canRematch = (((player(1) and ailevel()==0 and lose()) or (player(2) and ailevel()==0 and lose()))  or (gamemode('watch') or gamemode('freebattle'))) and rematchmode()

if hv==0 and start.t_victory.counter - start.t_victory.textcnt >= ik_rematch.sd.victory_screen.time-5 then
hv = start.t_victory.counter- start.t_victory.textcnt

end



if canRematch and ik_rematch.sd.rematch.enabled>=1 and matchover() then
for i =1,2 do
player(i)
mapSet('ik_rematch_on',1,'set')
end

end

if  ik_rematch.sd.rematch.enabled>=1 and matchover() and ( roundstate()==-1)  and (canRematch or map('ik_rematch')>0) and victoryend  then 



if not ik_rematch.rematchend() then
for i =1,2 do
player(i)
mapSet('ik_rematch',1,'set')
end

--lock victory counter
if hv>0 then
start.t_victory.counter = hv
end
end




if (player(1) and  map('ik_rematch')>0  and starttime==0 or (roundstate()==-1 )) and (not ik_rematch.rematchend()) then
if not fade and (roundstate()==-1  and starttime==0 ) then
--togglePause(true)
fade=true
end

	updatefont(ik_rematch.main.TextSpriteData,{
							font =   ik_rematch.sd.rematch.rematch.font[1],
							bank =   ik_rematch.sd.rematch.rematch.font[2],
							align =   ik_rematch.sd.rematch.rematch.font[3],
							text =  ik_rematch.sd.rematch.rematch.text,
							x =      rematchtxtpos()[1],
							y =      rematchtxtpos()[2],
							scaleX = ik_rematch.sd.rematch.rematch.scale[1],
							scaleY = ik_rematch.sd.rematch.rematch.scale[2],
							r =      ik_rematch.sd.rematch.rematch.font[4],
							g =      ik_rematch.sd.rematch.rematch.font[5],
							b =      ik_rematch.sd.rematch.rematch.font[6],
							layer= 2
						})

	textImgDraw(ik_rematch.main.TextSpriteData)
	for side =1,2 do
		if (player(side) and ailevel()==0 or gamemode('watch')) then
				if not ik_rematch.done[side] then
					
				if getInput({side}, ik_rematch.sd.rematch.accept.key)  then
					sndPlay(motif.Snd, ik_rematch.sd.rematch['p'..side].done.snd[1], ik_rematch.sd.rematch['p'..side].done.snd[2])
					ik_rematch.done[side]=true
				end

				if (commandGetState(main.t_cmd[side], '$U')  or commandGetState(main.t_cmd[side], '$D'))   then
				
					sndPlay(motif.Snd, ik_rematch.sd.rematch['p'..side].cursor.snd[1], ik_rematch.sd.rematch['p'..side].cursor.snd[2])
					if ik_rematch.cursor[side] then
						ik_rematch.cursor[side]=false
					else
						ik_rematch.cursor[side]=true
					end
				end
					
		end

		if ik_rematch.cursor[side] then
			updatefont(txt_yes[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].active.font[1],
				bank =   ik_rematch.sd.rematch['p'..side].active.font[2],
				align =  ik_rematch.sd.rematch['p'..side].active.font[3],
				text =  ik_rematch.sd.rematch['p'..side].yes.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].active.font[4],
				g =      ik_rematch.sd.rematch['p'..side].active.font[5],
				b =      ik_rematch.sd.rematch['p'..side].active.font[6],
				layer= 2
				})
				
				updatefont(txt_no[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].font[1],
				bank =   ik_rematch.sd.rematch['p'..side].font[2],
				align =  ik_rematch.sd.rematch['p'..side].font[3],
				text =  ik_rematch.sd.rematch['p'..side].no.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				sx=rematchtxtpos(side)[2][1],
				sy=rematchtxtpos(side)[2][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].font[4],
				g =      ik_rematch.sd.rematch['p'..side].font[5],
				b =      ik_rematch.sd.rematch['p'..side].font[6],
				layer= 2
				})
			else
				updatefont(txt_yes[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].font[1],
				bank =   ik_rematch.sd.rematch['p'..side].font[2],
				align =  ik_rematch.sd.rematch['p'..side].font[3],
				text =  ik_rematch.sd.rematch['p'..side].yes.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].font[4],
				g =      ik_rematch.sd.rematch['p'..side].font[5],
				b =      ik_rematch.sd.rematch['p'..side].font[6],
				layer= 2
				})
				
				updatefont(txt_no[side].TextSpriteData,{
				font =   ik_rematch.sd.rematch['p'..side].active.font[1],
				bank =   ik_rematch.sd.rematch['p'..side].active.font[2],
				align =  ik_rematch.sd.rematch['p'..side].active.font[3],
				text =  ik_rematch.sd.rematch['p'..side].no.text,
				x =      rematchtxtpos(side)[1][1],
				y =      rematchtxtpos(side)[1][2],
				sx=rematchtxtpos(side)[2][1],
				sy=rematchtxtpos(side)[2][2],
				scaleX = ik_rematch.sd.rematch['p'..side].scale[1],
				scaleY = ik_rematch.sd.rematch['p'..side].scale[2],
				r =      ik_rematch.sd.rematch['p'..side].active.font[4],
				g =      ik_rematch.sd.rematch['p'..side].active.font[5],
				b =      ik_rematch.sd.rematch['p'..side].active.font[6],
				layer= 2
				})
			end
			textImgDraw(txt_yes[side].TextSpriteData)
			textImgDraw(txt_no[side].TextSpriteData)
					else
					    ik_rematch.done[side] =true
					end
					
		end
					
		if ik_rematch.rematchend() then
		togglePause(false)
		main.pauseMenu = false
		closeMenu()
		if ik_rematch.cursor[1] and ik_rematch.cursor[2] then
		toggleNoSound(false)
		start.bgmround=0
		reload()
		else
		for i =1,2 do
		player(i)
		mapSet('ik_rematch_on',0,'set')
		end
		end
		end
end

end
end
end
 hook.add("game.victory", "rematch2", ik_rematch.victory)

function ik_rematch.resetwincount()
ik_rematch.wincount={0,0}
end



hook.add("main.t_itemname", "rematch3", ik_rematch.resetwincount)
 hook.add("loop", "rematch", ik_rematch.run)
