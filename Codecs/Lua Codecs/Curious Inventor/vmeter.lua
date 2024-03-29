--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- VMeter Remote Codec and Map for Reason
-- by Catblack@gmail.com paypal me a few bucks if you find this useful.
-- and if you want to sell your VMeter, sell it to me!
-- VMeter made by Curious Inventor http://www.vmeter.net/
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- set some globals
g_ledarray = {}
newarray = {}
for q=1,38 do
	g_ledarray[q]=0
	newarray[q]=0
end
-- a new array for game of life note output.
notearray = {}
for q=1,12 do
	notearray[q]=0
--	noteoffarray[q]=0
end

--[[
thisledarray = {1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0}
--]]

--Game of Life starters
--[[
    g_ledarray = {1,1,1,1,1,1,1,0,0,0,
                 0,0,0,0,0,0,1,1,1,1,
                 0,1,1,0,0,1,1,1,0,0,
                 0,0,0,1,0,0,0,0}
--]]
--[[
    g_ledarray = {1,0,1,1,1,1,1,0,0,0,
                 0,0,0,0,0,0,1,1,1,1,
                 0,1,1,0,0,1,1,1,0,0,
                 0,0,0,1,0,0,1,0}
--]]

    g_ledarray = {1,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,1,0,1,0,
                 0,1,0,0,0,1,0,0,0,0,
                 0,0,0,1,0,0,0,0}
				 
				 


g_current_state=-1
g_last_state_delivered=-1
--g_led_state=table.concat(g_ledarray)
--g_delivered_led_state=table.concat(g_ledarray)
g_thismodel = ""
g_last_noteonoff = -1 --Note detection for turning off released notes
g_current_noteonoff = -1

--These now follow BPM set in their functions. initial time below
g_last_cycle_time = 0 -- Game of Life timing
g_last_note_cycle_time = 0 -- Game of Life Note timing
GoLtime = 100
GoLnotetime = 100
--GoLtime = math.floor((60000/BPM)/GoLratio)
GoLratio=6
GoLnoteratio=1

-- Velocity preset
Vel = "7F"

-- All caps coz they are from the firmware.
-- More here than we need or use, but don't want to dig for this info again.

-- Midi control nums for outgoing items, hex
MAIN_PARAM_CTRL = "77"
ECHO_CTRL = "76"
CHANGE_MIDI_CHAN_CTRL = "75"
CHANGE_POS_OUT_CTRL = "74"
CHANGE_ON_OFF_OUT_CTRL = "73"
CHANGE_PRES_OUT_CTRL = "72"
CHANGE_LIGHT_IN_CTRL = "71"
CHANGE_BRIGHT_IN_CTRL = "70"
CHANGE_NOTEOUT_NUMBER_CTRL = "6F"
CHANGE_NOTEOUT_VEL_CTRL = "6E"
VERSION_OUTPUT_CTRL = "6D"
SENSITIVITY_CTRL = "6C"
PITCH_WHEEL_RETURN_SPEED_CTRL = "6B"

--Undocumented by vmeter instructions, low numbers best
PITCH_WHEEL_RETURN_SPEED = "B0 " .. PITCH_WHEEL_RETURN_SPEED_CTRL .. " 01"

ALLNOTESOFF="Bf 78 00 bf 72 40 bf 7b 00 bF 7A 40"

--Chan 1 
Ch1Main  = "B0 "..	MAIN_PARAM_CTRL	
SetVel = "B0 " .. CHANGE_NOTEOUT_VEL_CTRL .. " " .. Vel
ClearLED ="B0 14 00"

