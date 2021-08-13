local audio = {}

audio.position = 0

--Time units are in samples.

audio.Track1 = {Source = love.audio.newSource('audio/bg/track1.ogg',"stream"),JumpBackTo = 144879,LoopPosition = 2543784}
audio.Track2 = {Source = love.audio.newSource('audio/bg/track2.ogg',"stream"),JumpBackTo = 3665,LoopPosition = 826961}
audio.Track3 = {Source = love.audio.newSource('audio/bg/track3.ogg',"stream"),JumpBackTo = 3665,LoopPosition = 1101873}
audio.Track0 = {Source = love.audio.newSource('audio/bg/restoring_the_light_facing_the_dark_8-bit.ogg',"stream"),JumpBackTo = 12405,LoopPosition = 3188075}


soundExplosion = love.audio.newSource('audio/sfx/sfx1.wav',"static")
soundPoliceBullet = love.audio.newSource('audio/sfx/sfx2.wav',"static")
soundPowerup = love.audio.newSource('audio/sfx/sfx3.wav',"static")
soundHurt = love.audio.newSource('audio/sfx/sfx4.wav',"static")
soundTransition = love.audio.newSource('audio/sfx/sfx5.wav',"static")
soundThruster = {Source = love.audio.newSource('audio/sfx/sfx6.wav',"static"),JumpBackTo = 9455,LoopPosition = 51590}



function audio.setTrack (nameOfTrack)
	audio.loadedTrack = nameOfTrack.Source
	audio.loopStart = nameOfTrack.JumpBackTo
	audio.loopEnd = nameOfTrack.LoopPosition
end


  

function audio.Update()
  
  audio.loadedTrack:setVolume(musicVolume)
  audio.position = audio.loadedTrack:tell("samples")
	if audio.position >= audio.loopEnd then
		audio.loadedTrack:seek(audio.position - (audio.loopEnd-audio.loopStart),"samples")
	end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w")  then
    if Gamestate.current()==game then
      audio.thrusterPosition = soundThruster.Source:tell("samples")
      if audio.thrusterPosition >= soundThruster.LoopPosition then
        soundThruster.Source:seek(audio.thrusterPosition - (soundThruster.LoopPosition-soundThruster.JumpBackTo),"samples")
      end
    end
  end  
end

function love.keyreleased(key)
  if (key == "up" or key == "w") and Gamestate.current()==game then
    soundThruster.Source:seek(soundThruster.LoopPosition)
  end
end

return audio