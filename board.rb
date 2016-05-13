require_relative "tile"

class Board
  attr_reader :grid
  attr_accessor :grid
  def initialize(grid)
    @grid = grid
    @mines = 0
  end

  def self.generate(size = "9x9")
    dimensions = size.split("x").map { |char| Integer(char)}
    grid = Array.new(dimensions[0]) do
      Array.new(dimensions[1]) {Tile.new}
    end
    self.new(grid)
  end

  def populate(mine_num)
    @mines = 0
    while count < mine_num
      pos = [rand(0..@grid.length-1), rand(0..@grid[0].length-1)]
      place_mine(pos) if @grid[pos].mine == false
      @mines += 1
    end
  end

  def place_mine(pos)
    x,y = pos
    tile = @grid[x][y]
    if tile.mine == false

      tile.add_mine
      next_pos = adjacent_positions(pos)
      next_pos.each do |pos|
        self[pos].value = self[pos].value + 1
      end
    end
  end

  # def adjacent_positions(pos)
  #   x,y = pos
  #   adj_pos = []
  #   @grid[x-1..x+1].each_with_index do |row, offx|
  #     @grid[x-1 + offx][y-1..y+1].each_with_index do |t, offy|
  #       if t && t != @grid[x][y]
  #         adj_pos << [x - 1 + offx, y - 1 + offy]
  #       end
  #     end
  #   end
  #   adj_pos
  # end

  def adjacent_positions(pos)
    x,y = pos
    adj_pos = []
    x_range = (x-1..x+1).to_a.select {|x| (0..grid.length-1).include?(x)}
    y_range = (y-1..y+1).to_a.select {|y| (0..grid[0].length-1).include?(y)}
    x_range.each_with_index do |i|
      y_range.each_with_index do |j|
        if [x,y] != [i,j]
          adj_pos << [i,j]
        end
      end
    end
    adj_pos
  end

  def render
    puts "  #{(0..@grid[0].length-1).to_a.join(" ")}"
    grid.each_with_index do |row, i|
      row_display = []
      row.each do |tile|
        row_display << tile.display_value
      end
      puts "#{i} #{row_display.join(" ")}"
    end
    nil
  end

  def tile_search(pos)
    self[pos].reveal
    if self[pos].value == 0
      adjacent_positions(pos).each do |adj_pos|
        tile_search(adj_pos) if self[adj_pos].revealed? == false
      end
    end
  end

  def place_flag(pos)
    x,y = pos
    tile = @grid[x][y]
    tile.flag = true
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos,val)
    x,y = pos
    tile = @grid[x][y]
    tile.value = val
  end

  def max_mines
    (@grid.length * @grid[0].length)/2
  end

  def min_mines
    @grid.length
  end
end