-- Ctrl 119 (77h) Parameter items
--UPGRADE_FIRM = Ch1Main ..	"7F"
UPSIDE_DOWN_OFF = Ch1Main ..	"7E"
UPSIDE_DOWN_ON = Ch1Main ..	"7D"
TOUCH_POS_OUT_ENABLE = Ch1Main ..	"7C"
TOUCH_POS_OUT_DISABLE = Ch1Main ..	"7B"
PRES_OUT_ENABLE = Ch1Main ..	"7A"
PRES_OUT_DISABLE = Ch1Main ..	"79"
ON_OFF_OUT_ENABLE = Ch1Main ..	"78"
ON_OFF_OUT_DISABLE = Ch1Main ..	"77"
--STORE_SETTINGS = Ch1Main ..	"76"
NOTE_OUT_ENABLE = Ch1Main ..	"75"
NOTE_OUT_DISABLE = Ch1Main ..	"74"
PITCH_WHEEL_ENABLE = Ch1Main ..	"73"
PITCH_WHEEL_DISABLE = Ch1Main ..	"72"
--READ_SETTINGS = Ch1Main ..	"71"
--RECALIBRATE = Ch1Main ..	"70"
NOTEOUT_VEL_FROM_POS = Ch1Main ..	"6F"
NOTEOUT_VEL_FROM_PRESET = Ch1Main ..	"6E"
NOTEOUT_PITCH_FROM_POS = Ch1Main ..	"6D"
NOTEOUT_PITCH_FROM_PRESET = Ch1Main ..	"6C"
LEDS_IGNORE_TOUCH = Ch1Main ..	"6B"
LEDS_DONT_IGNORE_TOUCH = Ch1Main ..	"6A"

CROSS_FADE_ENABLE = Ch1Main ..	"69"
CROSS_FADE_DISABLE = Ch1Main ..	"68"
GET_VERSION = Ch1Main ..	"67"

FILTER_ENABLE = Ch1Main ..	"66"
FILTER_DISABLE = Ch1Main ..	"65"

-- Midi control nums for incoming items, hex 
MIDI_POS_OUT_CTRL = "14"
MIDI_TOUCH_ON_OFF_CTRL = "11"
MIDI_PRES_OUT_CTRL = "12"
MIDI_COL_HEIGHT_CTRL = "14"
MIDI_BRIGHTNESS_CTRL = "15"
UPSIDE_DOWN_MODE_CTRL = "1E"
--RECALIBRATE_TOUCH_SENSOR_CTRL = "1F"
EN_TOUCH_POS_OUTPUT_CTRL = "22"
EN_ON_OFF_OUTPUT_CTRL = "23"
EN_PRES_OUTPUT_CTRL = "24"
--UPGRADE_FIRMWARE_NOTE = "3C"
--STORE_SETTINGS_NOTE = "43"



-- Thanks, Livid
--for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end



function SetLEDArray(ledarray)
    --# assuming 38 length array
    --# need to split array into (6) 7bit chunks
    --# Individual LED control is sent to the aftertouch MIDI command and channels 14, 15 and 16.
    --# Each of the data bytes transmit 7 LED states.
--
   local bytes = {0,0,0,0,0,0}

    bytes[1] = ledarray[1] + bit.lshift(ledarray[2],1) + bit.lshift(ledarray[3],2) + bit.lshift(ledarray[4],3) + bit.lshift(ledarray[5],4) + bit.lshift(ledarray[6],5) + bit.lshift(ledarray[7],6)
    bytes[2] = ledarray[8] + bit.lshift(ledarray[9],1) + bit.lshift(ledarray[10],2) + bit.lshift(ledarray[11],3) + bit.lshift(ledarray[12],4) + bit.lshift(ledarray[13],5) + bit.lshift(ledarray[14],6)
    bytes[3] = ledarray[15] + bit.lshift(ledarray[16],1) + bit.lshift(ledarray[17],2) + bit.lshift(ledarray[18],3) + bit.lshift(ledarray[19],4) + bit.lshift(ledarray[20],5) + bit.lshift(ledarray[21],6)
    bytes[4] = ledarray[22] + bit.lshift(ledarray[23],1) + bit.lshift(ledarray[24],2) + bit.lshift(ledarray[25],3) + bit.lshift(ledarray[26],4) + bit.lshift(ledarray[27],5) + bit.lshift(ledarray[28],6)
    bytes[5] = ledarray[29] + bit.lshift(ledarray[30],1) + bit.lshift(ledarray[31],2) + bit.lshift(ledarray[32],3) + bit.lshift(ledarray[33],4) + bit.lshift(ledarray[34],5) + bit.lshift(ledarray[35],6)
    bytes[6] = ledarray[36] + bit.lshift(ledarray[37],1) + bit.lshift(ledarray[38],2)

