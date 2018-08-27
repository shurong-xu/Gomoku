class WindowSelectable < WindowBase
  def initialize(game, x, y, w, h, z, c, space, index=0)
    super(@game, x, y, w, h, z, c)
    @space = space
    @index = index
    @cursor_x = @x + 5
    @cursor_y = @y + 3
    @cursor_opacity = 200
    @fading_type = :IN
  end

  def draw
    super
    draw_index if @index >= 0
  end

  def draw_index
    blue_border = Gosu::Color.new(@cursor_opacity, 192, 224, 255)
    blue1 = Gosu::Color.new(@cursor_opacity, 66, 68, 120)
    blue2 = Gosu::Color.new(@cursor_opacity, 44, 45, 85)
    @game.draw_quad(@cursor_x, @cursor_y + @space * @index, blue_border, 
                    @cursor_x + @w - 10, @cursor_y + @space * @index, blue_border, 
                    @cursor_x + @w - 10, @cursor_y + @space * (@index + 1) - 6, blue_border, 
                    @cursor_x, @cursor_y + @space * (@index + 1) - 6, blue_border, 
                    @z+1)
    @game.draw_quad(@cursor_x + 1, @cursor_y + @space * @index + 1, blue2, 
                    @cursor_x + @w - 11, @cursor_y + @space * @index + 1, blue2, 
                    @cursor_x + @w - 11, @cursor_y + @space * (@index + 1) - 7, blue2, 
                    @cursor_x + 1, @cursor_y + @space * (@index + 1) - 7, blue2, 
                    @z+2)

    @cursor_opacity += 5 if @fading_type == :IN
    @cursor_opacity -= 5 if @fading_type == :OUT
      
    @fading_type = :IN if @cursor_opacity <= 20
    @fading_type = :OUT if @cursor_opacity >= 160
  end

  def select_index(mouse_x, mouse_y)
    if mouse_x > @x && mouse_x < @x + @w && mouse_y > @y && mouse_y < @y + @h
      @index = ((mouse_y - 1 - @y) / @space).floor
    else
      @index = -1
    end
  end

end