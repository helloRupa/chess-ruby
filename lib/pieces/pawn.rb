require_relative './piece.rb'

class Pawn < Piece
  attr_reader :en_passant
  
  def initialize(color, board, pos)
    super
    @en_passant = false
  end

  def symbol
    "\u265F"
  end

  def moves
    all_moves = []
    all_moves.concat(get_forward_moves)
    all_moves.concat(get_side_attacks)
    all_moves.concat(get_en_passant_attacks)
  end

  def promote?
    at_end_row?
  end

  def set_en_passant
    return unless @first_move
    @en_passant = true if two_step? && pawns_to_left_right?
  end

  def en_passant_false
    @en_passant = false
  end

  def forward_dir
    @color == :black ? 1 : -1
  end

  private

  def get_en_passant_attacks
    y, x = @pos
    all_moves = []

    side_attacks.each do |delta_y, delta_x|
      pos_to_test = [y + delta_y, x + delta_x]
      next unless @board.valid_pos?(pos_to_test)
      all_moves << pos_to_test if enemy_pawn_behind?(pos_to_test)
    end
    all_moves
  end

  def enemy_pawn_behind?(pos)
    pos_to_test = [pos[0] - forward_dir, pos[1]]
    return false unless @board.valid_pos?(pos_to_test)
    piece = @board[pos_to_test]
    opponent?(piece) && piece.is_a?(Pawn) && piece.en_passant
  end

  def two_step?
    @pos[0] == start_row + (forward_dir * 2)
  end

  def pawns_to_left_right?
    left_right_pos.each do |coords|
      next unless @board.valid_pos?(coords)
      piece = @board[coords]
      return true if opponent?(piece) && piece.is_a?(Pawn)
    end
    false
  end

  def left_right_pos
    left = [@pos[0], @pos[1] - 1]
    right = [@pos[0], @pos[1] + 1]
    [left, right]
  end

  def at_end_row?
    @color == :black ? (pos[0] == 7) : (pos[0] == 0)
  end

  def at_start_row?
    pos[0] == start_row
  end

  def start_row
    @color == :black ? 1 : 6
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
      next unless @board.valid_pos?(pos_to_test)
      piece = @board[pos_to_test]
      all_moves << pos_to_test if opponent?(piece)
    end
    all_moves
  end
end