--remote.trace(tostring(table.concat(g_ledarray))..'\n')	-- this is fun
	return bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6]
end


function DrawCursor(height)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,38 do
		led_array_deque[q] =0
	end
    local cursor_pos = math.floor((height / 127.0) * 38.0)
    if cursor_pos > 38 then
        cursor_pos = 38
	end
--   if cursor_pos < 1 then --No zero!
--        cursor_pos = 1
--	end
    led_array_deque[cursor_pos] = 1 --# turn on one LED
--remote.trace(table.concat(led_array_deque))
return led_array_deque
end



--# draws a bar centered at height position with a given size.
--# Kinda like a fat cursor.
function DrawBar(height,size)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,38 do
		led_array_deque[q] =0
	end
    local cursor_pos = math.floor((height / 127.0) * 38.0)
    local lower_limit = cursor_pos - math.floor(size / 2)
    if lower_limit < 1 then
        lower_limit = 1
		end
    local upper_limit = cursor_pos + math.floor(size / 2)
    if upper_limit > 38 then
        upper_limit = 38
	end
    local i = lower_limit
    while i <= upper_limit do
        led_array_deque[i] = 1
        i = i + 1
	end
    return led_array_deque
end


function adjust_speed(new_speed,speed)
--# here average the new_speed with the old speed
    speed = (new_speed * .2) + (speed * .8)
    return speed
end


--# this causes the LEDs to act like a scrolled page on a tablet.
--# Simulated acceleration provides a smooth start and stop effect.
function ChaseDemoWithSpeedInput(pos,noteonoff) 
    x = 1
    speed = 500
    last_time = 0
    last_speed_calc_time = 0
    prev_pos = 0
    pos = 0
    prev_last_input_time = 0
    last_input_time = 0
    speed = 0.0
    new_speed = 0.0
    pos_array = {0, 0, 0, 0, 0}
--    pos_array = deque(pos_array)
    time_array = {0, 0, 0, 0, 0}
    print_time = 0
    led_shift_time = 0
    touch_state = 0
    brake_time = 0
    
    led_deque = {1,1,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,1,1,
                       0,0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0}
--    SendArray(led_deque, MidiOut)
--    EnableOnOffOutput(MidiOut)
-- controller 17 note on off!


-- how to do this in lua    
--    while True:
--        while MidiIn.Poll(): # throw out all but the latest input
--            MidiData = MidiIn.Read(1)            
--            if MidiData[0][0][0] == 0xB0:
--                if MidiData[0][0][1] == 20:
--                    pos = MidiData[0][0][2]
--                    pos_array.appendleft(pos)
                    pos_array = table.insert(pos_array, 1, pos)
--#                    pos_array.pop()
--                   last_input_time = MidiData[0][1]
                   last_input_time = remote.get_time_ms()
--                    time_array.appendleft(last_input_time)
                    time_array = table.insert(time_array, 1, last_input_time)
--#                    time_array.pop()
--#                    print(last_input_time)
--                elif MidiData[0][0][1] == 17: # on / off output. 127 is touch, 0 is release
-- 17 means note mode
--                    if MidiData[0][0][2] == 127:
                   if (noteonoff == 127) then
--#                        print "touch"
                        touch_state = 1
                    elseif (noteonoff == 0) then
--#                        print "release"
                        touch_state = 0
					end
    
        if (last_input_time > last_speed_calc_time) then  --# calc speed
            last_speed_calc_time = remote.get_time_ms()
            pos_delta = pos_array[1] - pos_array[5]
            time_delta = time_array[1] - time_array[5]
            if (time_delta > 0) then
                new_speed = pos_delta / time_delta
			end

            speed = adjust_speed(new_speed,speed)
		end


--        # handle case where VMeter is being touched, but position isn't moving
        if ((touch_state == 1) and ((remote.get_time_ms() - last_input_time) > 100)) then
--            # reduce speed to 0
            if remote.get_time_ms() - brake_time > 17 then
                brake_time = remote.get_time_ms()
--#                print "braking"
                speed = adjust_speed(0.0,speed)
			end
		end

        if remote.get_time_ms() - print_time > 150 then
            print_time = remote.get_time_ms()
