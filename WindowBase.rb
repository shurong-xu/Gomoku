class WindowBase
  attr_accessor :active

  WHITE_BORDER = Gosu::Color.new(255, 255, 255, 255)
  BLUE_BACKGROUND = Gosu::Color.new(255, 66, 68, 120)

  def initialize(game, x, y, w, h, z, c)
    @game = game
    @x = x
    @y = y
    @w = w
    @h = h
    @z = z
    @c = c
    @active = false
    @font = Gosu::Font.new(25, name:'Microsoft YaHei')
  end

  def draw
    @game.draw_quad(@x+1, @y+1, @c, @x+@w-1, @y+1, @c, @x+@w-1, @y+@h-1, @c, @x+1, @y+@h-1, @c, @z)
    @game.draw_quad(@x, @y, WHITE_BORDER, @x+@w, @y, WHITE_BORDER, @x+@w, @y+@h, WHITE_BORDER, @x, @y+@h, WHITE_BORDER, @z-1)
  end
end