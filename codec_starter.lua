--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Codec Starter for Reason
-- by Catblack@gmail.com paypal me a five-ish bucks if you find this useful.
-- The purpose of this file is to get someone started on a lua codec file
-- beyond what is in the Remote Codec Developer manual.
-- 
-- You can delete comments, or uncomment things as you go. This is not meant to be
-- a functioning lua codec, but a good leg up to help get you started. Though I will be using
-- code blocks from the InControlDeluxe.lua that's quoted in the manual.
--
-- I've included some patterns for the remote.trace() function if you are using the Remote SDK.
--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- set some globals
-- It's good practice to declare and initially set every global at the top of the file.
-- We'll declare all of the variables inside the functions as local later.
-- In Lua, any variable *not* declared local is global! Avoid confusion and define them here.
-- Though there are times when you'll need to set them elsewhere.
-- Putting a "g_" in front of them helps. We'll be throwing a few globals around from function to function.
--
--You can set them as 'nil', but I prefer -1 for some of them.
g_current_state=-1
g_last_state_delivered=-1
g_last_noteonoff = -1 --Note detection for turning off released notes
g_current_noteonoff = -1

g_thismodel = "" -- We'll set this in remote_init()


-- These are set in remote_on_auto_input() 
-- (And InControlDeluxe has them defined above the function, but most every 
-- global definition outside a function might as well be up here.)
g_last_input_time=-2000
g_last_input_item=nil

-- These are mentioned in remote_init for the InControlDeluxe example.
-- Also, here's what a comment block looks like in Lua.
--[[
g_lcd_index=0
g_joystick_x_index=0
g_joystick_y_index=0
--]]


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Custom functions up here at the top
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Thanks, Livid Instruments
-- "for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :("
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end

--[[
-- Utility function from InControlDeluxe.lua
local function make_lcd_midi_message(text)
	local event=remote.make_midi("f0 11 22 33 10")
	start=6
	stop=6+string.len(text)-1
	for i=start,stop do
		sourcePos=i-start+1
		event[i] = string.byte(text,sourcePos)
	end
	event[stop+1] = 247         -- hex f7
	return event
end
--]]

-- For showing tables!
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



--[[
function SetLEDArrayAutoOut(val,thisbyte)
    --# assuming 38 length array
    --# need to split array into (6) 7bit chunks
    --# Individual LED control is sent to the aftertouch MIDI command and channels 14, 15 and 16.
    --# Each of the data bytes transmit 7 LED states.
--
--		{name="Button 6"          ,	pattern="xx yy zz", x="SetLEDArrayAutoOut(value,'x')", y="SetLEDArrayAutoOut(value,'y')", z="SetLEDArrayAutoOut(value,'z')"}, --dummy output!


if thisbyte==3 then return 173 end
if thisbyte=="x" then remote.trace(tostring(val)) end
local ledarray = {1,1,1,0,1,0,1,
                  0,1,1,1,0,1,1,
				  1,0,1,1,1,0,1,
				  0,1,1,1,1,1,0,
				  1,0,1,0,0,1,1,
				  1,1,0}
   local bytes = {0,0,0,0,0,0}
   --local bytes = {}

    bytes[1] = ledarray[1] + bit.lshift(ledarray[2],1) + bit.lshift(ledarray[3],2) + bit.lshift(ledarray[4],3) + bit.lshift(ledarray[5],4) + bit.lshift(ledarray[6],5) + bit.lshift(ledarray[7],6)
    bytes[2] = ledarray[8] + bit.lshift(ledarray[9],1) + bit.lshift(ledarray[10],2) + bit.lshift(ledarray[11],3) + bit.lshift(ledarray[12],4) + bit.lshift(ledarray[13],5) + bit.lshift(ledarray[14],6)
    bytes[3] = ledarray[15] + bit.lshift(ledarray[16],1) + bit.lshift(ledarray[17],2) + bit.lshift(ledarray[18],3) + bit.lshift(ledarray[19],4) + bit.lshift(ledarray[20],5) + bit.lshift(ledarray[21],6)
    bytes[4] = ledarray[22] + bit.lshift(ledarray[23],1) + bit.lshift(ledarray[24],2) + bit.lshift(ledarray[25],3) + bit.lshift(ledarray[26],4) + bit.lshift(ledarray[27],5) + bit.lshift(ledarray[28],6)
    bytes[5] = ledarray[29] + bit.lshift(ledarray[30],1) + bit.lshift(ledarray[31],2) + bit.lshift(ledarray[32],3) + bit.lshift(ledarray[33],4) + bit.lshift(ledarray[34],5) + bit.lshift(ledarray[35],6)
    bytes[6] = ledarray[36] + bit.lshift(ledarray[37],1) + bit.lshift(ledarray[38],2)

	remote.trace(table.concat(ledarray))	-- this is fun
	remote.trace(tostring(thisbyte).." "..tostring(bytes[thisbyte]))	-- this is fun
return bytes[thisbyte]
		--return 16383
end

--]]

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

