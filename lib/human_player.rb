require_relative './player.rb'

class HumanPlayer < Player
  def initialize(color, display)
    super
  end

  def make_move(_board)
    start_pos = nil
    end_pos = nil
    while end_pos.nil?
      start_pos = get_start_pos
      end_pos = get_end_pos
    end
    @display.board.move_piece!(@color, start_pos, end_pos)
  end

  private

  def get_start_pos
    pos = get_pos until @display.cursor.selected
    pos
  end

  def get_end_pos
    pos = nil
    while @display.cursor.selected
      pos = get_pos
      if pos == 'undo'
        @display.cursor.toggle_selected
        return nil
      end
    end
    pos
  end

  def get_pos
    @display.render
    @display.cursor.get_input
  end
end

if $PROGRAM_NAME == __FILE__
  require_relative './display.rb'
  require_relative './board.rb'
  h = HumanPlayer.new(:white, Display.new(Board.new))
  h.make_move(nil)
end
