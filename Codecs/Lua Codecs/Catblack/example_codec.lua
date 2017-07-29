--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Example Remote lua start

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Custom functions
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Usage: error(tableprint(tbl)) returns contents of `tbl`, with indentation.
-- You can then copy the error that reason throws into the clipboard 
-- and then restart the codec in Reason's preferences.
-- Also you can create tables on the fly to send it, like:
-- error({var1,var2,table1,table2})
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
-- Thanks to pete@lividinstruments.com
--for some Reason (pun intended) we need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Callback Functions
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
--items
		local items={
			{name="Keyboard",input="keyboard"},
			{name="Pitch Bend", input="value", min=0, max=16383},
			{name="Modulation", input="value", min=0, max=127},
			{name="Fader 1", input="value", min=0, max=127, output="value"},
			{name="Fader 2", input="value", min=0, max=127, output="value"}
		}
		remote.define_items(items)

--inputs
		local inputs={
			{pattern="b0 15 xx", name="Fader 1"},
			{pattern="b0 16 xx", name="Fader 2"},
		}
		remote.define_auto_inputs(inputs)

--ouputs
		local outputs={
			{pattern="F0 00 20 29 02 10 2B 00 00 05 xx F7", name="Fader 1"},
			{pattern="F0 00 20 29 02 10 2B 01 00 05 xx F7", name="Fader 2"},
		}
		remote.define_auto_outputs(outputs)
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_process_midi(event)
-- in this function we can use event.size event.port and event.timestamp
-- 	ret = remote.match_midi("<100x>? yy zz",event) 
--	if(ret~=nil) then
--				local msg={ time_stamp = event.time_stamp, item=4, value = ret.x, note = ret.y, velocity = ret.z }
--				remote.handle_input(msg)
--  end
-- return true --  incoming event has been handled
-- return false -- incoming event gets passed to the autoinputs
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_deliver_midi(max_bytes, port)
--	local midi_events={}
--	sysex_event = remote.make_midi("F0 00 00 00 00 xx F7",{ x = some_var, port=1 })
--	table.insert(midi_events,sysex_event)
--	return midi_events
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_set_state(changed_items)
--	for k,item_index in ipairs(changed_items) do
--		if item_index == some_num then
--			some_var = remote.get_item_value(item_index)
--		end
--	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_on_auto_input(item_index) 
--This function is called by Remote after an auto-input item message has been handled.
--The typical use is to store the current time and item index, for timed feedback texts.
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_probe(manufacturer, model, prober)
-- this is the function for autodetecting surfaces, best to have it return an empty table for now.
	return {}
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
	local retEvents={
--		remote.make_midi("F0 00 00 00 00 00 F7"), -- Sysex setup string
	}
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_release_from_use()
	local retEvents={
--		remote.make_midi("F0 00 00 00 00 00 F7"), -- Sysex sent when Reason quits
	}
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

