class Piece
  attr_reader :color, :board, :first_move
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @first_move = true
    @board.add_piece(self, pos)
  end

  def to_s
    symbol.encode('utf-8')
  end

  def empty?
    self.is_a?(NullPiece)
  end

  def valid_moves
    all_moves = moves.reject { |move| move_into_check?(move) }
    all_moves = all_moves.concat(self.castle_moves) if self.is_a?(King)
    all_moves
  end

  def set_first_move
    @first_move = false
  end

  protected

  # Ensure pos is on board & NOT occupied by friend
  def valid?(pos)
    @board.valid_pos?(pos) && (@color != @board[pos].color)
  end

  def opponent?(piece)
    piece.color != @color && !piece.empty?
  end

  private

  def move_into_check?(end_pos)
    start_pos = @pos
    target_piece = @board[end_pos]
    @board.move_piece(self, end_pos)
    check_status = @board.in_check?(@color)
    @board.undo_move_piece(start_pos, end_pos, target_piece)
    check_status
  end
end
