require_relative './piece.rb'
require_relative './modules/slideable.rb'

class Rook < Piece
  include Slideable
  attr_reader :delta_x

  def initialize(color, board, pos)
    super
    @delta_x = castle_delta_x(pos)
  end

  def symbol
    "\u265C"
  end

  def castle_delta_x(pos)
    pos[1] == 0 ? 3 : -2
  end

  protected

  def move_dirs
    :straight
  end
end
