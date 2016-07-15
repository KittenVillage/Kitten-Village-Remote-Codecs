-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lcd_events={}
--g_last_notevel_delivered={}
--g_last_note_delivered={}
g_last_notevel_delivered=0
g_last_note_delivered=0
g_current_notevel=0
--livemodeswitch=nil
--modeswitch=nil
notemode={35,40,45,50,55,60,65,70} -- left column -1
drummode={35,39,43,47,51,55,59,63} -- left column -1
		pad={}
		padx={}
		pady={}
		padcolor={}
		padnote={}
		note={}
		notex={}
		notey={}
		notepad={}
		drum={}
		drumx={}
		drumy={}
		drumpad={}


-- remote.trace contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- https://gist.github.com/ripter/4270799
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      remote.trace(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      remote.trace(formatting .. tostring(v))		
    else
      remote.trace(formatting .. tostring(v) ..'\n')
    end
  end
end


-- Thanks, Livid
--for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end

function set_vel_color(newvel)
	if newvel > 0 then
		newvel=math.ceil(newvel/16)+87 --88 to 95
	end
	return newvel
end


--[[
for q=36,78 do
--	g_last_notevel_delivered[q] =0
	pad[q]=q
	pad[q].y=modulo((q-28),8)
end
--]]
for ho=1,8 do
	for ve=1,8 do
	local thispad=(ho*10)+ve	
	local thisnote=notemode[ho]+ve
	local thisdrum=drummode[ho]+ve
		if ve>4 then
			thisdrum=thisdrum+28
		end
	
		pad[thispad]=thispad
		padx[thispad]=ho
		pady[thispad]=ve
		padcolor[thispad]=0
		padnote[thispad]=thisnote
	
		note[thisnote]=thisnote
		notex[thisnote]=ho
		notey[thisnote]=ve
		notepad[thisnote]=thispad
		
		drum[thisdrum]=thisdrum
		drumx[thisdrum]=ho
		drumy[thisdrum]=ve
		drumpad[thisdrum]=thispad
			
		
		
--		pad[thispad]={x=ho,y=ve,color=0,note=thisnote}		
--		note[thisnote]={x=ho,y=ve,pad=thispad}
--[[
pad[thispad]={}
pad[thispad]["x"]=23
--]]
remote.trace(padnote[thispad])
remote.trace(notepad[thisnote])
remote.trace(drum[thisdrum])
remote.trace("\n")
	end
end
tprint(padnote)

--remote.trace(table.concat(note.pos, ", "))
--remote.trace(table.concat(note, ", "))
--remote.trace(table.concat(note.pos, ", "))

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Remote Init here, set this up right
-- Button names are from programmer mode! (pg 17 in the prog ref
-- bottom left button is 1
-- bottom left pad is 11, top right pad is 88
-- left buttons end in 0
-- right buttons end in 9
-- top row 91 - 98
-- Press is aftertouch, Pad is note on, Playing is for displaying state
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
-- this version
	if model=="LP Pro" then
		local items={
--items
			{name="Keyboard",input="keyboard"},
			{name="Channel Pressure", input="value", min=0, max=127},
			{name="_Scope", output="text"}, --device, e.g. "Thor"
			{name="_Var", output="text"}, --variation, e.g. "Volume" or "Filters"
			{name="Fader 1", input="value", min=0, max=127, output="value"},
			{name="Fader 2", input="value", min=0, max=127, output="value"},
			{name="Fader 3", input="value", min=0, max=127, output="value"},
			{name="Fader 4", input="value", min=0, max=127, output="value"},
			{name="Fader 5", input="value", min=0, max=127, output="value"},
			{name="Fader 6", input="value", min=0, max=127, output="value"},
			{name="Fader 7", input="value", min=0, max=127, output="value"},
			{name="Fader 8", input="value", min=0, max=127, output="value"},
--[[
			{name="Pan 1", input="value", min=0, max=127, output="value"},
			{name="Pan 2", input="value", min=0, max=127, output="value"},
			{name="Pan 3", input="value", min=0, max=127, output="value"},
			{name="Pan 4", input="value", min=0, max=127, output="value"},
			{name="Pan 5", input="value", min=0, max=127, output="value"},
			{name="Pan 6", input="value", min=0, max=127, output="value"},
			{name="Pan 7", input="value", min=0, max=127, output="value"},
			{name="Pan 8", input="value", min=0, max=127, output="value"},
--]]
--From bottom left to top right
--[[
			{name="Press 11", input="value", min=0, max=127, output="value"},
			{name="Press 12", input="value", min=0, max=127, output="value"},
			{name="Press 13", input="value", min=0, max=127, output="value"},
			{name="Press 14", input="value", min=0, max=127, output="value"},
			{name="Press 15", input="value", min=0, max=127, output="value"},
			{name="Press 16", input="value", min=0, max=127, output="value"},
			{name="Press 17", input="value", min=0, max=127, output="value"},
			{name="Press 18", input="value", min=0, max=127, output="value"},
			{name="Press 21", input="value", min=0, max=127, output="value"},
			{name="Press 22", input="value", min=0, max=127, output="value"},
			{name="Press 23", input="value", min=0, max=127, output="value"},
			{name="Press 24", input="value", min=0, max=127, output="value"},
			{name="Press 25", input="value", min=0, max=127, output="value"},
			{name="Press 26", input="value", min=0, max=127, output="value"},
			{name="Press 27", input="value", min=0, max=127, output="value"},
			{name="Press 28", input="value", min=0, max=127, output="value"},
			{name="Press 31", input="value", min=0, max=127, output="value"},
			{name="Press 32", input="value", min=0, max=127, output="value"},
			{name="Press 33", input="value", min=0, max=127, output="value"},
			{name="Press 34", input="value", min=0, max=127, output="value"},
			{name="Press 35", input="value", min=0, max=127, output="value"},
			{name="Press 36", input="value", min=0, max=127, output="value"},
			{name="Press 37", input="value", min=0, max=127, output="value"},
			{name="Press 38", input="value", min=0, max=127, output="value"},
			{name="Press 41", input="value", min=0, max=127, output="value"},
			{name="Press 42", input="value", min=0, max=127, output="value"},
			{name="Press 43", input="value", min=0, max=127, output="value"},
			{name="Press 44", input="value", min=0, max=127, output="value"},
			{name="Press 45", input="value", min=0, max=127, output="value"},
			{name="Press 46", input="value", min=0, max=127, output="value"},
			{name="Press 47", input="value", min=0, max=127, output="value"},
			{name="Press 48", input="value", min=0, max=127, output="value"},
			{name="Press 51", input="value", min=0, max=127, output="value"},
			{name="Press 52", input="value", min=0, max=127, output="value"},
			{name="Press 53", input="value", min=0, max=127, output="value"},
			{name="Press 54", input="value", min=0, max=127, output="value"},
			{name="Press 55", input="value", min=0, max=127, output="value"},
			{name="Press 56", input="value", min=0, max=127, output="value"},
			{name="Press 57", input="value", min=0, max=127, output="value"},
			{name="Press 58", input="value", min=0, max=127, output="value"},
			{name="Press 61", input="value", min=0, max=127, output="value"},
			{name="Press 62", input="value", min=0, max=127, output="value"},
			{name="Press 63", input="value", min=0, max=127, output="value"},
			{name="Press 64", input="value", min=0, max=127, output="value"},
			{name="Press 65", input="value", min=0, max=127, output="value"},
			{name="Press 66", input="value", min=0, max=127, output="value"},
			{name="Press 67", input="value", min=0, max=127, output="value"},
			{name="Press 68", input="value", min=0, max=127, output="value"},
			{name="Press 71", input="value", min=0, max=127, output="value"},
			{name="Press 72", input="value", min=0, max=127, output="value"},
			{name="Press 73", input="value", min=0, max=127, output="value"},
			{name="Press 74", input="value", min=0, max=127, output="value"},
			{name="Press 75", input="value", min=0, max=127, output="value"},
			{name="Press 76", input="value", min=0, max=127, output="value"},
			{name="Press 77", input="value", min=0, max=127, output="value"},
			{name="Press 78", input="value", min=0, max=127, output="value"},
			{name="Press 81", input="value", min=0, max=127, output="value"},
			{name="Press 82", input="value", min=0, max=127, output="value"},
			{name="Press 83", input="value", min=0, max=127, output="value"},
			{name="Press 84", input="value", min=0, max=127, output="value"},
			{name="Press 85", input="value", min=0, max=127, output="value"},
			{name="Press 86", input="value", min=0, max=127, output="value"},
			{name="Press 87", input="value", min=0, max=127, output="value"},
			{name="Press 88", input="value", min=0, max=127, output="value"},
--]]
--From bottom left to top right

			{name="Pad 11", input="value", min=0, max=127, output="value"},
			{name="Pad 12", input="value", min=0, max=127, output="value"},
			{name="Pad 13", input="value", min=0, max=127, output="value"},
			{name="Pad 14", input="value", min=0, max=127, output="value"},
			{name="Pad 15", input="value", min=0, max=127, output="value"},
			{name="Pad 16", input="value", min=0, max=127, output="value"},
			{name="Pad 17", input="value", min=0, max=127, output="value"},
			{name="Pad 18", input="value", min=0, max=127, output="value"},
			{name="Pad 21", input="value", min=0, max=127, output="value"},
			{name="Pad 22", input="value", min=0, max=127, output="value"},
			{name="Pad 23", input="value", min=0, max=127, output="value"},
			{name="Pad 24", input="value", min=0, max=127, output="value"},
			{name="Pad 25", input="value", min=0, max=127, output="value"},
			{name="Pad 26", input="value", min=0, max=127, output="value"},
			{name="Pad 27", input="value", min=0, max=127, output="value"},
			{name="Pad 28", input="value", min=0, max=127, output="value"},
			{name="Pad 31", input="value", min=0, max=127, output="value"},
			{name="Pad 32", input="value", min=0, max=127, output="value"},
			{name="Pad 33", input="value", min=0, max=127, output="value"},
			{name="Pad 34", input="value", min=0, max=127, output="value"},
			{name="Pad 35", input="value", min=0, max=127, output="value"},
			{name="Pad 36", input="value", min=0, max=127, output="value"},
			{name="Pad 37", input="value", min=0, max=127, output="value"},
			{name="Pad 38", input="value", min=0, max=127, output="value"},
			{name="Pad 41", input="value", min=0, max=127, output="value"},
			{name="Pad 42", input="value", min=0, max=127, output="value"},
			{name="Pad 43", input="value", min=0, max=127, output="value"},
			{name="Pad 44", input="value", min=0, max=127, output="value"},
			{name="Pad 45", input="value", min=0, max=127, output="value"},
			{name="Pad 46", input="value", min=0, max=127, output="value"},
			{name="Pad 47", input="value", min=0, max=127, output="value"},
			{name="Pad 48", input="value", min=0, max=127, output="value"},
			{name="Pad 51", input="value", min=0, max=127, output="value"},
			{name="Pad 52", input="value", min=0, max=127, output="value"},
			{name="Pad 53", input="value", min=0, max=127, output="value"},
			{name="Pad 54", input="value", min=0, max=127, output="value"},
			{name="Pad 55", input="value", min=0, max=127, output="value"},
			{name="Pad 56", input="value", min=0, max=127, output="value"},
			{name="Pad 57", input="value", min=0, max=127, output="value"},
			{name="Pad 58", input="value", min=0, max=127, output="value"},
			{name="Pad 61", input="value", min=0, max=127, output="value"},
			{name="Pad 62", input="value", min=0, max=127, output="value"},
			{name="Pad 63", input="value", min=0, max=127, output="value"},
			{name="Pad 64", input="value", min=0, max=127, output="value"},
			{name="Pad 65", input="value", min=0, max=127, output="value"},
			{name="Pad 66", input="value", min=0, max=127, output="value"},
			{name="Pad 67", input="value", min=0, max=127, output="value"},
			{name="Pad 68", input="value", min=0, max=127, output="value"},
			{name="Pad 71", input="value", min=0, max=127, output="value"},
			{name="Pad 72", input="value", min=0, max=127, output="value"},
			{name="Pad 73", input="value", min=0, max=127, output="value"},
			{name="Pad 74", input="value", min=0, max=127, output="value"},
			{name="Pad 75", input="value", min=0, max=127, output="value"},
			{name="Pad 76", input="value", min=0, max=127, output="value"},
			{name="Pad 77", input="value", min=0, max=127, output="value"},
			{name="Pad 78", input="value", min=0, max=127, output="value"},
			{name="Pad 81", input="value", min=0, max=127, output="value"},
			{name="Pad 82", input="value", min=0, max=127, output="value"},
			{name="Pad 83", input="value", min=0, max=127, output="value"},
			{name="Pad 84", input="value", min=0, max=127, output="value"},
			{name="Pad 85", input="value", min=0, max=127, output="value"},
			{name="Pad 86", input="value", min=0, max=127, output="value"},
			{name="Pad 87", input="value", min=0, max=127, output="value"},
			{name="Pad 88", input="value", min=0, max=127, output="value"},

--[[
--From bottom left to top right

			{name="Pad 11 Playing", min=0, max=4, output="value"},
			{name="Pad 12 Playing", min=0, max=4, output="value"},
			{name="Pad 13 Playing", min=0, max=4, output="value"},
			{name="Pad 14 Playing", min=0, max=4, output="value"},
			{name="Pad 15 Playing", min=0, max=4, output="value"},
			{name="Pad 16 Playing", min=0, max=4, output="value"},
			{name="Pad 17 Playing", min=0, max=4, output="value"},
			{name="Pad 18 Playing", min=0, max=4, output="value"},
			{name="Pad 21 Playing", min=0, max=4, output="value"},
			{name="Pad 22 Playing", min=0, max=4, output="value"},
			{name="Pad 23 Playing", min=0, max=4, output="value"},
			{name="Pad 24 Playing", min=0, max=4, output="value"},
			{name="Pad 25 Playing", min=0, max=4, output="value"},
			{name="Pad 26 Playing", min=0, max=4, output="value"},
			{name="Pad 27 Playing", min=0, max=4, output="value"},
			{name="Pad 28 Playing", min=0, max=4, output="value"},
			{name="Pad 31 Playing", min=0, max=4, output="value"},
			{name="Pad 32 Playing", min=0, max=4, output="value"},
			{name="Pad 33 Playing", min=0, max=4, output="value"},
			{name="Pad 34 Playing", min=0, max=4, output="value"},
			{name="Pad 35 Playing", min=0, max=4, output="value"},
			{name="Pad 36 Playing", min=0, max=4, output="value"},
			{name="Pad 37 Playing", min=0, max=4, output="value"},
			{name="Pad 38 Playing", min=0, max=4, output="value"},
			{name="Pad 41 Playing", min=0, max=4, output="value"},
			{name="Pad 42 Playing", min=0, max=4, output="value"},
			{name="Pad 43 Playing", min=0, max=4, output="value"},
			{name="Pad 44 Playing", min=0, max=4, output="value"},
			{name="Pad 45 Playing", min=0, max=4, output="value"},
			{name="Pad 46 Playing", min=0, max=4, output="value"},
			{name="Pad 47 Playing", min=0, max=4, output="value"},
			{name="Pad 48 Playing", min=0, max=4, output="value"},
			{name="Pad 51 Playing", min=0, max=4, output="value"},
			{name="Pad 52 Playing", min=0, max=4, output="value"},
			{name="Pad 53 Playing", min=0, max=4, output="value"},
			{name="Pad 54 Playing", min=0, max=4, output="value"},
			{name="Pad 55 Playing", min=0, max=4, output="value"},
			{name="Pad 56 Playing", min=0, max=4, output="value"},
			{name="Pad 57 Playing", min=0, max=4, output="value"},
			{name="Pad 58 Playing", min=0, max=4, output="value"},
			{name="Pad 61 Playing", min=0, max=4, output="value"},
			{name="Pad 62 Playing", min=0, max=4, output="value"},
			{name="Pad 63 Playing", min=0, max=4, output="value"},
			{name="Pad 64 Playing", min=0, max=4, output="value"},
			{name="Pad 65 Playing", min=0, max=4, output="value"},
			{name="Pad 66 Playing", min=0, max=4, output="value"},
			{name="Pad 67 Playing", min=0, max=4, output="value"},
			{name="Pad 68 Playing", min=0, max=4, output="value"},
			{name="Pad 71 Playing", min=0, max=4, output="value"},
			{name="Pad 72 Playing", min=0, max=4, output="value"},
			{name="Pad 73 Playing", min=0, max=4, output="value"},
			{name="Pad 74 Playing", min=0, max=4, output="value"},
			{name="Pad 75 Playing", min=0, max=4, output="value"},
			{name="Pad 76 Playing", min=0, max=4, output="value"},
			{name="Pad 77 Playing", min=0, max=4, output="value"},
			{name="Pad 78 Playing", min=0, max=4, output="value"},
			{name="Pad 81 Playing", min=0, max=4, output="value"},
			{name="Pad 82 Playing", min=0, max=4, output="value"},
			{name="Pad 83 Playing", min=0, max=4, output="value"},
			{name="Pad 84 Playing", min=0, max=4, output="value"},
			{name="Pad 85 Playing", min=0, max=4, output="value"},
			{name="Pad 86 Playing", min=0, max=4, output="value"},
			{name="Pad 87 Playing", min=0, max=4, output="value"},
			{name="Pad 88 Playing", min=0, max=4, output="value"},
--]]
--left to right Top
			{name="Button 91", input="button", min=0, max=127, output="value"},
			{name="Button 92", input="button", min=0, max=127, output="value"},
			{name="Button 93", input="button", min=0, max=127, output="value"},
			{name="Button 94", input="button", min=0, max=127, output="value"},
			{name="Button 95", input="button", min=0, max=127, output="value"},
			{name="Button 96", input="button", min=0, max=127, output="value"},
			{name="Button 97", input="button", min=0, max=127, output="value"},
			{name="Button 98", input="button", min=0, max=127, output="value"},
--left to right Bottom
			{name="Button 01", input="button", min=0, max=127, output="value"},
			{name="Button 02", input="button", min=0, max=127, output="value"},
			{name="Button 03", input="button", min=0, max=127, output="value"},
			{name="Button 04", input="button", min=0, max=127, output="value"},
			{name="Button 05", input="button", min=0, max=127, output="value"},
			{name="Button 06", input="button", min=0, max=127, output="value"},
			{name="Button 07", input="button", min=0, max=127, output="value"},
			{name="Button 08", input="button", min=0, max=127, output="value"},
--bottom to top Left
			{name="Button 10", input="button", min=0, max=127, output="value"},
			{name="Button 20", input="button", min=0, max=127, output="value"},
			{name="Button 30", input="button", min=0, max=127, output="value"},
			{name="Button 40", input="button", min=0, max=127, output="value"},
			{name="Button 50", input="button", min=0, max=127, output="value"},
			{name="Button 60", input="button", min=0, max=127, output="value"},
			{name="Button 70", input="button", min=0, max=127, output="value"},
			{name="Button 80", input="button", min=0, max=127, output="value"},
--bottom to top Right
			{name="Button 19", input="button", min=0, max=127, output="value"},
			{name="Button 29", input="button", min=0, max=127, output="value"},
			{name="Button 39", input="button", min=0, max=127, output="value"},
			{name="Button 49", input="button", min=0, max=127, output="value"},
			{name="Button 59", input="button", min=0, max=127, output="value"},
			{name="Button 69", input="button", min=0, max=127, output="value"},
			{name="Button 79", input="button", min=0, max=127, output="value"},
			{name="Button 89", input="button", min=0, max=127, output="value"},





			}
		remote.define_items(items)


		local inputs={

--inputs
			{pattern="b0 15 xx", name="Fader 1"},
			{pattern="b0 16 xx", name="Fader 2"},
			{pattern="b0 17 xx", name="Fader 3"},
			{pattern="b0 18 xx", name="Fader 4"},
			{pattern="b0 19 xx", name="Fader 5"},
			{pattern="b0 1a xx", name="Fader 6"},
			{pattern="b0 1b xx", name="Fader 7"},
			{pattern="b0 1c xx", name="Fader 8"},
--[[
			{pattern="b0 15 xx", name="Pan 1"},
			{pattern="b0 16 xx", name="Pan 2"},
			{pattern="b0 17 xx", name="Pan 3"},
			{pattern="b0 18 xx", name="Pan 4"},
			{pattern="b0 19 xx", name="Pan 5"},
			{pattern="b0 1a xx", name="Pan 6"},
			{pattern="b0 1b xx", name="Pan 7"},
			{pattern="b0 1c xx", name="Pan 8"},
--]]

--[[

-- Aftertouch
			{name="Press 11",  pattern="A? 0B xx"},
			{name="Press 12",  pattern="A? 0C xx"},
			{name="Press 13",  pattern="A? 0D xx"},
			{name="Press 14",  pattern="A? 0E xx"},
			{name="Press 15",  pattern="A? 0F xx"},
			{name="Press 16",  pattern="A? 10 xx"},
			{name="Press 17",  pattern="A? 11 xx"},
			{name="Press 18",  pattern="A? 12 xx"},
			{name="Press 21",  pattern="A? 15 xx"},
			{name="Press 22",  pattern="A? 16 xx"},
			{name="Press 23",  pattern="A? 17 xx"},
			{name="Press 24",  pattern="A? 18 xx"},
			{name="Press 25",  pattern="A? 19 xx"},
			{name="Press 26",  pattern="A? 1A xx"},
			{name="Press 27",  pattern="A? 1B xx"},
			{name="Press 28",  pattern="A? 1C xx"},
			{name="Press 31",  pattern="A? 1F xx"},
			{name="Press 32",  pattern="A? 20 xx"},
			{name="Press 33",  pattern="A? 21 xx"},
			{name="Press 34",  pattern="A? 22 xx"},
			{name="Press 35",  pattern="A? 23 xx"},
			{name="Press 36",  pattern="A? 24 xx"},
			{name="Press 37",  pattern="A? 25 xx"},
			{name="Press 38",  pattern="A? 26 xx"},
			{name="Press 41",  pattern="A? 29 xx"},
			{name="Press 42",  pattern="A? 2A xx"},
			{name="Press 43",  pattern="A? 2B xx"},
			{name="Press 44",  pattern="A? 2C xx"},
			{name="Press 45",  pattern="A? 2D xx"},
			{name="Press 46",  pattern="A? 2E xx"},
			{name="Press 47",  pattern="A? 2F xx"},
			{name="Press 48",  pattern="A? 30 xx"},
			{name="Press 51",  pattern="A? 33 xx"},
			{name="Press 52",  pattern="A? 34 xx"},
			{name="Press 53",  pattern="A? 35 xx"},
			{name="Press 54",  pattern="A? 36 xx"},
			{name="Press 55",  pattern="A? 37 xx"},
			{name="Press 56",  pattern="A? 38 xx"},
			{name="Press 57",  pattern="A? 39 xx"},
			{name="Press 58",  pattern="A? 3A xx"},
			{name="Press 61",  pattern="A? 3D xx"},
			{name="Press 62",  pattern="A? 3E xx"},
			{name="Press 63",  pattern="A? 3F xx"},
			{name="Press 64",  pattern="A? 40 xx"},
			{name="Press 65",  pattern="A? 41 xx"},
			{name="Press 66",  pattern="A? 42 xx"},
			{name="Press 67",  pattern="A? 43 xx"},
			{name="Press 68",  pattern="A? 44 xx"},
			{name="Press 71",  pattern="A? 47 xx"},
			{name="Press 72",  pattern="A? 48 xx"},
			{name="Press 73",  pattern="A? 49 xx"},
			{name="Press 74",  pattern="A? 4A xx"},
			{name="Press 75",  pattern="A? 4B xx"},
			{name="Press 76",  pattern="A? 4C xx"},
			{name="Press 77",  pattern="A? 4D xx"},
			{name="Press 78",  pattern="A? 4E xx"},
			{name="Press 81",  pattern="A? 51 xx"},
			{name="Press 82",  pattern="A? 52 xx"},
			{name="Press 83",  pattern="A? 53 xx"},
			{name="Press 84",  pattern="A? 54 xx"},
			{name="Press 85",  pattern="A? 55 xx"},
			{name="Press 86",  pattern="A? 56 xx"},
			{name="Press 87",  pattern="A? 57 xx"},
			{name="Press 88",  pattern="A? 58 xx"},
--]]

			{name="Pad 11",	 pattern="<100x>? 0B yy"},
			{name="Pad 12",	 pattern="<100x>? 0C yy"},
			{name="Pad 13",	 pattern="<100x>? 0D yy"},
			{name="Pad 14",	 pattern="<100x>? 0E yy"},
			{name="Pad 15",	 pattern="<100x>? 0F yy"},
			{name="Pad 16",	 pattern="<100x>? 10 yy"},
			{name="Pad 17",	 pattern="<100x>? 11 yy"},
			{name="Pad 18",	 pattern="<100x>? 12 yy"},
			{name="Pad 21",	 pattern="<100x>? 15 yy"},
			{name="Pad 22",	 pattern="<100x>? 16 yy"},
			{name="Pad 23",	 pattern="<100x>? 17 yy"},
			{name="Pad 24",	 pattern="<100x>? 18 yy"},
			{name="Pad 25",	 pattern="<100x>? 19 yy"},
			{name="Pad 26",	 pattern="<100x>? 1A yy"},
			{name="Pad 27",	 pattern="<100x>? 1B yy"},
			{name="Pad 28",	 pattern="<100x>? 1C yy"},
			{name="Pad 31",	 pattern="<100x>? 1F yy"},
			{name="Pad 32",	 pattern="<100x>? 20 yy"},
			{name="Pad 33",	 pattern="<100x>? 21 yy"},
			{name="Pad 34",	 pattern="<100x>? 22 yy"},
			{name="Pad 35",	 pattern="<100x>? 23 yy"},
			{name="Pad 36",	 pattern="<100x>? 24 yy"},
			{name="Pad 37",	 pattern="<100x>? 25 yy"},
			{name="Pad 38",	 pattern="<100x>? 26 yy"},
			{name="Pad 41",	 pattern="<100x>? 29 yy"},
			{name="Pad 42",	 pattern="<100x>? 2A yy"},
			{name="Pad 43",	 pattern="<100x>? 2B yy"},
			{name="Pad 44",	 pattern="<100x>? 2C yy"},
			{name="Pad 45",	 pattern="<100x>? 2D yy"},
			{name="Pad 46",	 pattern="<100x>? 2E yy"},
			{name="Pad 47",	 pattern="<100x>? 2F yy"},
			{name="Pad 48",	 pattern="<100x>? 30 yy"},
			{name="Pad 51",	 pattern="<100x>? 33 yy"},
			{name="Pad 52",	 pattern="<100x>? 34 yy"},
			{name="Pad 53",	 pattern="<100x>? 35 yy"},
			{name="Pad 54",	 pattern="<100x>? 36 yy"},
			{name="Pad 55",	 pattern="<100x>? 37 yy"},
			{name="Pad 56",	 pattern="<100x>? 38 yy"},
			{name="Pad 57",	 pattern="<100x>? 39 yy"},
			{name="Pad 58",	 pattern="<100x>? 3A yy"},
			{name="Pad 61",	 pattern="<100x>? 3D yy"},
			{name="Pad 62",	 pattern="<100x>? 3E yy"},
			{name="Pad 63",	 pattern="<100x>? 3F yy"},
			{name="Pad 64",	 pattern="<100x>? 40 yy"},
			{name="Pad 65",	 pattern="<100x>? 41 yy"},
			{name="Pad 66",	 pattern="<100x>? 42 yy"},
			{name="Pad 67",	 pattern="<100x>? 43 yy"},
			{name="Pad 68",	 pattern="<100x>? 44 yy"},
			{name="Pad 71",	 pattern="<100x>? 47 yy"},
			{name="Pad 72",	 pattern="<100x>? 48 yy"},
			{name="Pad 73",	 pattern="<100x>? 49 yy"},
			{name="Pad 74",	 pattern="<100x>? 4A yy"},
			{name="Pad 75",	 pattern="<100x>? 4B yy"},
			{name="Pad 76",	 pattern="<100x>? 4C yy"},
			{name="Pad 77",	 pattern="<100x>? 4D yy"},
			{name="Pad 78",	 pattern="<100x>? 4E yy"},
			{name="Pad 81",	 pattern="<100x>? 51 yy"},
			{name="Pad 82",	 pattern="<100x>? 52 yy"},
			{name="Pad 83",	 pattern="<100x>? 53 yy"},
			{name="Pad 84",	 pattern="<100x>? 54 yy"},
			{name="Pad 85",	 pattern="<100x>? 55 yy"},
			{name="Pad 86",	 pattern="<100x>? 56 yy"},
			{name="Pad 87",	 pattern="<100x>? 57 yy"},
			{name="Pad 88",	 pattern="<100x>? 58 yy"},


--left to right Top
			{name="Button 91",	pattern="B? 5B ?<???x>"},
			{name="Button 92",	pattern="B? 5C ?<???x>"},
			{name="Button 93",	pattern="B? 5D ?<???x>"},
			{name="Button 94",	pattern="B? 5E ?<???x>"},
			{name="Button 95",	pattern="B? 5F ?<???x>"},
			{name="Button 96",	pattern="B? 60 ?<???x>"},
			{name="Button 97",	pattern="B? 61 ?<???x>"},
			{name="Button 98",	pattern="B? 62 ?<???x>"},
--left to right Bottom
			{name="Button 01",  pattern="B? 01 ?<???x>"},
			{name="Button 02",  pattern="B? 02 ?<???x>"},
			{name="Button 03",  pattern="B? 03 ?<???x>"},
			{name="Button 04",  pattern="B? 04 ?<???x>"},
			{name="Button 05",  pattern="B? 05 ?<???x>"},
			{name="Button 06",  pattern="B? 06 ?<???x>"},
			{name="Button 07",  pattern="B? 07 ?<???x>"},
			{name="Button 08",  pattern="B? 08 ?<???x>"},
--bottom to top Left
			{name="Button 10",	 pattern="B? 0A ?<???x>"},
			{name="Button 20",	 pattern="B? 14 ?<???x>"},
			{name="Button 30",	 pattern="B? 1E ?<???x>"},
			{name="Button 40",	 pattern="B? 28 ?<???x>"},
			{name="Button 50",	 pattern="B? 32 ?<???x>"},
			{name="Button 60",	 pattern="B? 3C ?<???x>"},
			{name="Button 70",	 pattern="B? 46 ?<???x>"},
			{name="Button 80",	 pattern="B? 50 ?<???x>"},
--bottom to top Right
			{name="Button 19",  pattern="B? 13 ?<???x>"},
			{name="Button 29",  pattern="B? 1D ?<???x>"},
			{name="Button 39",  pattern="B? 27 ?<???x>"},
			{name="Button 49",  pattern="B? 31 ?<???x>"},
			{name="Button 59",  pattern="B? 3B ?<???x>"},
			{name="Button 69",  pattern="B? 45 ?<???x>"},
			{name="Button 79",  pattern="B? 4F ?<???x>"},
			{name="Button 89",  pattern="B? 59 ?<???x>"},

		}
		remote.define_auto_inputs(inputs)
		
		local outputs={

--ouputs

-- NO AUTO OUTS FOR NOW

--[[

-- Aftertouch
			{name="Press 11",  pattern="A? 0B xx"},
			{name="Press 12",  pattern="A? 0C xx"},
			{name="Press 13",  pattern="A? 0D xx"},
			{name="Press 14",  pattern="A? 0E xx"},
			{name="Press 15",  pattern="A? 0F xx"},
			{name="Press 16",  pattern="A? 10 xx"},
			{name="Press 17",  pattern="A? 11 xx"},
			{name="Press 18",  pattern="A? 12 xx"},
			{name="Press 21",  pattern="A? 15 xx"},
			{name="Press 22",  pattern="A? 16 xx"},
			{name="Press 23",  pattern="A? 17 xx"},
			{name="Press 24",  pattern="A? 18 xx"},
			{name="Press 25",  pattern="A? 19 xx"},
			{name="Press 26",  pattern="A? 1A xx"},
			{name="Press 27",  pattern="A? 1B xx"},
			{name="Press 28",  pattern="A? 1C xx"},
			{name="Press 31",  pattern="A? 1F xx"},
			{name="Press 32",  pattern="A? 20 xx"},
			{name="Press 33",  pattern="A? 21 xx"},
			{name="Press 34",  pattern="A? 22 xx"},
			{name="Press 35",  pattern="A? 23 xx"},
			{name="Press 36",  pattern="A? 24 xx"},
			{name="Press 37",  pattern="A? 25 xx"},
			{name="Press 38",  pattern="A? 26 xx"},
			{name="Press 41",  pattern="A? 29 xx"},
			{name="Press 42",  pattern="A? 2A xx"},
			{name="Press 43",  pattern="A? 2B xx"},
			{name="Press 44",  pattern="A? 2C xx"},
			{name="Press 45",  pattern="A? 2D xx"},
			{name="Press 46",  pattern="A? 2E xx"},
			{name="Press 47",  pattern="A? 2F xx"},
			{name="Press 48",  pattern="A? 30 xx"},
			{name="Press 51",  pattern="A? 33 xx"},
			{name="Press 52",  pattern="A? 34 xx"},
			{name="Press 53",  pattern="A? 35 xx"},
			{name="Press 54",  pattern="A? 36 xx"},
			{name="Press 55",  pattern="A? 37 xx"},
			{name="Press 56",  pattern="A? 38 xx"},
			{name="Press 57",  pattern="A? 39 xx"},
			{name="Press 58",  pattern="A? 3A xx"},
			{name="Press 61",  pattern="A? 3D xx"},
			{name="Press 62",  pattern="A? 3E xx"},
			{name="Press 63",  pattern="A? 3F xx"},
			{name="Press 64",  pattern="A? 40 xx"},
			{name="Press 65",  pattern="A? 41 xx"},
			{name="Press 66",  pattern="A? 42 xx"},
			{name="Press 67",  pattern="A? 43 xx"},
			{name="Press 68",  pattern="A? 44 xx"},
			{name="Press 71",  pattern="A? 47 xx"},
			{name="Press 72",  pattern="A? 48 xx"},
			{name="Press 73",  pattern="A? 49 xx"},
			{name="Press 74",  pattern="A? 4A xx"},
			{name="Press 75",  pattern="A? 4B xx"},
			{name="Press 76",  pattern="A? 4C xx"},
			{name="Press 77",  pattern="A? 4D xx"},
			{name="Press 78",  pattern="A? 4E xx"},
			{name="Press 81",  pattern="A? 51 xx"},
			{name="Press 82",  pattern="A? 52 xx"},
			{name="Press 83",  pattern="A? 53 xx"},
			{name="Press 84",  pattern="A? 54 xx"},
			{name="Press 85",  pattern="A? 55 xx"},
			{name="Press 86",  pattern="A? 56 xx"},
			{name="Press 87",  pattern="A? 57 xx"},
			{name="Press 88",  pattern="A? 58 xx"},
--]]
--[[
-- Note on lights, note off turns off light. 
-- might have to set this to <100x>?

			{name="Pad 11",	 pattern="9? 0B xx"},
			{name="Pad 12",	 pattern="9? 0C xx"},
			{name="Pad 13",	 pattern="9? 0D xx"},
			{name="Pad 14",	 pattern="9? 0E xx"},
			{name="Pad 15",	 pattern="9? 0F xx"},
			{name="Pad 16",	 pattern="9? 10 xx"},
			{name="Pad 17",	 pattern="9? 11 xx"},
			{name="Pad 18",	 pattern="9? 12 xx"},
			{name="Pad 21",	 pattern="9? 15 xx"},
			{name="Pad 22",	 pattern="9? 16 xx"},
			{name="Pad 23",	 pattern="9? 17 xx"},
			{name="Pad 24",	 pattern="9? 18 xx"},
			{name="Pad 25",	 pattern="9? 19 xx"},
			{name="Pad 26",	 pattern="9? 1A xx"},
			{name="Pad 27",	 pattern="9? 1B xx"},
			{name="Pad 28",	 pattern="9? 1C xx"},
			{name="Pad 31",	 pattern="9? 1F xx"},
			{name="Pad 32",	 pattern="9? 20 xx"},
			{name="Pad 33",	 pattern="9? 21 xx"},
			{name="Pad 34",	 pattern="9? 22 xx"},
			{name="Pad 35",	 pattern="9? 23 xx"},
			{name="Pad 36",	 pattern="9? 24 xx"},
			{name="Pad 37",	 pattern="9? 25 xx"},
			{name="Pad 38",	 pattern="9? 26 xx"},
			{name="Pad 41",	 pattern="9? 29 xx"},
			{name="Pad 42",	 pattern="9? 2A xx"},
			{name="Pad 43",	 pattern="9? 2B xx"},
			{name="Pad 44",	 pattern="9? 2C xx"},
			{name="Pad 45",	 pattern="9? 2D xx"},
			{name="Pad 46",	 pattern="9? 2E xx"},
			{name="Pad 47",	 pattern="9? 2F xx"},
			{name="Pad 48",	 pattern="9? 30 xx"},
			{name="Pad 51",	 pattern="9? 33 xx"},
			{name="Pad 52",	 pattern="9? 34 xx"},
			{name="Pad 53",	 pattern="9? 35 xx"},
			{name="Pad 54",	 pattern="9? 36 xx"},
			{name="Pad 55",	 pattern="9? 37 xx"},
			{name="Pad 56",	 pattern="9? 38 xx"},
			{name="Pad 57",	 pattern="9? 39 xx"},
			{name="Pad 58",	 pattern="9? 3A xx"},
			{name="Pad 61",	 pattern="9? 3D xx"},
			{name="Pad 62",	 pattern="9? 3E xx"},
			{name="Pad 63",	 pattern="9? 3F xx"},
			{name="Pad 64",	 pattern="9? 40 xx"},
			{name="Pad 65",	 pattern="9? 41 xx"},
			{name="Pad 66",	 pattern="9? 42 xx"},
			{name="Pad 67",	 pattern="9? 43 xx"},
			{name="Pad 68",	 pattern="9? 44 xx"},
			{name="Pad 71",	 pattern="9? 47 xx"},
			{name="Pad 72",	 pattern="9? 48 xx"},
			{name="Pad 73",	 pattern="9? 49 xx"},
			{name="Pad 74",	 pattern="9? 4A xx"},
			{name="Pad 75",	 pattern="9? 4B xx"},
			{name="Pad 76",	 pattern="9? 4C xx"},
			{name="Pad 77",	 pattern="9? 4D xx"},
			{name="Pad 78",	 pattern="9? 4E xx"},
			{name="Pad 81",	 pattern="9? 51 xx"},
			{name="Pad 82",	 pattern="9? 52 xx"},
			{name="Pad 83",	 pattern="9? 53 xx"},
			{name="Pad 84",	 pattern="9? 54 xx"},
			{name="Pad 85",	 pattern="9? 55 xx"},
			{name="Pad 86",	 pattern="9? 56 xx"},
			{name="Pad 87",	 pattern="9? 57 xx"},
			{name="Pad 88",	 pattern="9? 58 xx"},
--]]
--[[

			{name="Pad 11 Playing",	 pattern="9? 0B xx",  x="map_redrum_led(value)"},
			{name="Pad 12 Playing",	 pattern="9? 0C xx",  x="map_redrum_led(value)"},
			{name="Pad 13 Playing",	 pattern="9? 0D xx",  x="map_redrum_led(value)"},
			{name="Pad 14 Playing",	 pattern="9? 0E xx",  x="map_redrum_led(value)"},
			{name="Pad 15 Playing",	 pattern="9? 0F xx",  x="map_redrum_led(value)"},
			{name="Pad 16 Playing",	 pattern="9? 10 xx",  x="map_redrum_led(value)"},
			{name="Pad 17 Playing",	 pattern="9? 11 xx",  x="map_redrum_led(value)"},
			{name="Pad 18 Playing",	 pattern="9? 12 xx",  x="map_redrum_led(value)"},
			{name="Pad 21 Playing",	 pattern="9? 15 xx",  x="map_redrum_led(value)"},
			{name="Pad 22 Playing",	 pattern="9? 16 xx",  x="map_redrum_led(value)"},
			{name="Pad 23 Playing",	 pattern="9? 17 xx",  x="map_redrum_led(value)"},
			{name="Pad 24 Playing",	 pattern="9? 18 xx",  x="map_redrum_led(value)"},
			{name="Pad 25 Playing",	 pattern="9? 19 xx",  x="map_redrum_led(value)"},
			{name="Pad 26 Playing",	 pattern="9? 1A xx",  x="map_redrum_led(value)"},
			{name="Pad 27 Playing",	 pattern="9? 1B xx",  x="map_redrum_led(value)"},
			{name="Pad 28 Playing",	 pattern="9? 1C xx",  x="map_redrum_led(value)"},
			{name="Pad 31 Playing",	 pattern="9? 1F xx",  x="map_redrum_led(value)"},
			{name="Pad 32 Playing",	 pattern="9? 20 xx",  x="map_redrum_led(value)"},
			{name="Pad 33 Playing",	 pattern="9? 21 xx",  x="map_redrum_led(value)"},
			{name="Pad 34 Playing",	 pattern="9? 22 xx",  x="map_redrum_led(value)"},
			{name="Pad 35 Playing",	 pattern="9? 23 xx",  x="map_redrum_led(value)"},
			{name="Pad 36 Playing",	 pattern="9? 24 xx",  x="map_redrum_led(value)"},
			{name="Pad 37 Playing",	 pattern="9? 25 xx",  x="map_redrum_led(value)"},
			{name="Pad 38 Playing",	 pattern="9? 26 xx",  x="map_redrum_led(value)"},
			{name="Pad 41 Playing",	 pattern="9? 29 xx",  x="map_redrum_led(value)"},
			{name="Pad 42 Playing",	 pattern="9? 2A xx",  x="map_redrum_led(value)"},
			{name="Pad 43 Playing",	 pattern="9? 2B xx",  x="map_redrum_led(value)"},
			{name="Pad 44 Playing",	 pattern="9? 2C xx",  x="map_redrum_led(value)"},
			{name="Pad 45 Playing",	 pattern="9? 2D xx",  x="map_redrum_led(value)"},
			{name="Pad 46 Playing",	 pattern="9? 2E xx",  x="map_redrum_led(value)"},
			{name="Pad 47 Playing",	 pattern="9? 2F xx",  x="map_redrum_led(value)"},
			{name="Pad 48 Playing",	 pattern="9? 30 xx",  x="map_redrum_led(value)"},
			{name="Pad 51 Playing",	 pattern="9? 33 xx",  x="map_redrum_led(value)"},
			{name="Pad 52 Playing",	 pattern="9? 34 xx",  x="map_redrum_led(value)"},
			{name="Pad 53 Playing",	 pattern="9? 35 xx",  x="map_redrum_led(value)"},
			{name="Pad 54 Playing",	 pattern="9? 36 xx",  x="map_redrum_led(value)"},
			{name="Pad 55 Playing",	 pattern="9? 37 xx",  x="map_redrum_led(value)"},
			{name="Pad 56 Playing",	 pattern="9? 38 xx",  x="map_redrum_led(value)"},
			{name="Pad 57 Playing",	 pattern="9? 39 xx",  x="map_redrum_led(value)"},
			{name="Pad 58 Playing",	 pattern="9? 3A xx",  x="map_redrum_led(value)"},
			{name="Pad 61 Playing",	 pattern="9? 3D xx",  x="map_redrum_led(value)"},
			{name="Pad 62 Playing",	 pattern="9? 3E xx",  x="map_redrum_led(value)"},
			{name="Pad 63 Playing",	 pattern="9? 3F xx",  x="map_redrum_led(value)"},
			{name="Pad 64 Playing",	 pattern="9? 40 xx",  x="map_redrum_led(value)"},
			{name="Pad 65 Playing",	 pattern="9? 41 xx",  x="map_redrum_led(value)"},
			{name="Pad 66 Playing",	 pattern="9? 42 xx",  x="map_redrum_led(value)"},
			{name="Pad 67 Playing",	 pattern="9? 43 xx",  x="map_redrum_led(value)"},
			{name="Pad 68 Playing",	 pattern="9? 44 xx",  x="map_redrum_led(value)"},
			{name="Pad 71 Playing",	 pattern="9? 47 xx",  x="map_redrum_led(value)"},
			{name="Pad 72 Playing",	 pattern="9? 48 xx",  x="map_redrum_led(value)"},
			{name="Pad 73 Playing",	 pattern="9? 49 xx",  x="map_redrum_led(value)"},
			{name="Pad 74 Playing",	 pattern="9? 4A xx",  x="map_redrum_led(value)"},
			{name="Pad 75 Playing",	 pattern="9? 4B xx",  x="map_redrum_led(value)"},
			{name="Pad 76 Playing",	 pattern="9? 4C xx",  x="map_redrum_led(value)"},
			{name="Pad 77 Playing",	 pattern="9? 4D xx",  x="map_redrum_led(value)"},
			{name="Pad 78 Playing",	 pattern="9? 4E xx",  x="map_redrum_led(value)"},
			{name="Pad 81 Playing",	 pattern="9? 51 xx",  x="map_redrum_led(value)"},
			{name="Pad 82 Playing",	 pattern="9? 52 xx",  x="map_redrum_led(value)"},
			{name="Pad 83 Playing",	 pattern="9? 53 xx",  x="map_redrum_led(value)"},
			{name="Pad 84 Playing",	 pattern="9? 54 xx",  x="map_redrum_led(value)"},
			{name="Pad 85 Playing",	 pattern="9? 55 xx",  x="map_redrum_led(value)"},
			{name="Pad 86 Playing",	 pattern="9? 56 xx",  x="map_redrum_led(value)"},
			{name="Pad 87 Playing",	 pattern="9? 57 xx",  x="map_redrum_led(value)"},
			{name="Pad 88 Playing",	 pattern="9? 58 xx",  x="map_redrum_led(value)"},

--]]
--[[


--left to right TOP
			{name="Button 91",	pattern="B? 5B xx"},
			{name="Button 92",	pattern="B? 5C xx"},
			{name="Button 93",	pattern="B? 5D xx"},
			{name="Button 94",	pattern="B? 5E xx"},
			{name="Button 95",	pattern="B? 5F xx"},
			{name="Button 96",	pattern="B? 60 xx"},
			{name="Button 97",	pattern="B? 61 xx"},
			{name="Button 98",	pattern="B? 62 xx"},
--left to right Bottom
			{name="Button 01",  pattern="B? 01 xx"},
			{name="Button 02",  pattern="B? 02 xx"},
			{name="Button 03",  pattern="B? 03 xx"},
			{name="Button 04",  pattern="B? 04 xx"},
			{name="Button 05",  pattern="B? 05 xx"},
			{name="Button 06",  pattern="B? 06 xx"},
			{name="Button 07",  pattern="B? 07 xx"},
			{name="Button 08",  pattern="B? 08 xx"},
--bottom to top Left
			{name="Button 10",	 pattern="B? 0A xx"},
			{name="Button 20",	 pattern="B? 14 xx"},
			{name="Button 30",	 pattern="B? 1E xx"},
			{name="Button 40",	 pattern="B? 28 xx"},
			{name="Button 50",	 pattern="B? 32 xx"},
			{name="Button 60",	 pattern="B? 3C xx"},
			{name="Button 70",	 pattern="B? 46 xx"},
			{name="Button 80",	 pattern="B? 50 xx"},
--bottom to top Right
			{name="Button 19",  pattern="B? 13 xx"},
			{name="Button 29",  pattern="B? 1D xx"},
			{name="Button 39",  pattern="B? 27 xx"},
			{name="Button 49",  pattern="B? 31 xx"},
			{name="Button 59",  pattern="B? 3B xx"},
			{name="Button 69",  pattern="B? 45 xx"},
			{name="Button 79",  pattern="B? 4F xx"},
			{name="Button 89",  pattern="B? 59 xx"},

--]]

		}
		remote.define_auto_outputs(outputs)
	end
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function remote_process_midi(event)
remote.trace(event.size)
remote.trace("evsize")

tprint(event)
--if event.size==3 then 
	ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
	if(ret~=nil) then
tprint(ret)
			local new_note = ret.y 
			local new_notevel = ret.z 
			if (g_last_notevel_delivered~=new_notevel) and (g_last_note_delivered~=new_note) then -- draw new notevel
				g_current_note=new_note
				g_current_notevel=new_notevel
				
			
			end
--[[


				local msg={ time_stamp = event.time_stamp, item=k_accent, value = g_accent_count, note = "2B",velocity = accent_pad.z }
				remote.handle_input(msg)
				g_delivered_note = noteout
				return true

--]]
--	elseif ret
			local var_event = make_lcd_midi_message("New Note "..new_note)
			table.insert(lcd_events,var_event)

	end -- ret not nil
--end -- eventsize=3
	
-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	
-- -----------------------------------------------------------------------------------------------
--if event.size==9 then
	modeswitch = remote.match_midi("F0 00 20 29 02 10 2F xx F7",event) --find what mode we are in
	livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode
	if (modeswitch) then
--remote.trace(modeswitch.x)
		g_mode=modeswitch.x
		if modeswitch.x ~=3 then
			g_set_mode=3
		end
	elseif (livemodeswitch) then
			g_set_mode=3
	end
-- This next will only be sent on the 1st LPP midi channel, so it's not relevant here.
--[[
	livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode
	if(livemodeswitch) then
remote.trace(livemodeswitch.x)
		g_livemode=livemodeswitch.x
		if livemodeswitch.x ~=1 then
			g_set_livemode=1
		end
	
	end
--]]
--end -- eventsize=9
-- -----------------------------------------------------------------------------------------------



	return false


end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function remote_deliver_midi(maxbytes,port)



	if(port==1) then
		local lpp_events={}
--[[
		if g_vartext_prev~=g_vartext then
			--Let the LCD know what the variation is
			local vartext = remote.get_item_text_value(g_var_item_index)
			local var_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display "..vartext)
			table.insert(lcd_events,var_event)
			g_vartext_prev = g_vartext
			isvarchange = true
		end
--]]
		if (g_last_notevel_delivered~=g_current_notevel) or (g_last_note_delivered~=g_current_note) then
			lpp_events={
				remote.make_midi("b0 xx yy",{ x = g_current_note, y = set_vel_color(g_current_notevel), port=1 }),
			}
			g_current_notevel=g_last_notevel_delivered
			g_current_note=g_last_note_delivered
				local var_event = make_lcd_midi_message("New Note "..g_current_notevel)
			table.insert(lcd_events,var_event)

		end
--remote.trace("remdevmidi 1\n")


-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	
-- -----------------------------------------------------------------------------------------------
		if g_set_mode~=g_mode then
			local mode_event = remote.make_midi("F0 00 20 29 02 10 2C xx F7",{ x = g_set_mode, port=1 })
			table.insert(lpp_events,mode_event)
			g_mode=g_set_mode
		end
-- This next will switch the unit to the 1st LPP midi channel, so it's not relevant here.
--[[
		if g_set_livemode~=g_livemode then
			local livemode_event = remote.make_midi("F0 00 20 29 02 10 21 xx F7",{ x = g_set_livemode, port=1 })
			table.insert(lpp_events,livemode_event)
			g_livemode=g_set_livemode
		end
--]]
-- -----------------------------------------------------------------------------------------------

		
		return lpp_events --send out a bunch of MIDI to the Launchpad Pro
	end --end port==1





	if(port==2) then
		local le = lcd_events
		lcd_events = {}
--remote.trace("remdevmidi 2 \n")
		return le
	end
--[[
--]]







end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function remote_probe()
	return {
	}
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_on_auto_input(item_index)
	g_last_input_time = remote.get_time_ms()
	g_last_input_item = item_index
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_set_state(changed_items)



--[[

	--look for the _Scope constant. Kong reports "KONG". Could use for a variety of things

	if remote.is_item_enabled(g_scope_item_index) then
		local scope_text = remote.get_item_text_value(g_scope_item_index)
		g_scopetext = scope_text
	else
		g_scopetext = ""
	end
	
	if remote.is_item_enabled(g_var_item_index) then
		local var_text = remote.get_item_text_value(g_var_item_index)
		g_vartext = var_text
	else
		g_vartext = ""
	end
	
	if(g_last_input_item~=nil) then
		if remote.is_item_enabled(g_last_input_item) then
			local feedback_text = remote.get_item_name_and_value(g_last_input_item)
			if string.len(feedback_text)>0 then
				g_feedback_enabled = true
				--g_lcd_state = string.format("%-16.16s",feedback_text)
				g_lcd_state = feedback_text
				g_lcd_index = g_last_input_item
			end
		end
	end

  -- FL: Collect all changed states for redrum "drum playing" - this part blinks the 3rd row drum selection pads
	for k,item_index in ipairs(changed_items) do
	if item_index == k_accent then
	  g_accent = remote.get_item_value(item_index)
	end


		if item_index >= k_first_step_item and item_index < k_first_step_item+8 then
			local step_index = item_index - k_first_step_item + 1
			g_step_value[step_index] = remote.get_item_value(item_index)
			-- FL: Add this if the item can be disabled
			-- g_step_is_disabled[step_index] = remote.is_item_enabled(item_index)

		elseif item_index >= k_first_step_playing_item and item_index < k_first_step_playing_item+8 then
			local step_index = item_index - k_first_step_playing_item + 1
			g_step_is_playing[step_index] = remote.get_item_value(item_index)
		end
	end
--]]

end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--make a message to send to livid LCD----------------------------------------
-- TODO still not sure where this would output
function make_lcd_midi_message(text)

remote.trace(text)
	local event = remote.make_midi("F0 23 23 ") --header for SysexReader
--	local event = remote.make_midi("F0 00 20 29 02 10 14") --header for Launchpad Pro, product ID 0
--	local event = remote.make_midi("f0 00 01 61 00") --header for Livid LCD, product ID 0
	start=4
	stop=4+string.len(text)-1
	for i = start,stop do
		sourcePos = i-start+1
		event[i] = string.byte(text,sourcePos)
	end
	event[stop+1] = 247			-- hex f7
	return event
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
--	g_delivered_lcd_state = string.format("%-16.16s","Launchpad Pro")
	local retEvents={
		--default settings for Launchpad Pro

		remote.make_midi("F0 00 20 29 02 10 21 01 F7"), -- set standalone mode
--[[
		remote.make_midi("F0 00 20 29 02 10 2C 03 F7"), -- Programmer mode
		remote.make_midi("F0 00 20 29 02 10 0E 00 F7"), -- Blank all
		remote.make_midi("F0 00 20 29 02 10 14 32 00 07 05 52 65 61 73 6F 6E F7"), -- scroll Reason
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7"), --Front light
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--send all local off on settings ch 16	191,122,64 
--		remote.make_midi("bF 7A 40")
--]]
	}
	init=1
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




