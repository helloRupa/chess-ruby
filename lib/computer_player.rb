require_relative './player.rb'
require_relative './point_system.rb'

class ComputerPlayer < Player
  def initialize(color, display)
    super
    @best_piece = nil
    @best_move = nil
  end

  def make_move(board)
    # piece = choose_random_piece(board)
    choose_best_move(board)
    move_cursor(@best_piece.pos)
    sleep(1)
    # end_pos = choose_end_pos(piece)
    move_cursor(@best_move)
    board.move_piece!(@color, @best_piece.pos, @best_move)
    reset_best_piece_move
  end

  private

  def reset_best_piece_move
    @best_piece = nil
    @best_move = nil
  end

  def choose_random_piece(board)
    pieces = board.pieces(@color).reject { |piece| piece.valid_moves.empty? }
    pieces.sample
  end

  def choose_best_move(board)
    highest_val = PointSystem.calc_board_val(@color, board.rows)

    board.pieces(@color).shuffle.each do |piece|
      all_moves = piece.valid_moves
      next if all_moves.empty?
      @best_piece, @best_move = piece, all_moves[0] if @best_piece.nil?
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

  def choose_end_pos(piece)
    piece.valid_moves.sample
  end

  def move_cursor(end_pos)
    @display.cursor.cursor_pos = end_pos
    @display.render(@color)
  end
end
