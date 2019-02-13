require_relative './piece.rb'
require_relative './modules/slideable.rb'

class Rook < Piece
  include Slideable

  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265C"
  end

  protected

  def move_dirs
    :straight
  end
end
