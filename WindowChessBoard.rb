class WindowChessBoard
  BLACK = Gosu::Color.new(255, 0, 0, 0)
  WHITE = Gosu::Color.new(255, 255, 255, 255)

  attr_accessor :active, :chessboard_arr

  def initialize(game, client, current_player)
    @game = game
    @client = client
    @current_player = current_player
    @chessboard = Gosu::Image.new('Graphics\chessboard.png')
    @chesspiece = Gosu::Image.new('Graphics\chesspiece.bmp')
    @chessboard_arr = Array.new(18){Array.new(18){0}}
    @active_player = 1
    @active = false
  end

  def draw
    @chessboard.draw(140, 60, 1)
    for chessboard_y in 0..@chessboard_arr.length - 1
      for chessboard_x in 0..@chessboard_arr[0].length - 1
        chesspiece = @chessboard_arr[chessboard_y][chessboard_x]
        @chesspiece.draw(chessboard_x * 20 + 140, chessboard_y * 20 + 60, 2, 1, 1, BLACK) if chesspiece == 1
        @chesspiece.draw(chessboard_x * 20 + 140, chessboard_y * 20 + 60, 2, 1, 1, WHITE) if chesspiece == 2
      end
    end
  end

  def update
    if Gosu.milliseconds / 175 % 10 == 0
      if !game_over?
        string = @client.get("chessboard")
        @chessboard_arr = exchange_to_arr(string)
        # datas = exchange(string)
        # @chessboard_arr[datas[1].to_i][datas[0].to_i] = datas[2].to_i
        @active_player = @client.get("active_player").to_i
      else
        game_over_execute
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      if @chessboard_arr[@chessboard_y][@chessboard_x] == 0 && @active_player == @current_player.id && @chessboard_x >= 0 && @chessboard_y >= 0
        @chessboard_arr[@chessboard_y][@chessboard_x] = @current_player.id
        @client.set("chessboard", @chessboard_arr)
        # @client.set("chessboard", [@chessboard_x, @chessboard_y, @current_player.id])
        @active_player += 1
        @active_player = 1 if @active_player > 2
        @client.set("active_player", @active_player)
      end
    end
  end

  def select_index(mouse_x, mouse_y)
    if mouse_x > 140 && mouse_x < 500 && mouse_y > 60 && mouse_y < 420
      @chessboard_y = ((mouse_y - 60) / 20).floor
      @chessboard_x = ((mouse_x - 140) / 20).floor
    else
      @chessboard_x = @chessboard_y = -1
    end
  end

  private
    def exchange_to_arr(string)
      arr = []
      arr_inside = []
      arr_outside = []
      i = 0
      str = string.delete(" ").delete("[").delete("]").delete(",")
      str.each_char do |char|
          char = char.to_i
          arr << char 
      end
      while !arr.empty?
          arr_inside = arr.slice!(0..17)
          arr_outside << arr_inside
      end
      return arr_outside
    end

    # def exchange(string)
    #   str = string.delete(" ").delete("[").delete("]")
    #   datas = str.split(",")
    #   return datas
    # end

    def five_in_line?(chessboard_x, chessboard_y)
      if chessboard_x + 4 > 17
        return false
      else
        return @chessboard_arr[chessboard_y][chessboard_x] != 0 &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y][chessboard_x + 1] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y][chessboard_x + 2] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y][chessboard_x + 3] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y][chessboard_x + 4] 
      end
    end

    def five_in_column?(chessboard_x, chessboard_y)
      if chessboard_y + 4 > 17
        return false
      else
        return @chessboard_arr[chessboard_y][chessboard_x] != 0 &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 1][chessboard_x] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 2][chessboard_x] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 3][chessboard_x] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 4][chessboard_x] 
      end
    end

    def five_in_right_oblique?(chessboard_x, chessboard_y)
      if chessboard_x + 4 > 17 || chessboard_y + 4 > 17
        return false
      else
        return @chessboard_arr[chessboard_y][chessboard_x] != 0 &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 1][chessboard_x + 1] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 2][chessboard_x + 2] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 3][chessboard_x + 3] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 4][chessboard_x + 4] 
      end
    end

    def five_in_left_oblique?(chessboard_x, chessboard_y)
      if chessboard_x - 4 < 0 || chessboard_y + 4 > 17
        return false
      else
        return @chessboard_arr[chessboard_y][chessboard_x] != 0 &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 1][chessboard_x - 1] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 2][chessboard_x - 2] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 3][chessboard_x - 3] &&
              @chessboard_arr[chessboard_y][chessboard_x] == @chessboard_arr[chessboard_y + 4][chessboard_x - 4] 
      end
    end

    def game_over?
      for chessboard_y in 0..17
        for chessboard_x in 0..17
          return true if five_in_line?(chessboard_x, chessboard_y) || five_in_column?(chessboard_x, chessboard_y) || five_in_right_oblique?(chessboard_x, chessboard_y) || five_in_left_oblique?(chessboard_x, chessboard_y)
        end
      end
      return false
    end

    def game_over_execute
      @acitve = false
      if !@game.scene.window_ready.active
        @client.set("ready_player_count", 0)
        @client.set("game_started_flag", 0)
        @game.scene.window_ready.ready_player_count = 0
        @game.scene.window_ready.commands = (@current_player.id <= 2 ? ["准备"] : ["等待开始"])
        @game.scene.window_ready.ready = false
        active_player_id = @client.get("active_player").to_i
        @game.scene.window_message.message = (active_player_id == @current_player.id ? "失败！" : "胜利！")
        @game.scene.window_message.active = true if @current_player.id <= 2
        @game.scene.window_ready.active = true
        if @current_player.id == 1
          @current_player.id = 2
        elsif @current_player.id == 2
          @current_player.id = 1
        end
        @game.scene.window_self.message = "己方：" + (@current_player.id == 1 ? "黑" : "白")
        @game.scene.window_self.active = false
        @game.scene.window_battler.message = "对方：" + (@current_player.id == 1 ? "白" : "黑")
        @game.scene.window_battler.active = false
        @game.scene.window_ob.active = false
      end
    end

end