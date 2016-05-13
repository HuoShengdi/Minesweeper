require_relative "tile"

class Board
  attr_reader :grid
  attr_accessor :grid
  def initialize(grid)
    @grid = grid
  end

  def self.generate(size = "9x9")
    dimensions = size.split("x").map { |char| Integer(char)}
    grid = Array.new(dimensions[0]) do
      Array.new(dimensions[1]) {Tile.new}
    end
    self.new(grid)
  end

  def populate(mine_num)
    count = 0
    while count < mine_num
      pos = [rand(0..@grid.length-1), rand(0..@grid[0].length-1)]
      place_mine(pos) if @grid[pos].mine == false
      count += 1
    end
  end

  def place_mine(pos)
    x,y = pos
    tile = @grid[x][y]
    if tile.mine == false

      tile.add_mine
      next_pos = adjacent_pos(pos)
      next_pos.each do |pos|
        self[pos].value = self[pos].value + 1
      end
    end
  end

  def adjacent_pos(pos)
    x,y = pos
    adj_pos = []
    @grid[x-1..x+1].each_with_index do |row, offx|
      @grid[x-1 + offx][y-1..y+1].each_with_index do |t, offy|
        if t && t != @grid[x][y]
          adj_pos << [x - 1 + offx, y - 1 + offy]
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
      adjacent_pos(pos).each do |adj_pos|
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


end
