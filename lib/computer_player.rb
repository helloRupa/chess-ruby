require_relative './player.rb'

class ComputerPlayer < Player
  def initialize(color, display)
    super
  end

  def make_move(board)
    piece = choose_random_piece(board)
    move_cursor(piece.pos)
    sleep(1)
    end_pos = choose_end_pos(piece)
    move_cursor(end_pos)
    board.move_piece!(@color, piece.pos, end_pos)
  end

  private

  def choose_random_piece(board)
    pieces = board.pieces(@color).reject { |piece| piece.valid_moves.empty? }
    pieces.sample
  end

  def choose_end_pos(piece)
    piece.valid_moves.sample
  end

  def move_cursor(end_pos)
    @display.cursor.cursor_pos = end_pos
    @display.render(@color)
  end
end
