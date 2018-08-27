class WindowIPInput < WindowBase
  def initialize(game)
    @game = game
    super(@game, 224, 316, 192, 96, 2, BLUE_BACKGROUND)
    @input = Gosu::TextInput.new
  end

  def draw
    super
    @font.draw_rel("请输入主机IP地址，", @x + @w / 2, @y + 16, @z + 3, 0.5, 0.5)
    @font.draw_rel("按回车键确认：", @x + @w / 2, @y + 48, @z + 3, 0.5, 0.5)
    @font.draw_rel(@input.text, @x + @w / 2, @y + 80, @z + 3, 0.5, 0.5)
  end

  def button_down(id)
    if @active
      case id
      when Gosu::KB_BACKSPACE
        @input.text = @input.text[0..-2]
      when Gosu::KB_RETURN
        join
      when Gosu::MS_RIGHT
        @active = false
        @game.scene.window_title.active = true
      when Gosu::KB_ESCAPE
        @active = false
        @game.scene.window_title.active = true
      else
        @input.text += @game.button_id_to_char(id)
      end
    end
  end

  private
    def join
      @game.scene.window_message.active = true
      @active = false
      begin
        host = @input.text.chomp
        client = Client
        client.host = host
        welcome = client.get("hello")
        if client.get("player_count").to_i < 2
          current_player = Player.new(2)
          client.set("player_count", 2)
          @game.scene = SceneMain.new(@game, client, current_player)
        else
          if client.get("game_started_flag").to_i == 1
            @game.scene.window_message.flag = :fail
            @input.text = ""
            @game.scene.window_message.message = "对弈进行中，无法加入主机！！"
          else
            current_player = Player.new(3)
            @game.scene = SceneMain.new(@game, client, current_player)
          end
        end
      rescue Exception => e
        @game.scene.window_message.flag = :fail
        @input.text = ""
        @game.scene.window_message.message = "连接主机失败！请确认主机IP是否正确！"
      end
    end
end