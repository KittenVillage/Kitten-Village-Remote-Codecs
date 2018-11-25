--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- DaScratch SCS.3d Codec by Catblack@gmail.com


--
-- circle mode
-- F0 00 01 60 01 00 f7
--
-- buttons + faders 5+6
-- F0 00 01 60 01 01 f7
--
-- faders 4,5 + buttons
-- F0 00 01 60 01 02 f7
--
-- slider mode
-- F0 00 01 60 01 03 f7
--
-- button mode
-- F0 00 01 60 01 04 f7
--






--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Global Variables
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Itemnum is the array set in remote_init for knowing what the item number is
-- when we need it for remote.handle_input
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

			{name="Gain Slider", 	input="value",  output="value" min=0, max=127,	itemnum="GainSlider"	},
			{name="Pitch Slider", 	input="value",  output="value" min=0, max=127,	itemnum="PitchSlider"	},
			{name="FX Button", 	input="button", output="value" min=0, max=127,	itemnum="FXButton"	},
			{name="EQ Button", 	input="button", output="value" min=0, max=127,	itemnum="EQButton"	},
			{name="LOOP Button", 	input="button", output="value" min=0, max=127,	itemnum="LOOPButton"	},
			{name="TRIG Button", 	input="button", output="value" min=0, max=127,	itemnum="TRIGButton"	},
			{name="VINYL Button", 	input="button", output="value" min=0, max=127,	itemnum="VINYLButton"	},
			{name="DECK Button",	input="button", output="value" min=0, max=127,	itemnum="DECKButton"	},
			{name="Circle", 	input="value",  output="value" min=0, max=127,	itemnum="Circle"	},
			{name="Slider 3", 	input="value",  output="value" min=0, max=127,	itemnum="Slider3"	},
			{name="Slider 4", 	input="value",  output="value" min=0, max=127,	itemnum="Slider4"	},
			{name="Slider 5", 	input="value",  output="value" min=0, max=127,	itemnum="Slider5"	},
			{name="Button 1", 	input="button", output="value" min=0, max=127,	itemnum="Button1"	},
			{name="Button 2", 	input="button", output="value" min=0, max=127,	itemnum="Button2"	},
			{name="Button 3", 	input="button", output="value" min=0, max=127,	itemnum="Button3"	},
			{name="Button 4", 	input="button", output="value" min=0, max=127,	itemnum="Button4"	},
			{name="Button 5", 	input="button", output="value" min=0, max=127,	itemnum="Button5"	},
			{name="Button 6", 	input="button", output="value" min=0, max=127,	itemnum="Button6"	},
			{name="Button 7", 	input="button", output="value" min=0, max=127,	itemnum="Button7"	},
			{name="Button 8", 	input="button", output="value" min=0, max=127,	itemnum="Button8"	},
			{name="PLAY Button", 	input="button", output="value" min=0, max=127,	itemnum="PLAYButton"	},
			{name="CUE Button", 	input="button", output="value" min=0, max=127,	itemnum="CUEButton"	},
			{name="SYNC Button", 	input="button", output="value" min=0, max=127,	itemnum="SYNCButton"	},
			{name="TAP Button", 	input="button", output="value" min=0, max=127,	itemnum="TAPButton"	},
			{name="Round Button 1",	input="button", output="value" min=0, max=127,	itemnum="RoundButton1"	},
			{name="Round Button 2",	input="button", output="value" min=0, max=127,	itemnum="RoundButton2"	},
			{name="Round Button 3",	input="button", output="value" min=0, max=127,	itemnum="RoundButton3"	},
			{name="Round Button 4",	input="button", output="value" min=0, max=127,	itemnum="RoundButton4"	}

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
			{name="Gain Slider", 	pattern="B? 07 xx"},
			{name="Pitch Slider", 	pattern="B? 03 xx"},
			{name="FX Button", 	pattern="<100x>? 20 zz"},
			{name="EQ Button", 	pattern="<100x>? 26 zz"},
			{name="LOOP Button", 	pattern="<100x>? 22 zz"},
			{name="TRIG Button", 	pattern="<100x>? 28 zz"},
			{name="VINYL Button", 	pattern="<100x>? 24 zz"},
			{name="DECK Button",	pattern="<100x>? 2A zz"},
			{name="Circle", 	pattern="B? 62 xx"},
			{name="Slider 3", 	pattern="B? 0C xx"},
			{name="Slider 4", 	pattern="B? 01 xx"},
			{name="Slider 5", 	pattern="B? 0E xx"},
			{name="Button 1", 	pattern="<100x>? 48 zz"},
			{name="Button 2", 	pattern="<100x>? 4A zz"},
			{name="Button 3", 	pattern="<100x>? 4C zz"},
			{name="Button 4", 	pattern="<100x>? 4E zz"},
			{name="Button 5", 	pattern="<100x>? 4F zz"},
			{name="Button 6", 	pattern="<100x>? 51 zz"},
			{name="Button 7", 	pattern="<100x>? 53 zz"},
			{name="Button 8", 	pattern="<100x>? 55 zz"},
			{name="PLAY Button", 	pattern="<100x>? 6D zz"},
			{name="CUE Button", 	pattern="<100x>? 6E zz"},
			{name="SYNC Button", 	pattern="<100x>? 6F zz"},
			{name="TAP Button", 	pattern="<100x>? 70 zz"},
			{name="Round Button 1",	pattern="<100x>? 2C zz"},
			{name="Round Button 2",	pattern="<100x>? 2E zz"},
			{name="Round Button 3",	pattern="<100x>? 30 zz"},
			{name="Round Button 4",	pattern="<100x>? 32 zz"}
		}
		remote.define_auto_inputs(inputs)

--ouputs
		local outputs={
--			{pattern="F0 00 20 29 02 10 2B 00 00 05 xx F7", name="Fader 1"},
--			{pattern="F0 00 20 29 02 10 2B 01 00 05 xx F7", name="Fader 2"},
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

