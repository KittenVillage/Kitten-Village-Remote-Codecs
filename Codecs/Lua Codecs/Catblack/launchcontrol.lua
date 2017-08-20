--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Example Remote lua start

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Global Variables
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Itemnum is the array set in remote_init for knowing what the item number is
-- when we need it for remote.handle_input
Itemnum={}




--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Custom functions
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Usage: error(tableprint(tbl)) returns contents of `tbl`, with indentation.
-- You can then copy the error that reason throws into the clipboard 
-- and then restart the codec in Reason's preferences.
-- Also you can create tables on the fly to send it, like:
-- error({var1,var2,table1,table2})

function tableprint (tbl,indent)
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
--			{name="Keyboard",input="keyboard"},
--			{name="Pitch Bend", input="value", min=0, max=16383},
--			{name="Modulation", input="value", min=0, max=127},
			{name="_Scope", output="text", itemnum="scope"}, --device, e.g. "Thor" 
			{name="_Var", output="text", itemnum="var"}, --variation, e.g. "Volume" or "Filters"

			{name="Button1", input="button", min=0, max=127, itemnum="Button1"},
			{name="Button2", input="button", min=0, max=127, itemnum="Button2"},
			{name="Button3", input="button", min=0, max=127, itemnum="Button3"},
			{name="Button4", input="button", min=0, max=127, itemnum="Button4"},
			{name="Button5", input="button", min=0, max=127, itemnum="Button5"},
			{name="Button6", input="button", min=0, max=127, itemnum="Button6"},
			{name="Button7", input="button", min=0, max=127, itemnum="Button7"},
			{name="Button8", input="button", min=0, max=127, itemnum="Button8"},
			{name="Bottom1", input="value", min=0, max=127, itemnum="Bottom1"},
			{name="Bottom2", input="value", min=0, max=127, itemnum="Bottom2"},
			{name="Bottom3", input="value", min=0, max=127, itemnum="Bottom3"},
			{name="Bottom4", input="value", min=0, max=127, itemnum="Bottom4"},
			{name="Bottom5", input="value", min=0, max=127, itemnum="Bottom5"},
			{name="Bottom6", input="value", min=0, max=127, itemnum="Bottom6"},
			{name="Bottom7", input="value", min=0, max=127, itemnum="Bottom7"},
			{name="Bottom8", input="value", min=0, max=127, itemnum="Bottom8"},
			{name="Top1", input="value", min=0, max=127, itemnum="Top1"},
			{name="Top2", input="value", min=0, max=127, itemnum="Top2"},
			{name="Top3", input="value", min=0, max=127, itemnum="Top3"},
			{name="Top4", input="value", min=0, max=127, itemnum="Top4"},
			{name="Top5", input="value", min=0, max=127, itemnum="Top5"},
			{name="Top6", input="value", min=0, max=127, itemnum="Top6"},
			{name="Top7", input="value", min=0, max=127, itemnum="Top7"},
			{name="Top8", input="value", min=0, max=127, itemnum="Top8"},
			{name="Left", input="button", min=0, max=127, itemnum="Left"},
			{name="Right", input="button", min=0, max=127, itemnum="Right"},
			{name="Up", input="button", min=0, max=127, itemnum="Up"},
			{name="Down", input="button", min=0, max=127, itemnum="Down"},

		}
		remote.define_items(items)

-- some items need to be noted, so here's where Itemnum.thing is set
-- this is so we don't have to keep track of the item's index -- the order the items are defined above --
-- in remote.remote_set_state() or remote_on_auto_input() or other places.
-- turns itemnum="scope" in the definition into the variable Itemnum.scope
-- 
for it=1,table.getn(items),1 do
	if items[it].itemnum ~= nil then
		Itemnum[items[it].itemnum]=it
	end
end




--inputs
		local inputs={

			{pattern="<100?>? 09 xx", name="Button1"},
			{pattern="<100?>? 0A xx", name="Button2"},
			{pattern="<100?>? 0B xx", name="Button3"},
			{pattern="<100?>? 0C xx", name="Button4"},
			{pattern="<100?>? 19 xx", name="Button5"},
			{pattern="<100?>? 1A xx", name="Button6"},
			{pattern="<100?>? 1B xx", name="Button7"},
			{pattern="<100?>? 1C xx", name="Button8"},
			{pattern="b? 29 xx", name="Bottom1"},
			{pattern="b? 2A xx", name="Bottom2"},
			{pattern="b? 2B xx", name="Bottom3"},
			{pattern="b? 2C xx", name="Bottom4"},
			{pattern="b? 2D xx", name="Bottom5"},
			{pattern="b? 2E xx", name="Bottom6"},
			{pattern="b? 2F xx", name="Bottom7"},
			{pattern="b? 30 xx", name="Bottom8"},
			{pattern="b? 15 xx", name="Top1"},
			{pattern="b? 16 xx", name="Top2"},
			{pattern="b? 17 xx", name="Top3"},
			{pattern="b? 18 xx", name="Top4"},
			{pattern="b? 19 xx", name="Top5"},
			{pattern="b? 1A xx", name="Top6"},
			{pattern="b? 1B xx", name="Top7"},
			{pattern="b? 1C xx", name="Top8"},
			{pattern="b? 74 xx", name="Left"},
			{pattern="b? 75 xx", name="Right"},
			{pattern="b? 72 xx", name="Up"},
			{pattern="b? 73 xx", name="Down"},

		}
		remote.define_auto_inputs(inputs)

--ouputs
		local outputs={
--			{pattern="F0 00 20 29 02 10 2B 00 00 05 xx F7", name="Fader 1"},
--			{pattern="F0 00 20 29 02 10 2B 01 00 05 xx F7", name="Fader 2"}
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
	local midi_events={}
--	sysex_event = remote.make_midi("F0 00 00 00 00 xx F7",{ x = some_var, port=1 })
--	table.insert(midi_events,sysex_event)
	return midi_events
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

