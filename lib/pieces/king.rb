require_relative './piece.rb'
require_relative './modules/stepable.rb'

class King < Piece
  include Stepable

  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265A"
  end

  protected

  def move_diffs
    [[-1, -1], [-1, 0], [-1, 1], [1, 1], [1, 0], [1, -1], [0, -1], [0, 1]]
  end
end
