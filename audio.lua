local audio = {}

audio.position = 0

--Time units are in samples.

audio.Track1 = {Source = love.audio.newSource('audio/bg/track1.ogg',"stream"),JumpBackTo = 144879,LoopPosition = 2543784}
audio.Track2 = {Source = love.audio.newSource('audio/bg/restoring_the_light_facing_the_dark_8-bit.ogg',"stream"),JumpBackTo = 144879,LoopPosition = 2544183}




function audio.setTrack (nameOfTrack)
	audio.loadedTrack = nameOfTrack.Source
	audio.loopStart = nameOfTrack.JumpBackTo
	audio.loopEnd = nameOfTrack.LoopPosition
end

function audio.Update()
	audio.position = audio.loadedTrack:tell("samples")
	if audio.position >= audio.loopEnd then
		audio.loadedTrack:seek(audio.position - (audio.loopEnd-audio.loopStart),"samples")
	end
end




return audio