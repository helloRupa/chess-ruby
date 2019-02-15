class Piece
  attr_reader :color, :board, :pos

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

  def pos=(val)
    @pos = val
  end

  private

  def move_into_check?(end_pos)
  end
end
