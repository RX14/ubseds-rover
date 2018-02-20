require "./groundstation"

config = Groundstation::Config.new
joystick = Groundstation::Input::Joystick.new(config)

loop do
  p joystick.current_state
  sleep 100.milliseconds
end