--	remote.trace(table.concat(ledarray))	-- this is fun
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
function GameOfLife(pos)
    led_array = {1,1,1,1,1,1,1,0,0,0,
                 0,0,0,0,0,0,1,1,1,1,
                 0,1,1,0,0,1,1,1,0,0,
                 0,0,0,1,0,0,0,0}
#    led_array = {1,0,1,1,1,1,1,0,0,0,
#                 0,0,0,0,0,0,1,1,1,1,
#                 0,1,1,0,0,1,1,1,0,0,
#                 0,0,0,1,0,0,1,0}
#    led_array = {1,0,0,0,0,0,0,0,0,0,
#                 0,0,0,0,0,0,1,0,1,0,
#                 0,1,0,0,0,1,0,0,0,0,
#                 0,0,0,1,0,0,0,0}
    last_cycle_time = 0
    local i = 0
 --   while True:
 --       while MidiIn.Poll(): # invert LEDs where touched
 --           MidiData = MidiIn.Read(1)
 --           if MidiData[0][0][0] == 0xB0:
 --               if MidiData[0][0][1] == 20:
 --                   pos = MidiData[0][0][2]
 --                   index_pos = int(float(pos) / 127.0 * 37.0)
 
    local index_pos = math.floor((pos / 127.0) * 38.0)
--#                    print "index pos: ", index_pos
	if led_array[index_pos] == 1 then
		led_array[index_pos] = 0
	else
		led_array[index_pos] = 1
	end
	if remote.get_time_ms() - last_cycle_time > 100 then
		last_cycle_time = remote.get_time_ms()
 --           index_array = range(3,36)
	index_array = {}
	for i=3, 36 do
	  index_array[i] = 0
	end
			
	new_array = led_array
	# copy over 4 edge LEDs since they don't have 4 neighbors.
	new_array[1] = led_array[1]
	new_array[2] = led_array[2]
	new_array[37] = led_array[37]
	new_array[38] = led_array[38]
			
--            for i in index_array do
	for i,v in ipairs(index_array) do
 --todo:
	   sum =led_array[i-2]+led_array[i-1]+led_array[i+1]+led_array[i+2]
		if led_array[i] == 1 then -- # live cell
			if sum < 1 then
				new_array[i] = 0 --# under population
			elseif sum < 3 then
				new_array[i] = 1 --# just right
			else 
				new_array[i] = 0 --# overcrowding
			end
		else --# dead cell
			if sum == 2 or sum == 3 then
				new_array[i] = 1
			else
				new_array[i] = 0
			end
		end
	end    
	led_array = new_array            
	return led_array
end 

--]] 


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




--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Remote Functions
-- 
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function remote_init(manufacturer, model)
-- This is the key to piling many maps into one lua file.
-- You still have to define the models in the .luacodec file,
-- but now you can check throughout this lua file
-- because you have it as a global.
-- InControlDeluxe.lua in the SDK uses an assert, but that's wrong!
	g_thismodel = model 

-- It's a good design to initialize these arrays
-- and you can either replace or add to them.
-- (You will see this pattern in other functions.)

	local items={}
	local inputs={}
	local outputs={}


-- The examples below are commented out, but you can find examples and lots of documentation
-- in the Remote Codec Developer manual. 

	if model == "Fader" then
-- item input="value" requires min and max set!
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
		
	elseif model == "Knob" then
-- Some examples from the manual
		items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="Knob",            	input="value",	output="value",	min=0,	max=127},
		}

		remote.define_items(items)
		
		inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="Knob"},

		}
		remote.define_auto_inputs(inputs)


