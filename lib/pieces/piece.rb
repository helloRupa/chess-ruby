class Piece
  attr_reader :color, :board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @board.add_piece(self, pos)
  end

  def to_s
    symbol.encode('utf-8')
  end

  def empty?
    self.is_a?(NullPiece)
  end

  # def valid_moves
  #   moves
  # end

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
  end
end
