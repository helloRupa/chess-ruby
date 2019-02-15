require_relative './board.rb'
require_relative './display.rb'
require_relative './human_player.rb'

class Game
  def initialize(player_arr)
    @board = Board.new
    @display = Display.new(@board)
    @players = create_players(player_arr)
    @current_player = @players[:white]
  end

  private
  
  def create_players(player_arr)
    p_black = choose_player_type(player_arr[0], :black)
    p_white = choose_player_type(player_arr[1], :white)
    { black: p_black, white: p_white }
  end

  def choose_player_type(str, color)
    str == 'human' ? Player.new(color, @display) : ComputerPlayer.new(color, @display)
  end
end

if $PROGRAM_NAME == __FILE__
end
