require_relative './player.rb'
require_relative './display.rb'
require_relative './board.rb'

class HumanPlayer < Player
  def initialize(color, display)
    super
  end

  def make_move(_board)
    p get_pos
  end

  private

  def get_pos
    pos = []
    until @display.cursor.selected
      @display.render
      pos = @display.cursor.get_input
    end
    @display.cursor.toggle_selected
    pos
  end
end

if $PROGRAM_NAME == __FILE__
  h = HumanPlayer.new(:white, Display.new(Board.new))
  h.make_move(nil)
end
