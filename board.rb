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
    if tile.mine == true
      break
    end
    tile.add_mine
    next_tiles = adjacent_tiles(pos)
    next_tiles.each do |t|
      t.value = t.value + 1
    end
  end

  def adjacent_tiles(pos)
    x,y = pos
    adj_tiles = []
    @grid[x-1..x+1].each_with_index do |row, offset|
      @grid[x-1 + offset][y-1..y+1].each do |t|
        if t && t != @grid[x][y]
          adj_tiles << t
        end
      end
    end
    adj_tiles
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
  end

  def tile_search


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