--#            if abs(speed) > .01:
--#                print "speed: ", speed, ", per: ", 1.0 / speed
         elseif remote.get_time_ms() - last_input_time > 100 then
--               # friction braking
            speed = adjust_speed(0.0,speed)
		end

                    
        if ((math.abs(speed) > .001) and ((remote.get_time_ms() - led_shift_time) > math.floor(2.5/math.abs(speed)))) then
            led_shift_time = remote.get_time_ms()
            if speed > 0.0 then
                led_deque.rotate(1)
             else 
                led_deque.rotate(-1)
			end
		end
			return led_deque
--[[
            -- SendArray(led_deque, MidiOut)
--]]
end

function GameOfLife(pos)
--[[
# A Game of Life simulation is usually performed on a 2D matrix, but here
# we apply similar rules to the 1D VMeter array of LEDs.
# Each cycle, a given LED is turned on or off based on how many of its neighbors
# are on or off.
# Different starting configurations will result in different patterns,
# some die off, some enter into a repeating cycle, and others continue to
# evolve.
# Touching the VMeter will cause the LEDs touched to switch states, which can restart
# a simulation that has died off.
--]]
-- This is interpreted from the python demo. 
-- It uses two (global) arrays to calculate
-- Game of Life Note mode uses these arrays to generate a note.

	BPM = tonumber(remote.get_item_text_value(g_item_index))
	GoLtime = math.floor((60000/BPM)/GoLratio)

	if ( pos == nil ) then -- it's a time update	
		if ((remote.get_time_ms() - g_last_cycle_time) > GoLtime) then
			g_last_cycle_time = remote.get_time_ms()

-- This is in the python demo, not sure why. all leds set below			
			for i=1, 38 do
					newarray[i] = g_ledarray[i]
			end

--	# copy over 4 edge LEDs since they don't have 4 neighbors.
			newarray[1] = g_ledarray[1]
			newarray[2] = g_ledarray[2]
			newarray[37] = g_ledarray[37]
			newarray[38] = g_ledarray[38]
			
			for i=3,36 do
				sum = g_ledarray[i - 2] + g_ledarray[i - 1] + g_ledarray[i + 1] + g_ledarray[i + 2]
--remote.trace('i '..tostring(i)..' sum '..tostring(sum)..'\n')
				if g_ledarray[i] == 1 then -- # live cell
					if sum < 1 then
						newarray[i] = 0 --# under population
					elseif sum < 3 then
						newarray[i] = 1 --# just right
					else 
						newarray[i] = 0 --# overcrowding
					end
				else -- dead cell
					if sum == 2 or sum == 3 then
						newarray[i] = 1
					else
						newarray[i] = 0
					end
				end -- if
			end -- for
			for i=1,38 do
				g_ledarray[i] = newarray[i]
			end
		end -- time if

	elseif (pos > 0) then -- it's not a time update
		local index_pos = math.ceil((pos / 127) * 38)
--remote.trace(' pos '..tostring(pos)..' inpos '..tostring(index_pos))	
		if g_ledarray[index_pos] == 1 then
			g_ledarray[index_pos] = 0
		else
			g_ledarray[index_pos] = 1
		end
	end -- pos check
--remote.trace(tostring(table.concat(newarray))..'\n')
            
	return g_ledarray
end 

function GameOfLifeNote()
	BPM = tonumber(remote.get_item_text_value(g_item_index))
	GoLnotetime = math.floor((60000/BPM)/GoLnoteratio)
-- generate a note based on g_ledarray[3] to [36]
-- if 3 leds in a row are on,  we send a note on in the array
-- if 3 leds in a row are off, we send a note off in the array
	local newnote = {}
		if ((remote.get_time_ms() - g_last_note_cycle_time) > GoLnotetime) then
			g_last_note_cycle_time = remote.get_time_ms()
			for o=1, 12 do
				if ((g_ledarray[(o*3)-2] == 1) and (g_ledarray[(o*3)-1] == 1) and (g_ledarray[(o*3)] == 1) and notearray[o] == 0) then -- turn on note
					table.insert(newnote, "90 ".. string.format("%X", (o + 35)) .. " " .. Vel)
					notearray[o] = 1
