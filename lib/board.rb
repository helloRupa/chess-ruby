require_relative './all_pieces.rb'

class Board
  attr_reader :rows, :captured

  def initialize
    @rows = fill_rows_with_nullpieces
    populate_board
    @king_black = self[[0, 4]]
    @king_white = self[[7, 4]]
    @captured = { white: [], black: [] }
  end

  def [](pos)
    @rows[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @rows[pos[0]][pos[1]] = val
  end

  def move_piece!(color, start_pos, end_pos)
    piece = self[start_pos]
    error_check(color, piece, end_pos)
    capture(self[end_pos])
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = NullPiece.instance
    promote_pawn(piece)
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
    pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def in_check?(color)
    king = find_king(color)
    opponent = get_opponent(color)
    pieces(opponent).any? { |piece| piece.moves.include?(king.pos) }
  end

  def draw?
    @rows.reduce(0) do |count, row|
      count + row.reject(&:empty?).length
    end == 2
  end

  def find_king(color)
    color == :black ? @king_black : @king_white
  end

  def pieces(color)
    pieces = []
    @rows.each do |row|
      pieces.concat(row.select { |piece| piece.color == color })
    end
    pieces
  end

  def dup
  end

  def get_opponent(color)
    color == :black ? :white : :black
  end

  def move_piece(start_pos, end_pos)
    piece = self[start_pos]
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = NullPiece.instance
  end

  def undo_move_piece(start_pos, end_pos, target_piece)
    moved_piece = self[end_pos]
    moved_piece.pos = start_pos
    self[start_pos] = moved_piece
    self[end_pos] = target_piece
  end

  private

  def promote_pawn(piece)
    return unless piece.promote?
    pos = piece.pos
    color = piece.color
    Queen.new(color, self, pos)
  end

  def error_check(color, piece, end_pos)
    raise(ArgumentError, 'That is an empty space: Please select a piece') if piece.empty?
    raise(ArgumentError, 'That is not your piece') if color != piece.color
    raise(ArgumentError, 'You cannot move there!') unless piece.valid_moves.include?(end_pos)
  end

  def capture(opponent)
    return if opponent.color == :none
    @captured[opponent.color] << opponent
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
  # b.move_piece!(:white, [6, 5], [5, 5])
  # test_print(b)
  # b.move_piece!(:black, [1, 4], [3, 4])
  # test_print(b)
  # b.move_piece!(:white, [6, 6], [4, 6])
  # test_print(b)
  # b.move_piece!(:black, [0, 3], [4, 7])
  # test_print(b)
  # p b.checkmate?(:black)
  # p b.checkmate?(:white)
  # End Fool's mate

  b.move_piece!(:white, [6, 0], [4, 0])
  test_print(b)
  b.move_piece!(:black, [1, 1], [3, 1])
  test_print(b)
  
  p b[[4, 0]].valid_moves
end
