class WindowMessage < WindowBase
  attr_accessor :y, :message, :flag

  def initialize(game, h=96)
    @game = game
    @message = ""
    super(@game, 224, 316, @message.length * 25 + 10, h, 3, BLUE_BACKGROUND)
  end

  def draw
    super
    @font.draw_rel(@message, @x + @w / 2, @y + @h / 2, @z + 3, 0.5, 0.5)
  end

  def update
    @w = @message.length * 25
    @w += 10
    @x = (@game.width - @w) / 2
  end

  def button_down(id)
    if @flag == :fail
      case id
      when Gosu::MS_LEFT
        @active = false
        @game.scene.window_ip_input.active = true
      when Gosu::MS_RIGHT
        @active = false
        @game.scene.window_ip_input.active = true
      when Gosu::KB_RETURN
        @active = false
        @game.scene.window_ip_input.active = true
      end
    end
  end

end
  