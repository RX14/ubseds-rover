require "sdl"

SDL.set_hint("SDL_NO_SIGNAL_HANDLERS", "1")
SDL.init(SDL::Init::JOYSTICK)
at_exit { SDL.quit }

abstract class Groundstation::Input
  record InputState,
    # Speed forwards, between 1.0 and -1.0 (negative is backwards)
    forward : Float64,
    # Steering left, between 1.0 and -1.0 (negative is right)
    left : Float64,

    scoop_deploy : Bool,
    scoop_retract : Bool,

    scoop_rotate_forwards : Bool,
    scoop_rotate_backwards : Bool,

    camera_deploy : Bool,
    camera_retract : Bool

  abstract def current_state : InputState

  class Joystick < Input
    def initialize(@config : Groundstation::Config)
      @joystick = LibSDL.joystick_open(self.config.index)
      raise SDL::Error.new("SDL_JoystickOpen") unless @joystick

      puts <<-MESSAGE
        Opened Joystick #{self.config.index}
        Name:              #{String.new(LibSDL.joystick_name(@joystick))}
        Number of Axes:    #{LibSDL.joystick_num_axes(@joystick)}
        Number of Buttons: #{LibSDL.joystick_num_buttons(@joystick)}
        Number of Balls:   #{LibSDL.joystick_num_balls(@joystick)}
        MESSAGE
    end

    def config
      @config.joystick
    end

    def current_state : InputState
      LibSDL.joystick_update

      forward = get_axis(config.forward_axis)
      forward *= -1 if config.forward_axis_reverse

      left = get_axis(config.left_axis)
      left *= -1 if config.left_axis_reverse

      InputState.new(
        forward: forward,
        left: left,

        scoop_deploy: button_pressed?(config.scoop_deploy_button),
        scoop_retract: button_pressed?(config.scoop_retract_button),

        scoop_rotate_forwards: button_pressed?(config.scoop_rotate_forwards_button),
        scoop_rotate_backwards: button_pressed?(config.scoop_rotate_backwards_button),

        camera_deploy: button_pressed?(config.camera_deploy_button),
        camera_retract: button_pressed?(config.camera_retract_button),
      )
    end

    private def get_axis(axis_index)
      axis = LibSDL.joystick_get_axis(@joystick, axis_index)
      if axis > 0
        axis.to_f / Int16::MAX
      else
        -(axis.to_f / Int16::MIN)
      end
    end

    private def button_pressed?(button_index)
      LibSDL.joystick_get_button(@joystick, button_index) == 1
    end
  end
end