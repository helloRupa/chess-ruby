require_relative './board.rb'
require_relative './cursor.rb'
require 'colorize'

class Display
  C_COLORS = { main: :blue, selected: :light_magenta }.freeze
  BG_COLORS = [:light_white, :black].freeze
  PIECE_COLORS = { black: :light_cyan, white: :light_red }.freeze

  attr_reader :cursor, :board

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
    @bg = BG_COLORS[0]
  end

  def render
    system('clear')
    @board.rows.each_with_index do |row, y|
      print_row(row, y)
      @bg = main_bg_color
    end
  end

  private

  def print_row(row, y)
    row.each_with_index do |piece, x|
      str = " #{piece.to_s} "
      bg_color = get_bg_color([y, x])
      print str.colorize(:color => get_piece_color(piece), :background => bg_color)
      @bg = main_bg_color
    end
    puts
  end

  def get_bg_color(pos)
    return C_COLORS[:selected] if pos == @cursor.selected_space && cursor.selected
    pos == @cursor.cursor_pos ? C_COLORS[:main] : main_bg_color
  end

  def main_bg_color
    @bg == BG_COLORS[0] ? BG_COLORS[1] : BG_COLORS[0]
  end

  def get_piece_color(piece)
    piece.color == :black ? PIECE_COLORS[:black] : PIECE_COLORS[:white]
  end
end

if $PROGRAM_NAME == __FILE__
  d = Display.new(Board.new)
  d.render
  100.times do
    d.cursor.get_input
    d.render
  end
end
