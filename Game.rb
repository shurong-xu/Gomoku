require 'gosu'
require 'socket'
require 'thread'
require_relative 'Mouse'
require_relative 'WindowBase'
require_relative 'WindowSelectable'
require_relative 'WindowTitle'
require_relative 'WindowIPInput'
require_relative 'WindowMessage'
require_relative 'WindowReady'
require_relative 'WindowChessBoard'
require_relative 'SceneTitle'
require_relative 'SceneMain'
require_relative 'Server'
require_relative 'Client'
require_relative 'Player'

class Game < Gosu::Window
  attr_accessor :scene

  def initialize
    super 640, 480, false
    self.caption = "五子棋联机版"
    @scene = SceneTitle.new(self)
    @mouse = Mouse.new
  end

  def draw
    @mouse.draw(mouse_x, mouse_y)
    @scene.draw
  end

  def update
    @scene.update
    @scene.select_index(mouse_x, mouse_y)
  end

  def button_down(id)
    @scene.button_down(id)
  end

  def close
    @scene.close
    super
  end

end

game = Game.new
game.show