# for knight and king

module Stepable
  def moves
    all_moves = []
    y, x = self.pos

    self.move_diffs.each do |delta_y, delta_x|
      pos_to_try = [y + delta_y, x + delta_x]
      next unless valid?(pos_to_try)
      all_moves << pos_to_try
    end
    all_moves
  end
end