-- You can have multiple outputs with the same name, it will send 2 messages, but you can only set x, y, and z once for each name.
		outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
	--		{name="Knob"          ,	pattern="b0 22 xx", x=20}, -- this would work,
			{name="Knob"          ,	pattern="b0 14 xx", x="value"}, -- but the final x, y, and z def is what gets set. 
		}
		remote.define_auto_outputs(outputs)
		
		

	elseif model =="In Control Deluxe" then

		local items={
			{name="Keyboard", input="keyboard"},
			{name="Pitch Bend", input="value", min=0, max=16383},
			{name="Modulation", input="value", min=0, max=127},
			{name="Joystick X", input="value", output="text", min=0, max=127},
			{name="Joystick Y", input="value", output="text", min=0, max=127},
			{name="Fader 1", input="value", output="value", min=0, max=127},
			{name="Fader 2", input="value", output="value", min=0, max=127},
			{name="Fader 3", input="value", output="value", min=0, max=127},
			{name="Fader 4", input="value", output="value", min=0, max=127},
			{name="Encoder 1", input="delta", output="value", min=0, max=10},
			{name="Encoder 2", input="delta", output="value", min=0, max=10},
			{name="Encoder 3", input="delta", output="value", min=0, max=10},
			{name="Encoder 4", input="delta", output="value", min=0, max=10},
			{name="Button 1", input="button", output="value"},
			{name="Button 2", input="button", output="value"},
			{name="Button 3", input="button", output="value"},
			{name="Button 4", input="button", output="value"},
			{name="LCD", output="text"},
		}
		remote.define_items(items)

