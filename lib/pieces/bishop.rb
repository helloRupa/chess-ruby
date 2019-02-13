require_relative './piece.rb'
require_relative './modules/slideable.rb'

class Bishop < Piece
  include Slideable

  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265D"
  end

  protected

  def move_dirs
    :diagonal
  end
end
