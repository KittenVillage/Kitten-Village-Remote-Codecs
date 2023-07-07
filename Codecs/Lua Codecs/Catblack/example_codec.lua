--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Example Remote lua start

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Global Variables
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Itemnum is the array set in remote_init for knowing what the item number is
-- when we need it for remote.handle_input (see below)
Itemnum={}




--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Custom functions
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Usage: error(tableprint(tbl)) returns contents of `tbl`, with indentation.
-- You can then copy the error that reason throws into the clipboard 
-- and then restart the codec in Reason's preferences.
-- Also you can create tables on the fly to send it, like:
-- error(tableprint({var1,var2,table1,table2}))
function tableprint (tbl, indent)
	local output = ''
	if not indent then indent = 0 end
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				output = output..'\n'..formatting ..'\n'..
				tableprint(v, indent+1)
			elseif type(v) == 'boolean' then
				output=output..formatting .. tostring(v)		
			else
				output=output..formatting .. tostring(v) ..'\n'
			end
		end
	end	
	return output
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- remote.trace contents of `tbl`, with indentation.
-- Same as above except for the debugger
-- useage (I think): remote.trace(tprint(table))

function tprint (tbl, indent)
	if not indent then indent = 0 end
	if type(tbl) == "table" then
		 for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				remote.trace('\n'..formatting ..'\n')
				tprint(v, indent+1)
			elseif type(v) == 'boolean' then
				remote.trace(formatting .. tostring(v))		
			else
				remote.trace(formatting .. tostring(v) ..'\n')
			end
		 end
--[[
	else
		formatting = string.rep("  ", indent) .. type(tbl) .. ": "
		remote.trace(formatting .. tostring(v) ..'\n')
--]]
	end	
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- Per the livid instruments codexes:
--for some Reason (pun intended) we need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Callback Functions


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
--items

