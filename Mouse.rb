class Mouse
  def initialize
    @image = Gosu::Image.new('Graphics\mouse.png')
  end

  def draw(x, y)
    @image.draw(x, y, 99)
  end
end