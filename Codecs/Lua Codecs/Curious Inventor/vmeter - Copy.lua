
function remote_init(manufacturer, model)
--[[
	setupStr="B0 77 7C"
	    if model == "VMeter Fader" then
		setupStr="1"
	elseif model == "VMeter Notes" then
		setupStr="2"
	elseif model == "VMeter Pitch Wheel" then
		setupStr="3"
	elseif model == "VMeter Crossfader" then
		setupStr="4"
	elseif model == "VMeter Button" then
		setupStr="5"
	elseif model == "VMeter Delta<" then
		setupStr="6"
	elseif model == "VMeter Meter" then
		setupStr="7"
	
	end
--]]






	local items=
	{
--		{name="Keyboard",          	input="keyboard"},
--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
		{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
	}
	remote.define_items(items)
	
	local inputs={

	
--		{pattern="<100x>0 yy zz",	name="Keyboard"},
--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
--		{pattern="b0 02 xx",     	name="Breath"},
--		{pattern="b0 0B xx",     	name="Expression Pedal"},
--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
		{pattern="b0 14 xx",     	name="TouchPos"},

	}
	remote.define_auto_inputs(inputs)

	local outputs={
--		{name="CC 00"           ,	pattern="b0 00 xx"},
--		{name="Modulation Wheel",	pattern="b0 01 xx"},
--		{name="Breath"          ,	pattern="b0 02 xx"},
--		{name="Expression Pedal",	pattern="b0 0B xx"},
--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
--		{name="CC 127"          ,	pattern="b0 7F xx"},
		{name="TouchPos"          ,	pattern="b0 14 xx"},
	}
	remote.define_auto_outputs(outputs)
end





function remote_probe()
	return {
	}
end






function remote_prepare_for_use()
	local retEvents={
		remote.make_midi("B0 77 7D", { port=1 } ), --Upside Down mode
--		remote.make_midi("f0 66 66 66 14 0a 02 f7", { port=2 } ),
	}
	return retEvents
	
end
	



function remote_release_from_use()


	local retEvents={

--		remote.make_midi("f0 66 66 66 14 0a 02 f7", { port=1 } ),
--		remote.make_midi("f0 66 66 66 14 0a 02 f7", { port=2 } ),
	}
	return retEvents


end



function remote_deliver_midi(max_bytes,port)
	if(port==1) then
		local retEvents={
--			rtevent = remote.make_midi("b0 14 "..c_two)
		}
		return retEvents
	
	
	
	end --end port==1
--[[
	
	if(port==2) then
		local retLevels=remote.make_midi("b0 14 yy", { x=mode, y=value, port=2 })
		return retLevels
	end
--]]	

end
