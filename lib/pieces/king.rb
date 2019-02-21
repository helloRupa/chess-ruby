require_relative './piece.rb'
require_relative './modules/stepable.rb'

class King < Piece
  include Stepable
  attr_reader :start_pos
  SPACES = {
    left: [1, 2, 3],
    right: [5, 6]
  }.freeze

  def initialize(color, board, pos)
    super
    @start_pos = pos
  end

  def symbol
    "\u265A"
  end

  def two_step?
    (@pos[1] - @start_pos[1]).abs == 2
  end

  def nearest_rook
    7 - @pos[1] < @pos[1] - 0 ? @board[[@pos[0], 7]] : @board[[@pos[0], 0]]
  end

  def castle_moves
    rooks = left_right_rooks
    return [] unless @first_move && !rooks.flatten.empty? && !@board.in_check?(@color)
    left_rook, right_rook = rooks
    castle_pos = []
    castle_pos << [@pos[0], @pos[1] - 2] if side_is_safe?(left_rook)
    castle_pos << [@pos[0], @pos[1] + 2] if side_is_safe?(right_rook)
    castle_pos
  end

  protected

  def move_diffs
    [[-1, -1], [-1, 0], [-1, 1], [1, 1], [1, 0], [1, -1], [0, -1], [0, 1]]
  end

  private

  def side_is_safe?(rook)
    !rook.nil? && space_between?(rook) && !castle_into_check?(rook)
  end

  def left_right_rooks
    [@board[[@start_pos[0], 0]], @board[[@start_pos[0], 7]]].map do |piece|
      piece.is_a?(Rook) && piece.first_move ? piece : nil
    end
  end

  def space_between?(rook)
    spaces = rook.pos[1] == 0 ? SPACES[:left] : SPACES[:right]
    empty_spaces?(spaces) && !under_attack?(spaces)
  end

  def empty_spaces?(spaces)
    spaces.all? { |x_pos| @board[[@pos[0], x_pos]].is_a?(NullPiece) }
  end

  def under_attack?(spaces)
    opponent = @board.get_opponent(@color)
    @board.pieces(opponent).each do |piece|
      spaces.each do |x_pos|
        return true if piece.moves.include?([@pos[0], x_pos])
      end
    end
    false
  end

  def castle_into_check?(rook)
    king_end_pos, rook_start_pos, rook_end_pos = get_positions(rook)
    move_into_castle(rook, king_end_pos, rook_end_pos)
    check_status = @board.in_check?(@color)
    undo_castle(king_end_pos, rook_start_pos, rook_end_pos)
    check_status
  end

  def get_positions(rook)
    steps = rook.pos[1] == 0 ? -2 : 2
    king_end_pos = [@pos[0], @pos[1] + steps]
    rook_start_pos = rook.pos
    rook_end_pos = [rook.pos[0], rook.pos[1] + rook.delta_x]
    [king_end_pos, rook_start_pos, rook_end_pos]
  end

  def move_into_castle(rook, king_end_pos, rook_end_pos)
    @board.move_piece(self, king_end_pos)
    @board.move_piece(rook, rook_end_pos)
  end

  def undo_castle(king_end_pos, rook_start_pos, rook_end_pos)
    @board.undo_move_piece(@start_pos, king_end_pos, @board[@start_pos])
    @board.undo_move_piece(rook_start_pos, rook_end_pos, @board[rook_start_pos])
  end
end
