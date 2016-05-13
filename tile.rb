class Tile
  attr_accessor :mine
  attr_accessor :flag
  attr_accessor :value
  attr_reader :value

  def initialize
    @mine = false
    @flag = false
    @value = 0
    @revealed = false
  end

  def reveal
    @revealed = true
  end

  def revealed?
    @revealed
  end

  def flag
    if @flag
      @flag = false
    else
      @flag = true
    end
  end

  def add_mine
    @mine = true
  end

  def value
    @value
  end

  def display_value
    if @revealed == true
      if @mine == true
        "*"
      elsif @value > 0
        @value
      else
        "."
      end
    elsif @flag == true
      "F"
    else
      " "
    end
  end

end
