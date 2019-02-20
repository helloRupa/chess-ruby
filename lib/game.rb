require_relative './board.rb'
require_relative './display.rb'
require_relative './human_player.rb'
require_relative './computer_player.rb'

class Game
  def self.run_game(player_arr)
    new(player_arr)
  end

  private_class_method :new

  def initialize(player_arr)
    @board = Board.new
    @display = Display.new(@board)
    @players = create_players(player_arr)
    @current_player = @players[:white]
    welcome_msg
    play
  end

  def play
    loop do
      show_turn
      break if won? || draw?
      swap_player
    end
    game_over_msg
  end

  private

  def show_turn
    begin
      @display.render(@current_player.color)
      @current_player.make_move(@board)
    rescue ArgumentError => error
      show_error(error)
      retry
    end
    @display.render(@current_player.color)
  end

  def show_error(error)
    puts "#{error} Please start your turn again."
    sleep(2)
  end

  def won?
    color = @current_player.color
    opponent = @board.get_opponent(color)
    @board.checkmate?(opponent)
  end

  def draw?
    @board.draw?
  end

  def welcome_msg
    system('clear')
    puts 'Welcome to Chess!'
    puts
    puts 'Use the arrow keys to move around the board.'
    puts 'Press Enter to select a piece, then select a space to move to and press Enter again.'
    puts 'To undo a selection, press Escape before choosing a space to move to.'
    sleep(5)
  end

  def game_over_msg
    draw? ? draw_msg : win_msg
  end

  def draw_msg
    puts 'No winner today! Game is tied.'
  end

  def win_msg
    puts
    puts "Congratulations #{@current_player.color}! You won!"
  end

  def swap_player
    @current_player = @current_player == @players[:white] ? @players[:black] : @players[:white]
  end

  def create_players(player_arr)
    p_white = choose_player_type(player_arr[0], :white)
    p_black = choose_player_type(player_arr[1], :black)
    { black: p_black, white: p_white }
  end

  def choose_player_type(str, color)
    str.downcase == 'human' ? HumanPlayer.new(color, @display) : ComputerPlayer.new(color, @display)
  end
end

if $PROGRAM_NAME == __FILE__
  # game = Game.new(['human', 'human'])
  Game.run_game(['human', 'human'])
end
