class WindowReady < WindowSelectable
  attr_accessor :commands, :ready, :ready_player_count

  def initialize(game, client, player)
    @game = game
    @client = client
    @current_player = player
    @commands = (@current_player.id <= 2 ? ["准备"] : ["等待开始"])
    @ready_player_count = 0
    h = @commands.length * 32
    super(@game, 224, 316, 192, h, 3, BLUE_BACKGROUND, 32)
    @active = true
    @ready = false
  end

  def draw
    super
    for i in 0..@commands.length - 1
      cmd = @commands[i]
      @font.draw_rel(cmd, @x + @w / 2, @y + @space * (i + 0.5), @z + 3, 0.5, 0.5)
    end
  end

  def update
    @ready_player_count = @client.get("ready_player_count").to_i if Gosu.milliseconds / 175 % 4 == 0
    if @ready_player_count == 2
      game_start_execute
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      case @index
      when 0
        @ready = !@ready
        if @ready
          @commands = (@current_player.id <= 2 ? ["取消准备"] : ["等待开始"])
          @ready_player_count += 1 if @current_player.id <= 2
          @client.set("ready_player_count", @ready_player_count)
        else
          @commands = (@current_player.id <= 2 ? ["准备"] : ["等待开始"])
          @ready_player_count -= 1 if @current_player.id <= 2
          @client.set("ready_player_count", @ready_player_count)
        end
      end
    end
  end
  
  def game_start_execute
    @active = false
    @client.set("game_started_flag", 1)
    @client.set("active_player", 1)
    chessboard_arr = Array.new(18){Array.new(18){0}}
    @client.set("chessboard", chessboard_arr)
    @game.scene.window_chess_board.chessboard_arr = chessboard_arr
    @game.scene.window_chess_board.active = true
    @game.scene.window_message.active = false
    if @current_player.id <= 2
      @game.scene.window_self.active = true
      @game.scene.window_battler.active = true
    else
      @game.scene.window_ob.active = true
    end
  end
end