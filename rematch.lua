--IKEMEN GO Rematch 1.1
--This mod adds rematch support to any fight unless specified otherwise
--by turning on the ik_rematch.override value
--All values otherwise depend on the screenpack values under [Rematch]
--Use on nightly from January 2025 onwards

--It will trigger when the starttime reaches 0, also based on your screenpack settings.
modifyGameOption("Common.States", table.insert(gameOption("Common.States"), "external/mods/ik_rematch.zss"))
ik_rematch = {}
local starttime =0
if motif.rematch ~= nil then
ik_rematch.main = main.f_createTextImg(motif.rematch, 'rematch') 
starttime=  motif.rematch.starttime
end
ik_rematch.p = {}
ik_rematch.pa={}
ik_rematch.override=false




local hv =0
local txt_yes = {text:create({}),text:create({})}
local txt_no = {text:create({}),text:create({})}
ik_rematch.cursor={true,true}
ik_rematch.done={false,false}
local fade =false
local winadd=false

function ik_rematch.rematchend()

return ik_rematch.done[1] and ik_rematch.done[2]
end

local function rematchmode(p)
local result = false

if motif.rematch.enabledmodes==nil then
return true
end

 for _, v in pairs(motif.rematch.enabledmodes) do
        if v == gamemode() then 
            result = true 
        end
    end


return result
end

local function rematchtxtpos(p)

if p== nil then
if motif.rematch[gamemode()..'_rematch_offset'] == nil then
return ''
end

 return gamemode()..'_'
else

if motif.rematch[gamemode()..'_p'..p..'_offset'] == nil then
return ''
end

 return gamemode()..'_'
 end
end
local enabled =true
function ik_rematch.run()

if motif.rematch ==nil then
return 
end

charMapSet(1,'ikr_wincount',ik_rematch.wincount[1],'set')
charMapSet(2,'ikr_wincount',ik_rematch.wincount[2],'set')

if not ik_rematch.override and roundstart() then
enabled=rematchmode()
starttime = motif.rematch.starttime or 1
if start.t_victory~=nil then
start.t_victory.active=false
end
start.victoryInit=false
ik_rematch.cursor={true,true}
ik_rematch.done={false,false}
fade=false
charMapSet(1,'ik_rematch',0,'set')
charMapSet(1,'ik_rematch_on',0,'set')
charMapSet(2,'ik_rematch',0,'set')
charMapSet(2,'ik_rematch_on',0,'set')
winadd=false
hv =0
end

local canRematch = (((player(1) and ailevel()==0 and lose()) or (player(2) and ailevel()==0 and lose()))  or (gamemode('watch') or gamemode('freebattle'))) and enabled

if  matchover() then
charMapSet(1,'ik_rematch_on',1,'set')
charMapSet(2,'ik_rematch_on',1,'set')
	   if not winadd then
		if player(1) and win() then

	   ik_rematch.wincount[1] = ik_rematch.wincount[1]+1
	   else
	    ik_rematch.wincount[2] = ik_rematch.wincount[2]+1
	   end
	   winadd=true
	   end
end

if not ik_rematch.override and motif.rematch.victoryscreen==0 then




if  motif.rematch.enabled>=1 and matchover() and (roundstate()==4 )  and (canRematch or map('ik_rematch')>0) then 
if starttime>0 then
starttime=starttime-1

else
if not ik_rematch.rematchend() then
charMapSet(1,'ik_rematch',1,'set')
charMapSet(2,'ik_rematch',1,'set')
end
end



