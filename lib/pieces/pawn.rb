require_relative './piece.rb'

class Pawn < Piece
  def initialize(color, board, pos)
    super
  end

  def symbol
    "\u265F"
  end

  # def move_dirs
  # end

  def moves
    all_moves = []
    all_moves.concat(get_forward_moves)
    all_moves.concat(get_side_attacks)
    all_moves
    # all_moves.select { |pos| @board.valid_pos?(pos) && @board[pos].color != @color }
  end

  private

  def at_start_row?
    @color == :black ? (pos[0] == 1) : (pos[0] == 6)
  end

  def forward_dir
    @color == :black ? 1 : -1
  end

  def forward_steps
    steps = at_start_row? ? [1, 2] : [1]
    steps.map { |num| num * forward_dir }
  end

  def side_attacks
    [[forward_dir, -1], [forward_dir, 1]]
  end

  def get_forward_moves
    y, x = @pos
    all_moves = []

    forward_steps.each do |delta_y|
      pos_to_test = [y + delta_y, x]
      break unless @board.valid_pos?(pos_to_test) && @board[pos_to_test].empty?
      all_moves << pos_to_test
    end
    all_moves
  end

  def get_side_attacks
    y, x = @pos
    all_moves = []

    side_attacks.each do |delta_y, delta_x|
      pos_to_test = [y + delta_y, x + delta_x]
      break unless @board.valid_pos?(pos_to_test)
      piece = @board[pos_to_test]
      all_moves << pos_to_test if opponent?(piece)
    end
    all_moves
  end

  def opponent?(piece)
    piece.color != @color && !piece.empty?
  end
end
