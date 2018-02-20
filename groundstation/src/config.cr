class Groundstation::Config
  getter joystick = Joystick.new

  class Joystick
    getter index = 0

    getter forward_axis = 1
    getter forward_axis_reverse = true

    getter left_axis = 0
    getter left_axis_reverse = true

    getter scoop_deploy_button = 0
    getter scoop_retract_button = 0

    getter scoop_rotate_forwards_button = 0
    getter scoop_rotate_backwards_button = 0

    getter camera_deploy_button = 0
    getter camera_retract_button = 0
  end
end
