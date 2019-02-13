require_relative './piece.rb'
require_relative './modules/slideable.rb'

class Queen < Piece
  include Slideable

  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265B"
  end

  protected

  def move_dirs
    :both
  end
end