-- 
-- Items do not have to have corresponding auto-in/outputs (as defined just below.)
-- Items in this items table defined here are used in the remotemap! 
-- Example: I had some extra buttons on my controller, so I mapped undo/redo. 
-- But I wanted to use a third button as a shift button, so I remotemapped 
-- Undo and Redo to the Undo and Redo items and also set items for the physical buttons.
-- Then in function remote_process_midi() I can use 
-- remote.match_midi("<100x>? yy zz",event) to detect a button press and check a toggle for shift
-- then building a msg and using remote.handle_input(msg) inside function remote_process_midi()
-- with Itemnum.undo and a value of 1 will trigger the undo (in the remotemap's document scope.)
-- And returning 'true' from remote_process_midi() absorbs the midi message 
-- before the auto-input defined in the input table (below, in this function.)
-- I mention this because you just need to define it here and you can then use it
-- in the remote map and in your codec.
-- 
-- Using a shifted button you could change the 'left' and 'right' buttons on transport controls
-- to drop loop left or right markers when shift button pressed
-- you'd want to have items for the markers and then tie those in the remotemap and intercept
-- the button press and tell reason the event should go to the marker item instead.
--
-- Channel pressure is included because I was dealing with a grid controller with
-- individual aftertouch on each pad, so i was able to use item definitions 
-- for each pad's aftertouch being pressed (not shown) then handled it as described above 
-- to translate that to a channel aftertouch message.
--
-- Trackname is defined below because the remote lua environment has 
-- a callback function, remote_set_state(changed_items), that gets a table of 
-- (I am pretty sure) just the items that you have defined that are 
-- 'hooked' into reason via the remotemap. (See my lpp.remotemap on this repo.)
-- 
		local items={
--			{name="Keyboard",input="keyboard"},
			{name="_Scope", output="text", itemnum="scope"}, --device, e.g. "Thor" 
			{name="_Var", output="text", itemnum="var"}, --variation, e.g. "Volume" or "Filters"
			{name="Pitch Bend", input="value", min=0, max=16383, itemnum="pitchbend"},
			{name="Modulation", input="value", min=0, max=127, itemnum="modulation"},
			{name="Channel Pressure", input="value", min=0, max=127, itemnum="channelpressure"},
			{name="TrackName", input="noinput", output="text", itemnum="trackname"},
			{name="AllStop", input="button", output="nooutput", itemnum="allstop"},
			{name="Redo", input="button", output="nooutput", itemnum="redo"},
			{name="Undo", input="button", output="nooutput", itemnum="undo"},

			{name="Fader 1", input="value", min=0, max=127, output="value"},
			{name="Fader 2", input="value", min=0, max=127, output="value"}
			{name="Button 01", input="button", min=0, max=127, output="value"},
			{name="Button 02", input="button", min=0, max=127, output="value"},
			{name="Button 03", input="button", min=0, max=127, output="value"},
		}
		remote.define_items(items)

-- some items need to have their index known, so here's where Itemnum.thing is set
-- this is so we don't have to keep track of the item's index aka
-- the order the items are defined in the items table above.--
-- Used in remote.remote_set_state() or remote_on_auto_input() or other places.
-- turns itemnum="scope" in the table definition into the variable Itemnum.scope 
-- *Lua vars are case sens!* So our new Itemnum table lets us refer to a name rather
-- an index number, very handy!
-- 
for it=1,table.getn(items),1 do
	if items[it].itemnum ~= nil then
		Itemnum[items[it].itemnum]=it
	end
end




--inputs
		local inputs={
-- You can have 2 entries with the same name but different patterns!
-- These auto-inputs fire off if the callback function remote_process_midi(event)
-- does not return true. You can over-ride them there.
-- 
			{pattern="b0 15 xx", name="Fader 1"},
			{pattern="b0 16 xx", name="Fader 2"},
			{name="Button 01",  pattern="B? 01 ?<???x>"},
			{name="Button 02",  pattern="B? 02 ?<???x>"},
			{name="Button 03",  pattern="B? 03 ?<???x>"},
		}
		remote.define_auto_inputs(inputs)

--ouputs
		local outputs={
-- these auto-outputs fire off BEFORE the callback function remote_deliver_midi()
-- So they are faster
--
--showing you can send sysex from here
			{pattern="F0 00 20 29 02 10 2B 00 00 05 xx F7", name="Fader 1"},
			{pattern="F0 00 20 29 02 10 2B 01 00 05 xx F7", name="Fader 2"},

-- My buttons have lights
			{name="Button 01",  pattern="b0 01 xx"},
			{name="Button 02",  pattern="b0 02 xx"},
			{name="Button 03",  pattern="b0 03 xx"},


		}
		remote.define_auto_outputs(outputs)
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_process_midi(event)
-- in this function we can use event.size event.port and event.timestamp
--[[
	
if event.port==1 then
-- -----------------------------------------------------------------------------------------------
-- Match buttons and notes and transpose notes.
-- -----------------------------------------------------------------------------------------------
if event.size==3 then -- Note, button, channel pressure, fader

-- 1001 is 90 (note on) 1011 is B0 (controller)	
	local ret = remote.match_midi("<10x1>? yy zz",event) --find a pad, button on or off, Not aftouch
	if(ret~=nil) then
		local button = ret.x --  check 1 = button
		ret.x = (ret.z==0) and 0 or 1 -- faking note on and off for the checks later. x is 'value', 0 or 1 for keyboard items.
		local vel_pad = ret.z

--  etc... 
-- my launchpad codec does a whole lot of checking, some sysex is event.size=8, some 9 so we handle those differently
-- it's faster to do simple checks on event.size first than to just send countless remote.match_midi() repeatedly when you don't have to!


--]]



-- 	ret = remote.match_midi("<100x>? yy zz",event) 
--	if(ret~=nil) then
--				local msg={ time_stamp = event.time_stamp, item=1, value = ret.x, note = ret.y, velocity = ret.z }
--				remote.handle_input(msg)
--  end
-- return true --  incoming event has been handled
-- return false -- incoming event gets passed to the autoinputs


end --RPM
-- 
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_deliver_midi(maxbytes,port)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- port is set in the luacodec file.
-- port is a var, not a table, this function runs when there's midi to send
-- My launchpad pro controller uses 2 ports and an if to keep from computing the data for 
-- each every time.


	local midi_events={}
--	sysex_event = remote.make_midi("F0 00 00 00 00 xx F7",{ x = some_var, port=1 })
--	table.insert(midi_events,sysex_event)
	return midi_events
end -- RDM
-- 
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Caution, RSS fires off before RPM and RDM
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_set_state(changed_items)
--tprint(changed_items)

-- example from the manual:

--	for k,item_index in ipairs(changed_items) do
--		if item_index == some_num then
--			some_var = remote.get_item_value(item_index)
--		end
--	end




--[[


--look for the _Scope constant. Kong reports "KONG". Could use for a variety of things
 
	Scope = remote.is_item_enabled(Itemnum.scope) and remote.get_item_text_value(Itemnum.scope) or ""
	Variation = remote.is_item_enabled(Itemnum.var) and remote.get_item_text_value(Itemnum.var) or ""
--]]


--[[
--	for k,item_index in ipairs(changed_items) do

-- old trackname or 'copy' so the first time you get it it doesnt update, but if you click around it does.
-- so you can duplicate a device while in a new mode, sc, tr and no change

		if item_index == Itemnum.trackname then
			local tn = string.lower(remote.get_item_text_value(item_index))
			if tn ~= State.trackname then
--				if not (string.find(tn,"transport") or string.find(tn," copy")) then
				if not (string.find(tn,"transport") or string.find(tn," copy") or string.find(tn,State.trackname,1,true)) then
					if string.find(tn,"lpp") then
						local out={}
						out.scale = tonumber(string.match(tn,"s(%d+)"))
						out.mode = tonumber(string.match(tn,"m(%d+)")) 
						out.rotate = tonumber(string.match(tn,"r(%d)"))
						out.palette = tonumber(string.match(tn,"p(%d+)"))
						out.transpose = string.match(tn,"t(%-%d+)") or string.match(tn,"t(%d+)")
						out.transpose = tonumber(out.transpose)
						State.do_update(out)
					end
				end
				State.trackname=tn --saved for later
--error(State.trackname)
			end
			-- error(remote.get_item_text_value(item_index))
		end --trackname
--	end --for k
--]]




end --RSS
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_on_auto_input(item_index)
--This function is called by Remote after an auto-input item message has been handled.
--The typical use is to store the current time and item index, for timed feedback texts.
--	g.last_input_time = remote.get_time_ms()
--	g.last_input_item = item_index


end --remote_on_auto_input()
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_probe(manufacturer, model, prober)
-- this is the function for autodetecting surfaces, best to have it return an empty table for now.
	return {}
	
-- though in the manual has
--		return { request = “f0 7e 7f 06 01 f7”,
--				response = “f0 7e 7f 06 02 6b 6d 01 00 00 ?? ?? ?? ?? f7” }

-- you should read the manual if wanting auto-detection.

end -- remote_probe()
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
	local retEvents={
--		remote.make_midi("F0 00 00 00 00 00 F7"), -- Sysex setup string
	}
	return retEvents
end -- remote_prepare_for_use()
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_release_from_use()
	local retEvents={
--		remote.make_midi("F0 00 00 00 00 00 F7"), -- Sysex sent when Reason quits
	}
	return retEvents
end -- remote_release_from_use()
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