--  As you'll see in remote_set_state(), the order of items set above matters, 
--  that's why these globals are set here.
	g_lcd_index=table.getn(items) --last item
	g_joystick_x_index=4
	g_joystick_y_index=5

		local inputs={
			{pattern="b? 40 xx", name="Fader 1"},
			{pattern="b? 41 xx", name="Fader 2"},
			{pattern="b? 42 xx", name="Fader 3"},
			{pattern="b? 43 xx", name="Fader 4"},
			{pattern="e? xx yy", name="Pitch Bend", value="y*128 + x"},
			{pattern="b? 01 xx", name="Modulation"},
			{pattern="9? xx 00", name="Keyboard", value="0", note="x", velocity="64"},
			{pattern="<100x>? yy zz", name="Keyboard"},
			{pattern="b? 50 <???y>x", name="Encoder 1", value="x*(1-2*y)"},
			{pattern="b? 51 <???y>x", name="Encoder 2", value="x*(1-2*y)"},
			{pattern="b? 52 <???y>x", name="Encoder 3", value="x*(1-2*y)"},
			{pattern="b? 53 <???y>x", name="Encoder 4", value="x*(1-2*y)"},
			{pattern="b? 60 ?<???x>", name="Button 1"},
			{pattern="b? 61 ?<???x>", name="Button 2"},
			{pattern="b? 62 ?<???x>", name="Button 3"},
			{pattern="b? 63 ?<???x>", name="Button 4"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
			{name="Fader 1", pattern="b0 40 xx"},
			{name="Fader 2", pattern="b0 41 xx"},
			{name="Fader 3", pattern="b0 42 xx"},
			{name="Fader 4", pattern="b0 43 xx"},
			{name="Encoder 1", pattern="b0 50 0x", x="enabled*(value+1)"},
			{name="Encoder 2", pattern="b0 51 0x", x="enabled*(value+1)"},
			{name="Encoder 3", pattern="b0 52 0x", x="enabled*(value+1)"},
			{name="Encoder 4", pattern="b0 53 0x", x="enabled*(value+1)"},
			{name="Button 1", pattern="b0 60 0<000x>"},
			{name="Button 2", pattern="b0 60 0<000x>"},
			{name="Button 3", pattern="b0 60 0<000x>"},
			{name="Button 4", pattern="b0 60 0<000x>"},
		}
		remote.define_auto_outputs(outputs)
		
-- it's always a good idea to throw a comment after the 'end' of a conditional
	end -- if model
-- remember the number of items set
	g_item_index=table.getn(items) --remote_set_state uses this!
end


function remote_probe()
	return {
	}
end


function remote_on_auto_input(item_index)

	if item_index==1 then

		g_last_input_time=remote.get_time_ms()

		g_last_input_item=item_index

	end

end






function remote_process_midi(event)
	-- local ret = nil
-- Here's an interesting design pattern	
--[[
	ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
-- we check the first remote.match_midi with a loose match, and if there's no midi input, it's going to be nil.
	if(ret~=nil) then 
		tran_btn     = ret.z 
		local notein = ret.y 
		local valin  = ret.x	  -- note on = 1, note off = 0

-- now we do tighter matches for specific buttons
		local pad_1 = remote.match_midi("<100x>? 50 zz",event)	-- Local to this function, may be nil!
		if(pad_1.z > 12) then 
			-- stuff
		end
		shift_btn = remote.match_midi("B? 5B 7F",event)				-- Global for use later, may be nil!

		if(shift_btn) then  -- it either is or is nil!
			-- stuff
		end

	end


--]]	
	
	
	
	if ((g_thismodel == "VMeter Fader Fat Cursor") or (g_thismodel == "VMeter Fader Single Cursor")) then
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
-- 6 button tdb
			elseif (new_notein > 0) and (new_notein < 127) and (g_thismodel == "VMeter Six Button") then -- 6 leds per note \ 0 and 127 blank
				local new_state = math.ceil((new_notein) / 21) -- returns 1 to 6 
-- Sets item on or off
				local msg={ time_stamp = event.time_stamp, item=new_state, value = new_noteonoff, note = new_noteout,velocity = new_notevel }
				remote.handle_input(msg)
				if (g_last_state_delivered~=new_state) then -- draw new note
					g_current_state=new_state
					g_current_noteonoff = new_noteonoff
				elseif g_last_noteonoff~=new_noteonoff then
					g_current_noteonoff = new_noteonoff
				end
				return true -- changed
-- 6 button tdb

			else -- note out of range
				return true -- out of range, should stop input 
			end -- ret 
			--return true 
		end
	end -- g_thismodel check
	return false --false because we detect, not change the input
end


function remote_set_state(changed_items)

		if item_index==g_item_index then
--remote.trace("setstate i :"..tostring(i).." : "..tostring(item_index).." val: "..tostring(remote.get_item_value(item_index)).."last del: ".. tostring(remote.get_item_value(g_last_state_delivered)))		
		
			local new_state=remote.get_item_value(item_index)
			if g_last_state_delivered~=new_state then
				g_current_state=new_state
			end
		end
	end
--[[
-- All this removed because we want immediate output

	local now_ms = remote.get_time_ms()
	if (now_ms-g_last_input_time) < 1000 then
		if remote.is_item_enabled(g_last_input_item) then
			local feedback_text=remote.get_item_name_and_value(g_last_input_item)
			if string.len(feedback_text)>0 then
				g_feedback_enabled=true
				g_led_state=string.format("%-16.16s",feedback_text)
			end
		end

	elseif g_feedback_enabled then
		g_feedback_enabled=false
		if g_is_led_enabled then
			old_text=remote.get_item_text_value(g_item_index)
		else
			old_text=" "
		end
		g_led_state=string.format("%-16.16s",old_text)
	end
--]]
end





function remote_deliver_midi(max_bytes,port)
	local ret_events={}
	local new_state=g_current_state
	local new_noteonoff=g_current_noteonoff
--These are only set in an led array function
	if (g_last_state_delivered~=new_state) or (g_last_noteonoff~=new_noteonoff) then
		local ledoutput = {}
		local faderout = -1
		--g_ledarray=DrawCursor(new_state)
		--g_ledarray=DrawCursor(new_state)
		--ledoutput ={SetLEDArray(g_ledarray)}
--remote.trace(g_thismodel)
--remote.trace(tostring(g_last_noteonoff))		
--remote.trace(tostring(new_noteonoff))		
--remote.trace(tostring(g_last_state_delivered))		
--remote.trace(tostring(new_state))		

-- other led functions go here depending on model.  
		if g_thismodel == "VMeter Fader Single Cursor" then
			ledoutput ={SetLEDArray(DrawCursor(new_state))}
		elseif g_thismodel == "VMeter Fader Fat Cursor" then
			ledoutput ={SetLEDArray(DrawBar(new_state, 5))}
		elseif g_thismodel == "VMeter Notes" then
			ledoutput ={SetLEDArray(DrawNote(new_state))}
		elseif g_thismodel == "VMeter Six Button" then
			ledoutput ={SetLEDArray(DrawButton(new_state))}
		elseif g_thismodel == "VMeter Drums" then
			ledoutput ={SetLEDArray(DrawDrums(new_state))}
		elseif (g_thismodel == "VMeter Fader") or (g_thismodel == "VMeter Modulation Wheel") or (g_thismodel == "VMeter Meter") then
			faderout = new_state
		end -- model setting
--remote.trace(tostring(table.getn(ledoutput) ))		

		if table.getn(ledoutput) == 6 then
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
		g_last_state_delivered = new_state
		g_last_noteonoff = new_noteonoff
	end -- state and note check
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

	elseif g_thismodel == "VMeter Game of Life Demo" then
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
		remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
		remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ), 
		remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
		remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
		remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
		remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
		remote.make_midi(ClearLED, { port=1 } ),
	}
	return retEvents
end
