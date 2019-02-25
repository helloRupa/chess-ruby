class PointSystem
  POINTS = {
    pawn: 100,
    knight: 300,
    bishop: 300,
    rook: 500,
    queen: 900,
    king: 9000
  }.freeze

  SPACE_EVAL = {
    pawn: [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [50, 50, 50, 50, 50, 50, 50, 50],
      [10, 10, 20, 30, 30, 20, 10, 10],
      [5, 5, 10, 25, 25, 10, 5, 5],
      [0, 0, 0, 20, 20, 0, 0, 0],
      [5, -5, -10, 0, 0, -10, -5, 5],
      [5, 10, 10, -20, -20, 10, 10, 5],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ],
    knight:  [
      [-50, -40, -30, -30, -30, -30, -40, -50],
      [-40, -20,  0,  0, 0, 0, -20, -40],
      [-30,  0,  10,  15,  15,  10,  0, -30],
      [-30,  5,  15,  20,  20,  15,  5, -30],
      [-30,  0,  15,  20,  20,  15,  0, -30],
      [-30,  5,  10,  15,  15,  10,  5, -30],
      [-40, -20,  0,  5, 5, 0, -20, -40],
      [-50, -40, -30, -30, -30, -30, -40, -50]
    ],
    bishop: [
      [-20, -10, -10, -10, -10, -10, -10, -20],
      [-10,  0,  0,  0, 0, 0, 0, -10],
      [-10,  0,  5,  10,  10,  5,  0, -10],
      [-10,  5,  5,  10,  10,  5,  5, -10],
      [-10,  0,  10, 10, 10, 10, 0, -10],
      [-10,  10, 10, 10, 10, 10, 10, -10],
      [-10,  5,  0, 0, 0,  0, 5, -10],
      [-20, -10, -10, -10, -10, -10, -10, -20]
    ],
    rook: [
      [0,  0,  0, 0, 0, 0,  0,  0],
      [5,  10, 10, 10, 10,  10, 10, 5],
      [-5,  0,  0,  0,  0,  0,  0, -5],
      [-5,  0,  0,  0,  0,  0,  0, -5],
      [-5,  0,  0,  0,  0,  0,  0, -5],
      [-5,  0,  0,  0,  0,  0,  0, -5],
      [-5,  0,  0,  0,  0,  0,  0, -5],
      [0, 0, 0, 5, 5, 0, 0, 0]
    ],
    queen: [
      [-20, -10, -10, -5, -5, -10, -10, -20],
      [-10,  0,  0,  0,  0,  0,  0, -10],
      [-10,  0,  5,  5,  5,  5,  0, -10],
      [-5, 0, 5, 5, 5, 5, 0, -5],
      [0, 0, 5, 5, 5, 5, 0, -5],
      [-10,  5,  5,  5,  5,  5,  0, -10],
      [-10,  0,  5,  0,  0,  0,  0, -10],
      [-20, -10, -10, -5, -5, -10, -10, -20]
    ],
    king: [
      [-30, -40, -40, -50, -50, -40, -40, -30],
      [-30, -40, -40, -50, -50, -40, -40, -30],
      [-30, -40, -40, -50, -50, -40, -40, -30],
      [-30, -40, -40, -50, -50, -40, -40, -30],
      [-20, -30, -30, -40, -40, -30, -30, -20],
      [-10, -20, -20, -20, -20, -20, -20, -10],
      [20,  20,  0,  0, 0, 0, 20, 20],
      [20,  30,  10, 0, 0, 10, 30, 20]
    ]
  }.freeze

  def self.points(piece)
    piece = PointSystem.piece_type(piece)
    POINTS[piece]
  end

  def self.piece_type(piece)
    piece.class.name.downcase.to_sym
  end

  def self.point_mod(piece)
    piece_type = PointSystem.piece_type(piece)
    piece.color == :white ? white_eval(piece_type, piece.pos) : black_eval(piece_type, piece.pos)
  end

  def self.white_eval(piece_type, coords)
    SPACE_EVAL[piece_type][coords[0]][coords[1]]
  end

  def self.black_eval(piece_type, coords)
    SPACE_EVAL[piece_type].reverse[coords[0]][coords[1]]
  end

  def self.calc_piece_val(piece)
    PointSystem.points(piece) + PointSystem.point_mod(piece)
  end

  def self.calc_board_val(max_color, board_rows)
    board_rows.reduce(0) do |points, row|
      points + PointSystem.calc_row_val(max_color, row)
    end
  end

  def self.calc_row_val(max_color, row)
    row.reduce(0) do |total, piece|
      next total if piece.is_a?(NullPiece)
      piece_val = PointSystem.calc_piece_val(piece)
      total + (piece.color == max_color ? piece_val : -piece_val)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require_relative './board.rb'
  require_relative './pieces/knight.rb'
  board = Board.new
  p PointSystem.calc_board_val(:white, board.rows)
  board.move_piece!(:white, [7, 1], [5, 0])
  p PointSystem.calc_board_val(:white, board.rows)
  # b = Knight.new(:white, Board.new, [5, 2])
  # p PointSystem.points(b)
  # p PointSystem.point_mod(b)
  # p PointSystem.calc_piece_val(b)
end