--remote.trace("note:".."90 ".. string.format("%x", (o + 35)) .. " " .. Vel..'\n')
				elseif ((g_ledarray[(o*3)-2] == 0) and (g_ledarray[(o*3)-1] == 0) and (g_ledarray[(o*3)] == 0) and notearray[o] == 1) then -- turn off note
					table.insert(newnote, "80 ".. string.format("%X", (o + 35)) .. " 00")
					notearray[o] = 0
--remote.trace("note:".."80 ".. string.format("%x", (o + 35)) .. " 00")
				end -- if
			end -- for
		end -- if
--remote.trace("note:"..tostring(table.getn(newnote)))
	return newnote -- array!
end








function DrawNote(note)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,39 do
		led_array_deque[q] =0
		if modulo(q,3) == 0 then -- Give me some targets for the notes.
			led_array_deque[q - 1] =1
		end
	end
--	if (height > 9) and (height < 118) then -- 3 leds per note \ 0-9 and 118-127 blank*
--		local note = math.ceil((height-9) / 9) -- returns 1 to 12 \ 1 and 38 blank
	if g_current_noteonoff == 1 then
        led_array_deque[(note*3)-1] = 1
        led_array_deque[(note*3)]   = 1
        led_array_deque[(note*3)+1] = 1
	end
    return led_array_deque
end



function DrawButton(note)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,42 do
		led_array_deque[q] =0
		if modulo(q,6) == 0 then -- Give me some targets for the notes.
			led_array_deque[q - 5] =1
		end
	end
	if g_current_noteonoff == 1 then
        led_array_deque[(note*6)-4] = 1
        led_array_deque[(note*6)-3] = 1
        led_array_deque[(note*6)-2] = 1
        led_array_deque[(note*6)-1] = 1
        led_array_deque[(note*6)]   = 1
	end
    return led_array_deque
end


function DrawDrums(note)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,38 do
		led_array_deque[q] =0
		if modulo(q,4) == 0 and q <37 then -- Give me some targets for the notes.
			led_array_deque[q - 3] =1
		end
	end
	if g_current_noteonoff == 1 then
        led_array_deque[(note*4)]   = 1
        led_array_deque[(note*4)-1] = 1
        led_array_deque[(note*4)-2] = 1
	end
    return led_array_deque
end








