class SceneMain
  attr_accessor :window_chess_board, :window_message, :window_ready, :window_self, :window_battler, :window_ob, :window_surrender

  def initialize(game, client, player)
    @game = game
    @client = client
    @current_player = player
    @window_ready = WindowReady.new(@game, @client, @current_player)
    @window_message = WindowMessage.new(@game)
    @window_message.y = 194
    @window_self = WindowMessage.new(@game, 32)
    @window_self.y = 438
    @window_self.message = "己方：" + (@current_player.id == 1 ? "黑" : "白")
    @window_battler = WindowMessage.new(@game, 32)
    @window_battler.y = 10
    @window_battler.message = "对方：" + (@current_player.id == 1 ? "白" : "黑")
    @window_ob = WindowMessage.new(@game, 32)
    @window_ob.y = 10
    @window_ob.message = "您正在观看对弈"
    @window_chess_board = WindowChessBoard.new(@game, @client, @current_player)
  end

  def draw
    @window_ready.draw if @window_ready.active
    @window_message.draw if @window_message.active
    # @window_self.draw if @window_self.active
    # @window_battler.draw if @window_battler.active
    # @window_ob.draw if @window_ob.active
    @window_chess_board.draw
  end

  def update
    begin
      player_count = @client.get("player_count").to_i if Gosu.milliseconds / 175 % 4 == 0
      if player_count == 1
        @game.scene = SceneTitle.new(@game)
      end
      @window_ready.update if @window_ready.active
      @window_message.update if @window_message.active
      @window_self.update if @window_self.active
      @window_battler.update if  @window_battler.active
      @window_ob.update if @window_ob.active
      @window_chess_board.update if @window_chess_board.active
    rescue Exception => e
      puts e.message
      @game.scene = SceneTitle.new(@game)
    end
  end

  def button_down(id)
    if @window_ready.active
      @window_ready.button_down(id)
    elsif @window_chess_board.active
      @window_chess_board.button_down(id)
    end
  end

  def select_index(mouse_x, mouse_y)
    @window_ready.select_index(mouse_x, mouse_y) if @window_ready.active
    @window_chess_board.select_index(mouse_x, mouse_y) if @window_chess_board.active
  end

  def close 
    @client.set("player_count", 1) if @current_player.id == 2
  end
end