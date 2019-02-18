# stop sliding when blocked by another piece.
# Don't allow a piece to move into a square already occupied by the same color piece,
# or to move a sliding piece past a piece that blocks it.
# for queen, rook, bishop

module Slideable
  DIFFS = {
    diagonal: [[-1, -1], [1, 1], [-1, 1], [1, -1]],
    straight: [[1, 0], [-1, 0], [0, 1], [0, -1]],
    both: [[-1, -1], [1, 1], [-1, 1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
  }.freeze

  # return array of places a Piece can move to
  def moves
    all_moves = []
    pos = self.pos

    DIFFS[self.move_dirs].each do |delta_arr|
      all_moves.concat(get_moves(pos, delta_arr))
    end
    all_moves
  end

  private

  def get_moves(pos, delta_arr)
    y, x = pos
    delta_y, delta_x = delta_arr
    all_moves = []

    loop do
      pos_to_try = [y + delta_y, x + delta_x]
      break unless valid?(pos_to_try)
      all_moves << pos_to_try
      break if opponent?(@board[pos_to_try])
      y, x = pos_to_try
    end
    all_moves
  end
end