function remote_init(manufacturer, model)
	g_thismodel = model -- This is the key to piling many maps into one lua file
	local items={}
	local inputs={}
	local outputs={}

	if model == "VMeter Fader" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		{name="Fader"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Fader Fat Cursor" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		{name="Fader"          ,	pattern="b0 16 xx"}, --dummy output!
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Fader Single Cursor" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		{name="Fader"          ,	pattern="b0 16 xx"}, --dummy output!
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Game of Life Demo" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
			{name="TempoBPM" ,	output="text"},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="Fader"          ,	pattern="b0 16 xx"}, --dummy output!
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Game of Life Note" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
			{name="TempoBPM" ,	output="text"},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="Fader"          ,	pattern="b0 16 xx"}, --dummy output!
		}
		remote.define_auto_outputs(outputs)
		
		
	
	elseif model == "VMeter Notes" then
		items=
		{
			{name="Keyboard",          	input="keyboard"},
	--	{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={
			{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="b0 12 xx",        	name="Channel Aftertouch"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		}
		remote.define_auto_outputs(outputs)
		
	
	elseif model == "VMeter Six Button" then
		items=
		{
			{name="Button 1", input="button", output="value"},
			{name="Button 2", input="button", output="value"},
			{name="Button 3", input="button", output="value"},
			{name="Button 4", input="button", output="value"},
			{name="Button 5", input="button", output="value"},
			{name="Button 6", input="button", output="value"},
			{name="Keyboard",          	input="keyboard"}, 
		}

		remote.define_items(items)
		
		inputs={
			{pattern="<100x>0 yy zz",	name="Keyboard"},
		} 
		remote.define_auto_inputs(inputs)

		outputs={
			{name="Button 1"          ,	pattern="b0 16 xx"}, --dummy output!
			{name="Button 2"          ,	pattern="b0 16 xx"}, --dummy output!
			{name="Button 3"          ,	pattern="b0 16 xx"}, --dummy output!
			{name="Button 4"          ,	pattern="b0 16 xx"}, --dummy output!
			{name="Button 5"          ,	pattern="b0 16 xx"}, --dummy output!
			{name="Button 6"          ,	pattern="b0 16 xx"}, --dummy output!
			
		}
		remote.define_auto_outputs(outputs)
		
	
	elseif model == "VMeter Drums" then
		items=
		{
			{name="Keyboard",          	input="keyboard"},
	--	{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={
			{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="b0 12 xx",        	name="Channel Aftertouch"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		}
		remote.define_auto_outputs(outputs)
		

	elseif model == "VMeter Pitch Wheel" then
		items=
		{
			{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
		}

		remote.define_items(items)
		
		inputs={
			{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		}
		remote.define_auto_outputs(outputs)


	elseif model == "VMeter Modulation Wheel" then
		items=
		{
			{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={
			{pattern="b0 14 xx",     	name="Modulation Wheel"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="Modulation Wheel",	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		

	elseif model == "VMeter Meter" then
		items=
		{
			{name="Input",            	input="value",	output="value",	min=0,	max=127},
			{name="Output",            	input="noinput",	output="value",	min=0,	max=127},
	}
		

		remote.define_items(items)
		
		inputs={

			{pattern="b0 14 xx",     	name="Input"},

		}
		remote.define_auto_inputs(inputs)

		outputs={
		{name="Output"          ,	pattern="b0 14 xx"}, 
		}
		remote.define_auto_outputs(outputs)


-- Models below TBD.	

	elseif model == "VMeter Fader Gravity" then
		items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		outputs={
		{name="Fader"          ,	pattern="b0 16 xx"}, --dummy output!
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Crossfader" then
		items=
		{
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		

	elseif model == "VMeter Button" then
		items=
		{
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={

			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		

	elseif model == "VMeter Delta" then
		items=
		{
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		

		remote.define_items(items)
		
		inputs={
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		outputs={
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
	end --if model
	g_item_index=table.getn(items) --last item in the items table, because that's where we will put something interesting, like BPM    
end

--You should know what you've pluged into your computer.
function remote_probe()
	return {
	}
end


-- Unused, included just in case.
g_last_input_time=-2000
g_last_input_item=nil

function remote_on_auto_input(item_index)
	if item_index==1 then
		g_last_input_time=remote.get_time_ms()
		g_last_input_item=item_index
	end

end






function remote_process_midi(event)
	-- local ret = nil
	if ((g_thismodel == "VMeter Fader Fat Cursor") or (g_thismodel == "VMeter Fader Single Cursor") or (g_thismodel == "VMeter Game of Life Demo") or (g_thismodel == "VMeter Game of Life Note")) then
		ret=remote.match_midi("b0 "..MIDI_POS_OUT_CTRL.." xx",event)
		if ret~=nil then
			local new_state=ret.x
			if g_last_state_delivered~=new_state then
				g_current_state=new_state
			end
			--return true
		end
	elseif (g_thismodel == "VMeter Notes") or (g_thismodel == "VMeter Drums") or (g_thismodel == "VMeter Six Button")  then
		ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
		if ret~=nil then
			local new_noteonoff = ret.x
			local new_notein=ret.y
			local new_notevel = ret.z 
--			remote.trace("new_notein "..tostring(new_notein))

			if (new_notein > 9) and (new_notein < 122) and (g_thismodel == "VMeter Notes") then -- 3 leds per note \ 0-9 and 118-127 blank*
				local new_state = math.ceil((new_notein - 9) / 9) -- returns 1 to 12 \ 1 and 38 blank
				if new_state==13 then new_state=12 end--*having trouble hitting last note, expand box
				local new_noteout = new_state + 35  -- Middle octave
				local msg={ time_stamp = event.time_stamp, item=1, value = new_noteonoff, note = new_noteout,velocity = new_notevel }
				remote.handle_input(msg)
				--make this next a function
				if (g_last_state_delivered~=new_state) then -- draw new note
					g_current_state=new_state
					g_current_noteonoff = new_noteonoff
				elseif g_last_noteonoff~=new_noteonoff then
					g_current_noteonoff = new_noteonoff
				end
				return true -- changed
				
			elseif (new_notein > 7) and (new_notein < 120) and (g_thismodel == "VMeter Drums") then -- 4 leds per note \ 0-7 and 120-127 blank
				local new_state = math.ceil((new_notein - 7) / 14) -- returns 1 to 8 
				local new_noteout = new_state + 35  -- Middle octave
				local msg={ time_stamp = event.time_stamp, item=1, value = new_noteonoff }
				remote.handle_input(msg)
				if (g_last_state_delivered~=new_state) then -- draw new note
					g_current_state=new_state
					g_current_noteonoff = new_noteonoff
				elseif g_last_noteonoff~=new_noteonoff then
					g_current_noteonoff = new_noteonoff
				end
				return true -- changed
				
-- 6 button 
			elseif (new_notein > 0) and (new_notein < 127) and (g_thismodel == "VMeter Six Button") then -- 6 leds per note \ 0 and 127 blank
				local new_state = math.ceil((new_notein) / 21) -- returns 1 to 6 
-- Sets item on or off
				local msg={ time_stamp = event.time_stamp, item=new_state, value = new_noteonoff, note = new_noteout,velocity = new_notevel }
				remote.handle_input(msg)
				if (g_last_state_delivered~=new_state) then -- draw new note
					g_current_state=new_state
					g_current_noteonoff = new_noteonoff
				elseif g_last_noteonoff~=new_noteonoff then
					--g_current_noteonoff = new_noteonoff -- let rmote_set_state handle... not while pressed.
				end
				return true -- changed
-- 6 button end

			else -- note out of range
				return true -- out of range, should stop input 
			end -- ret 
			--return true 
		end
	end -- g_thismodel check
	return false --false because we detect, not change the input
end


function remote_set_state(changed_items)

	for i,item_index in ipairs(changed_items) do
--remote.trace("setstate i :"..tostring(i).." : "..tostring(item_index).." val: "..tostring(remote.get_item_value(item_index)).."last del: ".. tostring(remote.get_item_value(g_last_state_delivered)))		
-- 6 button 
		if (g_thismodel == "VMeter Six Button") then -- 6 leds per note \ 0 and 127 blank
			local new_state = item_index -- returns 1 to 6, maybe 7?
			local new_noteonoff = remote.get_item_value(item_index)
			if (g_last_state_delivered~=new_state) then -- draw new note
				g_current_state=new_state
				g_current_noteonoff = new_noteonoff
			elseif g_last_noteonoff~=new_noteonoff then
				g_current_noteonoff = new_noteonoff
			end
			
		else 	
			local new_state=remote.get_item_value(item_index)
			if g_last_state_delivered~=new_state then
				g_current_state=new_state
			end
		end -- if
	end
end





function remote_deliver_midi(max_bytes,port)
	local ret_events={}
	local new_state=g_current_state
	local new_noteonoff=g_current_noteonoff
--These are only set in an led array function
	local ledoutput = {}
	local faderout = -1

	if(port==1) then -- You can not mix remote.make_midi events meant for different ports!

		if (g_last_state_delivered~=new_state) or (g_last_noteonoff~=new_noteonoff) then
--remote.trace(tostring(new_state ))		
-- other led functions go here depending on model.  
			if g_thismodel == "VMeter Fader Single Cursor" then
				ledoutput ={SetLEDArray(DrawCursor(new_state))}
			elseif g_thismodel == "VMeter Fader Fat Cursor" then
				ledoutput ={SetLEDArray(DrawBar(new_state, 5))}
			elseif g_thismodel == "VMeter Notes" then
				ledoutput ={SetLEDArray(DrawNote(new_state))}
			elseif (g_thismodel == "VMeter Six Button") and (new_state < 7) then -- don't know if this could be 7/keyboard, but... I need keyboard as an input...
				ledoutput ={SetLEDArray(DrawButton(new_state))}
			elseif g_thismodel == "VMeter Drums" then
				ledoutput ={SetLEDArray(DrawDrums(new_state))}
			elseif (g_thismodel == "VMeter Fader") or (g_thismodel == "VMeter Modulation Wheel") or (g_thismodel == "VMeter Meter") then
				faderout = new_state
			elseif (g_thismodel == "VMeter Game of Life Demo") or (g_thismodel == "VMeter Game of Life Note") then
				ledoutput ={SetLEDArray(GameOfLife(new_state))}
			end -- model setting
--remote.trace(tostring(table.getn(ledoutput) ))		

			g_last_state_delivered = new_state
			g_last_noteonoff = new_noteonoff
			
		elseif (((g_thismodel == "VMeter Game of Life Demo") or (g_thismodel == "VMeter Game of Life Note")) and ((remote.get_time_ms() - g_last_cycle_time) > GoLtime)) then
-- No new input, but change it after an interval.

			ledoutput ={SetLEDArray(GameOfLife())} -- Update it, don't send input
		end -- state and note (elseif time) check
		
		if table.getn(ledoutput) == 6 then -- ledoutput is a six byte array
			ret_events={
				remote.make_midi("ad xx yy",{ x = ledoutput[1], y = ledoutput[2], port=1 }),
				remote.make_midi("ae xx yy",{ x = ledoutput[3], y = ledoutput[4], port=1 }),
				remote.make_midi("af xx yy",{ x = ledoutput[5], y = ledoutput[6], port=1 }),
			}
		elseif faderout > 0 then  -- drawing the bar
			ret_events={
				remote.make_midi("b0 14 xx",{ x = faderout, port=1 }),
			}
		end
	end -- port
	if(port==2) then

-- Adding a bit here to deliver a note in a second GoL mode
		if ((g_thismodel == "VMeter Game of Life Note") and ((remote.get_time_ms() - g_last_note_cycle_time) > GoLnotetime)) then
			local notelist = GameOfLifeNote() 

			for u,n in ipairs(notelist) do
				local note_event=remote.make_midi(n)
				table.insert(ret_events,note_event)
--	remote.trace("note:"..n)
			end -- for
		end -- if
	end -- port

	return ret_events
end


function remote_prepare_for_use()

	if g_thismodel == "VMeter Fader" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			--remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Single Cursor" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Fat Cursor" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Gravity" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif (g_thismodel == "VMeter Game of Life Demo" or g_thismodel == "VMeter Game of Life Note") then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ClearLED, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Notes" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_ENABLE, { port=1 } ),
			remote.make_midi(NOTEOUT_VEL_FROM_PRESET, { port=1 } ),
			remote.make_midi(NOTEOUT_PITCH_FROM_POS, { port=1 } ),
		}
		return retEvents


	elseif g_thismodel == "VMeter Six Button" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_ENABLE, { port=1 } ),
			remote.make_midi(NOTEOUT_VEL_FROM_PRESET, { port=1 } ),
			remote.make_midi(NOTEOUT_PITCH_FROM_POS, { port=1 } ),
		}
		return retEvents


	elseif g_thismodel == "VMeter Drums" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_ENABLE, { port=1 } ),
			remote.make_midi(NOTEOUT_VEL_FROM_PRESET, { port=1 } ),
			remote.make_midi(NOTEOUT_PITCH_FROM_POS, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Pitch Wheel" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_RETURN_SPEED, { port=1 } ),
			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_ENABLE, { port=1 } ),
			remote.make_midi(CROSS_FADE_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents
	elseif g_thismodel == "VMeter Modulation Wheel" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_RETURN_SPEED, { port=1 } ),
			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_ENABLE, { port=1 } ),
			remote.make_midi(CROSS_FADE_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

		
	elseif g_thismodel == "VMeter Crossfader" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(CROSS_FADE_ENABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents
		
	elseif g_thismodel == "VMeter Delta" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	elseif g_thismodel == "VMeter Meter" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents
		
	end --if
end
	


--Return to basic fader mode.
function remote_release_from_use()
	local retEvents={
		remote.make_midi(ALLNOTESOFF),
		remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
		remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ), 
		remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
		remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
		remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
		remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
		remote.make_midi(ClearLED, { port=1 } ),
		remote.make_midi(ALLNOTESOFF, { port=1 } ),
		remote.make_midi(ALLNOTESOFF, { port=2 } ),
	}
	return retEvents
end
