class SceneTitle
  attr_accessor :window_title, :window_ip_input, :window_message

  def initialize(game)
    @game = game
    @background = Gosu::Image.new('Graphics\background.png')
    @window_title = WindowTitle.new(@game)
    @window_ip_input = WindowIPInput.new(@game)
    @window_message = WindowMessage.new(@game)
  end

  def draw
    @background.draw(0, 0, 1)
    @window_title.draw if @window_title.active
    @window_ip_input.draw if @window_ip_input.active
    @window_message.draw if @window_message.active
  end

  def update
    @window_title.update
    @window_message.update
  end

  def button_down(id)
    if @window_title.active
      @window_title.button_down(id)
    elsif @window_ip_input.active
      @window_ip_input.button_down(id)
    elsif @window_message.active
      @window_message.button_down(id)
    end
  end

  def select_index(mouse_x, mouse_y)
    @window_title.select_index(mouse_x, mouse_y) if @window_title.active
  end

  def close
  end
end