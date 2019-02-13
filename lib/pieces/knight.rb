require_relative './piece.rb'
require_relative './modules/stepable.rb'

class Knight < Piece
  include Stepable

  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265E"
  end

  protected

  def move_diffs
    [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
  end
end
