require_relative './player.rb'
require_relative './point_system.rb'

class ComputerPlayer < Player
  INF = Float::INFINITY
  DEPTH = 3

  def initialize(color, display)
    super
    @best_piece = nil
    @best_move = nil
    @opponent_color = color == :black ? :white : :black
  end

  def make_move(board)
    minimax_ab(board)
    choose_best_move(board) if @best_piece.nil?
    move_cursor(@best_piece.pos)
    sleep(1)
    move_cursor(@best_move)
    board.move_piece!(@color, @best_piece.pos, @best_move)
    reset_best_piece_move
  end

  private

  def reset_best_piece_move
    @best_piece = nil
    @best_move = nil
  end

  def choose_random_move(board)
    pieces = board.pieces(@color).reject { |piece| piece.valid_moves.empty? }
    @best_piece = pieces.sample
    choose_end_pos
  end

  def choose_end_pos
    @best_move = @best_piece.valid_moves.sample
  end

  def choose_best_move(board)
    highest_val = PointSystem.calc_board_val(@color, board.rows)

    board.pieces(@color).shuffle.each do |piece|
      all_moves = piece.valid_moves
      next if all_moves.empty?
      if @best_piece.nil?
        @best_piece = piece
        @best_move = all_moves[0]
      end
      test_all_moves(board, piece, all_moves, highest_val)
    end
  end

  def test_all_moves(board, piece, all_moves, highest_val)
    start_pos = piece.pos
    all_moves.each do |move|
      board_val = move_result(board, piece, start_pos, move)
      next unless board_val > highest_val
      @best_piece = piece
      @best_move = move
      highest_val = board_val
    end
  end

  def move_result(board, piece, start_pos, move)
    target_piece = board[move]
    board.move_piece(piece, move)
    board_val = PointSystem.calc_board_val(@color, board.rows)
    board.undo_move_piece(start_pos, move, target_piece)
    board_val
  end

  def move_cursor(end_pos)
    @display.cursor.cursor_pos = end_pos
    @display.render(@color)
  end

  def eval_board(board, checkmate, is_max)
    add_on = 0
    add_on = is_max ? -1000 : 1000 if checkmate
    PointSystem.calc_board_val(@color, board.rows) + add_on
  end

  def minimax_ab(board, depth = DEPTH, is_max = true, alpha = -INF, beta = INF)
    curr_player = is_max ? @color : @opponent_color
    checkmate = board.checkmate?(curr_player)
    return eval_board(board, checkmate, is_max) if depth.zero? || checkmate
  
    best_value = is_max ? -INF : INF
  
    board.pieces(curr_player).shuffle.each do |piece|
      piece.valid_moves.each do |move|
        b_copy = board.dup
        b_copy.move_piece!(curr_player, piece.pos, move)
        value = minimax_ab(b_copy, depth - 1, !is_max, alpha, beta)
        if is_max && value > best_value
          best_value = value
          alpha = value
          @best_piece, @best_move = piece, move if depth == DEPTH
        elsif !is_max && value <= best_value
          best_value = value
          beta = value
        end
        return best_value if beta <= alpha
      end
    end
    best_value
  end
end
