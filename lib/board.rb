require_relative './all_pieces.rb'

class Board
  attr_reader :rows

  def initialize
    @rows = fill_rows_with_nullpieces
    populate_board
    @king_black = self[[0, 4]]
    @king_white = self[[7, 4]]
  end

  def [](pos)
    @rows[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @rows[pos[0]][pos[1]] = val
  end

  def move_piece!(color, start_pos, end_pos)
    piece = self[start_pos]
    raise(ArgumentError, 'That is an empty space: Please select a piece') if piece.empty?
    raise(ArgumentError, 'That is not your piece') if color != piece.color
    raise(ArgumentError, 'You cannot move there!') unless piece.moves.include?(end_pos)
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = NullPiece.instance
  end

  def valid_pos?(pos)
    y, x = pos
    y.between?(0, 7) && x.between?(0, 7)
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  # Is the color being tested in checkmate
  def checkmate?(color)
    return false unless in_check?(color)

    pieces(color).each do |piece|
      return false unless test_moves_for_check(piece, color, piece.pos)
    end
    true
  end

  def in_check?(color)
    king = find_king(color)
    opponent = get_opponent(color)
    pieces(opponent).each do |piece|
      return true if piece.moves.include?(king.pos)
    end
    false
  end

  def find_king(color)
    color == :black ? @king_black : @king_white
  end

  def pieces(color)
    pieces = []
    @rows.each do |row|
      row.each { |piece| pieces << piece if piece.color == color }
    end
    pieces
  end

  def dup
  end

  private

  def get_opponent(color)
    color == :black ? :white : :black
  end

  def fill_rows_with_nullpieces
    Array.new(8) { Array.new(8, NullPiece.instance) }
  end

  def fill_back_row(color)
    row = color == :black ? 0 : 7
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    pieces.each_with_index { |piece, col| piece.new(color, self, [row, col]) }
  end

  def fill_pawn_row(color)
    row = color == :black ? 1 : 6
    (0..7).each { |col| Pawn.new(color, self, [row, col]) }
  end

  def populate_board
    [:black, :white].each do |color|
      fill_back_row(color)
      fill_pawn_row(color)
    end
  end

  def test_moves_for_check(piece, color, start_pos)
    piece.moves.each do |end_pos|
      target_piece = self[end_pos]
      move_piece!(color, start_pos, end_pos)
      check_status = in_check?(color)
      undo_move_piece!(start_pos, end_pos, target_piece)
      return false unless check_status
    end
    true
  end

  def undo_move_piece!(start_pos, end_pos, target_piece)
    moved_piece = self[end_pos]
    moved_piece.pos = start_pos
    self[start_pos] = moved_piece
    self[end_pos] = target_piece
  end
end

if $PROGRAM_NAME == __FILE__
  b = Board.new
  def test_print(b)
    b.rows.each do |row|
      row.each do |piece|
        print piece.to_s
        print ' '
      end
      puts
    end
  end
  # Test for Fool's mate
  b.move_piece!(:white, [6, 5], [5, 5])
  test_print(b)
  b.move_piece!(:black, [1, 4], [3, 4])
  test_print(b)
  b.move_piece!(:white, [6, 6], [4, 6])
  test_print(b)
  b.move_piece!(:black, [0, 3], [4, 7])
  test_print(b)
  p b.checkmate?(:black)
  p b.checkmate?(:white)
  # p b.move_out_of_checkmate?(:black)
  # b.move_piece!(:white, [1, 3], [0, 4])
  # test_print(b)
  # p b.in_check?(:black)
  # p b[[5, 2]].moves
end
