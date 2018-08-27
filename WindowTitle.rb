class WindowTitle < WindowSelectable
  def initialize(game)
    @game = game
    @commands = ["创建主机", "加入游戏", "退出"]
    space = 32
    h = @commands.length * space
    super(@game, 224, 316, 192, h, 2, BLUE_BACKGROUND, space)
    @active = true
  end

  def draw
    super
    for i in 0..@commands.length - 1
      cmd = @commands[i]
      @font.draw_rel(cmd, @x + @w / 2, @y + @space * (i + 0.5), @z + 3, 0.5, 0.5)
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      case @index
      when 0
        create
      when 1
        @game.scene.window_ip_input.active = true
        @active = false
      when 2
        @game.close
      end
    end
  end

  def update
    player_count = @client.get("player_count").to_i if @client
    @game.scene = SceneMain.new(@game, @client, @current_player) if player_count == 2
  end

  private
    def create
      @active = false
      Thread.new do
        server = Server.new
        server.start
      end
      @client = Client
      host = local_ip
      @client.host = host
      @game.scene.window_message.message = "主机创建成功！主机IP: #{host}"
      @game.scene.window_message.active = true
      @current_player = Player.new(1)
      @client.set("player_count", 1)
    end

    def local_ip 
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  
      UDPSocket.open do |s|
        s.connect '192.168.1.1', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end
end