if (player(1) and  map('ik_rematch') >0 and starttime==0 ) and (not ik_rematch.rematchend()) then
if not fade and (motif.rematch.pausegame>=1 ) then
togglePause(true)
fade=true
end


	bgDraw(motif.rematchbgdef.bg, false)

	ik_rematch.main:update({
		font =   motif.rematch.rematch_font[1],
		bank =   motif.rematch.rematch_font[2],
		align =  motif.rematch.rematch_font[3],
		text =   motif.rematch.rematch_text,
		x =      motif.rematch[rematchtxtpos()..'rematch_offset'][1],
		y =    motif.rematch[rematchtxtpos()..'rematch_offset'][2],
		scaleX = motif.rematch.rematch_scale[1],
		scaleY = motif.rematch.rematch_scale[2],
		r =      motif.rematch.rematch_font[4],
		g =      motif.rematch.rematch_font[5],
		b =      motif.rematch.rematch_font[6],
		height = motif.rematch.rematch_font[7] or 1,
					})
	ik_rematch.main:draw()
	
		if (player(1) and ailevel()==0 or gamemode('watch')) then
			if not ik_rematch.done[1] then
					
				if  main.f_input({1}, main.f_extractKeys(motif.rematch.accept_key)) then
					sndPlay(motif.files.snd_data, motif.rematch.p1_done_snd[1], motif.rematch.p1_done_snd[2])
					ik_rematch.done[1]=true
				end
					
				if (commandGetState(main.t_cmd[1], '$U')  or commandGetState(main.t_cmd[1], '$D'))   then
					sndPlay(motif.files.snd_data, motif.rematch.p1_cursor_snd[1], motif.rematch.p1_cursor_snd[2])
					if ik_rematch.cursor[1] then
						ik_rematch.cursor[1]=false
					else
						ik_rematch.cursor[1]=true
					end
				end
					
		end
					
		local var =''
		local var2 =''
			if ik_rematch.cursor[1] then

				var = 'active_'
				var2=''
			else
				var = ''
				var2='active_'
			end
					
			txt_yes[1]:update({
						font =   motif.rematch['p1_'..var..'font'][1],
						bank =   motif.rematch['p1_'..var..'font'][2],
						align =  motif.rematch['p1_'..var..'font'][3],
						text =   motif.rematch.p1_yes_text,
							x =     motif.rematch[rematchtxtpos(1)..'p1_offset'][1] ,
						y =    motif.rematch[rematchtxtpos(1)..'p1_offset'][2],
						scaleX = motif.rematch.p1_scale[1],
						scaleY =motif.rematch.p1_scale[2],
					r =      motif.rematch['p1_'..var..'font'][4],
				g =      motif.rematch['p1_'..var..'font'][5],
				b =      motif.rematch['p1_'..var..'font'][6],
						height = 1,
					})
					txt_yes[1]:draw()
					
					txt_no[1]:update({
						font =   motif.rematch['p1_'..var2..'font'][1],
						bank =   motif.rematch['p1_'..var2..'font'][2],
						align =  motif.rematch['p1_'..var2..'font'][3],
						text =   motif.rematch.p1_no_text,
							x =     motif.rematch[rematchtxtpos(1)..'p1_offset'][1] + motif.rematch[rematchtxtpos(1)..'p1_spacing'][1],
						y =    motif.rematch[rematchtxtpos(1)..'p1_offset'][2]+ motif.rematch[rematchtxtpos(1)..'p1_spacing'][2],
						scaleX = motif.rematch.p1_scale[1],
						scaleY =motif.rematch.p1_scale[2],
					r =      motif.rematch['p1_'..var2..'font'][4],
				g =      motif.rematch['p1_'..var2..'font'][5],
				b =      motif.rematch['p1_'..var2..'font'][6],
						height = 1,
					})
					txt_no[1]:draw()
					else
					    ik_rematch.done[1] =true
					end
					
					if (player(2) and ailevel()==0)  then
					if not ik_rematch.done[2] then
					
					if main.f_input({2}, main.f_extractKeys(motif.rematch.accept_key))  then
					sndPlay(motif.files.snd_data, motif.rematch.p2_done_snd[1], motif.rematch.p2_done_snd[2])
					ik_rematch.done[2]=true
					end
					
					if (commandGetState(main.t_cmd[2], '$U')  or commandGetState(main.t_cmd[2], '$D'))   then
					sndPlay(motif.files.snd_data, motif.rematch.p2_cursor_snd[1], motif.rematch.p2_cursor_snd[2])
					ik_rematch.cursor[2]=not ik_rematch.cursor[2]
					end
					end
				
						local var =''
					local var2 =''
						if ik_rematch.cursor[2] then

						var = 'active_'
						var2=''
						else
					var = ''
					var2='active_'
					end
						txt_yes[2]:update({
						font =   motif.rematch['p2_'..var..'font'][1],
						bank =   motif.rematch['p2_'..var..'font'][2],
						align =  motif.rematch['p2_'..var..'font'][3],
						text =   motif.rematch.p2_yes_text,
							x =     motif.rematch[rematchtxtpos(2)..'p2_offset'][1],
						y =    motif.rematch[rematchtxtpos(2)..'p2_offset'][2],
						scaleX = motif.rematch.p2_scale[1],
						scaleY =motif.rematch.p2_scale[2],
					r =      motif.rematch['p2_'..var..'font'][4],
				g =      motif.rematch['p2_'..var..'font'][5],
				b =      motif.rematch['p2_'..var..'font'][6],
						height = 1,
					})
					txt_yes[2]:draw()
					
					txt_no[2]:update({
						font =   motif.rematch['p2_'..var2..'font'][1],
						bank =   motif.rematch['p2_'..var2..'font'][2],
						align =  motif.rematch['p2_'..var2..'font'][3],
						text =   motif.rematch.p2_no_text,
									x =     motif.rematch[rematchtxtpos(2)..'p2_offset'][1] + motif.rematch[rematchtxtpos(2)..'p2_spacing'][1],
						y =    motif.rematch[rematchtxtpos(2)..'p2_offset'][2]+ motif.rematch[rematchtxtpos(2)..'p2_spacing'][2],
						scaleX = motif.rematch.p2_scale[1],
						scaleY =motif.rematch.p2_scale[2],
					r =      motif.rematch['p2_'..var2..'font'][4],
				g =      motif.rematch['p2_'..var2..'font'][5],
				b =      motif.rematch['p2_'..var2..'font'][6],
						height = 1,
					})
					txt_no[2]:draw()
					else
					    ik_rematch.done[2] =true
					end
					
		if ik_rematch.rematchend() then
		togglePause(false)
		if ik_rematch.cursor[1] and ik_rematch.cursor[2] then
		
		reload()
		start.bgmround=0
		start.f_stageMusic()
		else
		charMapSet(1,'ik_rematch',0,'set')
		charMapSet(2,'ik_rematch',0,'set')
		end
		end
