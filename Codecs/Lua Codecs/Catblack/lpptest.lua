




function remote_init(manufacturer, model)
		local items={
--items

			}
		remote.define_items(items)


		local inputs={

--inputs

		}
		remote.define_auto_inputs(inputs)
		
		local outputs={

--ouputs


		}
		remote.define_auto_outputs(outputs)

end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function remote_process_midi(event)

	ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
	if(ret~=nil) then




				local msg={ time_stamp = event.time_stamp, item=k_accent, value = g_accent_count, note = "2B",velocity = accent_pad.z }
				remote.handle_input(msg)
				g_delivered_note = noteout
				return true


	end

	return false


end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

		return lpp_events --send out a bunch of MIDI to the Launchpad Pro
	end --end port==1





	if(port==2) then
		local le = lcd_events
		lcd_events = {}
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
	g_delivered_lcd_state = string.format("%-16.16s","Launchpad Pro")
	local retEvents={
		--default settings for Launchpad Pro
		remote.make_midi("F0 00 20 29 02 10 21 01 F7"), -- set standalone mode
		remote.make_midi("F0 00 20 29 02 10 2C 03 F7"), -- Programmer mode
		remote.make_midi("F0 00 20 29 02 10 0E 00 F7"), -- Blank all
		remote.make_midi("F0 00 20 29 02 10 14 32 00 07 05 52 65 61 73 6F 6E F7"), -- scroll Reason
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7"), --Front light
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--send all local off on settings ch 16	191,122,64 
--		remote.make_midi("bF 7A 40")
	}
	init=1
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