end

end
end
end
 hook.add("loop", "rematch", ik_rematch.run)
 local victoryend=false
function ik_rematch.victory() 

if motif.rematch ==nil then
return 
end


if start.t_victory ~=nil then
victoryend = start.t_victory.textend
end
 
if motif.rematch.victoryscreen==0 or motif.rematch.endabled==0 then
ik_rematch.done={true,true}
end

if not ik_rematch.override and motif.rematch.victoryscreen>=1 then

local canRematch = (((player(1) and ailevel()==0 and lose()) or (player(2) and ailevel()==0 and lose()))  or (gamemode('watch') or gamemode('freebattle'))) and rematchmode()

if hv==0 and start.t_victory.counter - start.t_victory.textcnt >= motif.victory_screen.time-5 then
hv = start.t_victory.counter- start.t_victory.textcnt

end



if canRematch and motif.rematch.enabled>=1 and matchover() then
charMapSet(1,'ik_rematch_on',1,'set')
charMapSet(2,'ik_rematch_on',1,'set')
end

if  motif.rematch.enabled>=1 and matchover() and ( roundstate()==-1)  and (canRematch or map('ik_rematch')>0) and victoryend  then 



if not ik_rematch.rematchend() then
charMapSet(1,'ik_rematch',1,'set')
charMapSet(2,'ik_rematch',1,'set')
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


	ik_rematch.main:update({
		font =   motif.rematch.rematch_font[1],
		bank =   motif.rematch.rematch_font[2],
		align =  motif.rematch.rematch_font[3],
		text =   motif.rematch.rematch_text,
		x =      motif.rematch.rematch_offset[1],
		y =    motif.rematch.rematch_offset[2],
		scaleX = motif.rematch.rematch_scale[1],
		scaleY = motif.rematch.rematch_scale[2],
		r =      motif.rematch.rematch_font[4],
		g =      motif.rematch.rematch_font[5],
		b =      motif.rematch.rematch_font[6],
		height = motif.rematch.rematch_font[7] or 1,
					})
	ik_rematch.main:draw()
	
		if (player(1) and ailevel()==0 or gamemode('watch'))  then
			if not ik_rematch.done[1] then
					
				if main.f_input({1}, main.f_extractKeys(motif.rematch.accept_key)) then
					sndPlay(motif.files.snd_data, motif.rematch.p1_done_snd[1], motif.rematch.p1_done_snd[2])
					ik_rematch.done[1]=true
				end
					
				if (commandGetState(main.t_cmd[1], '$U')  or commandGetState(main.t_cmd[1], '$D'))   then
					sndPlay(motif.files.snd_data, motif.rematch.p1_cursor_snd[1], motif.rematch.p1_cursor_snd[2])
					if ik_rematch.cursor[1] then
						ik_rematch.cursor[1]=false
					else
						ik_rematch.cursor[1]=true
					end
				end
					
		end
					
		local var =''
		local var2 =''
			if ik_rematch.cursor[1] then

				var = 'active_'
				var2=''
			else
				var = ''
				var2='active_'
			end
					
			txt_yes[1]:update({
						font =   motif.rematch['p1_'..var..'font'][1],
						bank =   motif.rematch['p1_'..var..'font'][2],
						align =  motif.rematch['p1_'..var..'font'][3],
						text =   motif.rematch.p1_yes_text,
									x =     motif.rematch[rematchtxtpos(1)..'p1_offset'][1],
						y =    motif.rematch[rematchtxtpos(1)..'p1_offset'][2],
						scaleX = motif.rematch.p1_scale[1],
						scaleY =motif.rematch.p1_scale[2],
					r =      motif.rematch['p1_'..var..'font'][4],
				g =      motif.rematch['p1_'..var..'font'][5],
				b =      motif.rematch['p1_'..var..'font'][6],
						height = 1,
					})
					txt_yes[1]:draw()
					
					txt_no[1]:update({
						font =   motif.rematch['p1_'..var2..'font'][1],
						bank =   motif.rematch['p1_'..var2..'font'][2],
						align =  motif.rematch['p1_'..var2..'font'][3],
						text =   motif.rematch.p1_no_text,
								x =     motif.rematch[rematchtxtpos(1)..'p1_offset'][1] + motif.rematch[rematchtxtpos(1)..'p1_spacing'][1],
						y =    motif.rematch[rematchtxtpos(1)..'p1_offset'][2]+ motif.rematch[rematchtxtpos(1)..'p1_spacing'][2],
						scaleX = motif.rematch.p1_scale[1],
						scaleY =motif.rematch.p1_scale[2],
					r =      motif.rematch['p1_'..var2..'font'][4],
				g =      motif.rematch['p1_'..var2..'font'][5],
				b =      motif.rematch['p1_'..var2..'font'][6],
						height = 1,
					})
					txt_no[1]:draw()
					else
					    ik_rematch.done[1] =true
					end
					
					if player(2) and ailevel()==0 then
					if not ik_rematch.done[2] then
					
					if main.f_input({2}, main.f_extractKeys(motif.rematch.accept_key))  then
					sndPlay(motif.files.snd_data, motif.rematch.p2_done_snd[1], motif.rematch.p2_done_snd[2])
					ik_rematch.done[2]=true
					end
					
					if (commandGetState(main.t_cmd[2], '$U')  or commandGetState(main.t_cmd[2], '$D'))   then
					sndPlay(motif.files.snd_data, motif.rematch.p2_cursor_snd[1], motif.rematch.p2_cursor_snd[2])
					ik_rematch.cursor[2]=not ik_rematch.cursor[2]
					end
					end
				
						local var =''
					local var2 =''
						if ik_rematch.cursor[2] then

						var = 'active_'
						var2=''
						else
					var = ''
					var2='active_'
					end
						txt_yes[2]:update({
						font =   motif.rematch['p2_'..var..'font'][1],
						bank =   motif.rematch['p2_'..var..'font'][2],
						align =  motif.rematch['p2_'..var..'font'][3],
						text =   motif.rematch.p2_yes_text,
									x =     motif.rematch[rematchtxtpos(2)..'p2_offset'][1],
						y =    motif.rematch[rematchtxtpos(2)..'p2_offset'][2],
						scaleX = motif.rematch.p2_scale[1],
						scaleY =motif.rematch.p2_scale[2],
					r =      motif.rematch['p2_'..var..'font'][4],
				g =      motif.rematch['p2_'..var..'font'][5],
				b =      motif.rematch['p2_'..var..'font'][6],
						height = 1,
					})
					txt_yes[2]:draw()
					
					txt_no[2]:update({
						font =   motif.rematch['p2_'..var2..'font'][1],
						bank =   motif.rematch['p2_'..var2..'font'][2],
						align =  motif.rematch['p2_'..var2..'font'][3],
						text =   motif.rematch.p2_no_text,
									x =     motif.rematch[rematchtxtpos(2)..'p2_offset'][1] + motif.rematch[rematchtxtpos(2)..'p2_spacing'][1],
						y =    motif.rematch[rematchtxtpos(2)..'p2_offset'][2]+ motif.rematch[rematchtxtpos(2)..'p2_spacing'][2],
						scaleX = motif.rematch.p2_scale[1],
						scaleY =motif.rematch.p2_scale[2],
					r =      motif.rematch['p2_'..var2..'font'][4],
				g =      motif.rematch['p2_'..var2..'font'][5],
				b =      motif.rematch['p2_'..var2..'font'][6],
						height = 1,
					})
					txt_no[2]:draw()
					else
					    ik_rematch.done[2] =true
					end
					
		if ik_rematch.rematchend() then
		togglePause(false)
		if ik_rematch.cursor[1] and ik_rematch.cursor[2] then
		toggleNoSound(false)
		start.bgmround=0
		reload()
		else
		charMapSet(1,'ik_rematch',0,'set')
		charMapSet(2,'ik_rematch',0,'set')
		end
		end
end

end
end
end
 hook.add("start.f_victory", "rematch2", ik_rematch.victory)

function ik_rematch.resetwincount()
ik_rematch.wincount={0,0}
end



hook.add("main.t_itemname", "rematch3", ik_rematch.resetwincount)

