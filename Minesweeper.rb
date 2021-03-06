require_relative "board"
require 'byebug'
class Minesweeper

  def initialize(board)
    @board = board
    @maximum_mines = @board.max_mines
    @minimum_mines = @board.min_mines
    @mine_count = 0
  end


  def run
    @mine_count = get_mine_count
    until game_over?
      play_turn
    end
    if game_won?
      @board.reveal_all
      @board.render
      puts "Congratulations, you win!"
    else
      @board.reveal_all
      @board.render
      puts "Sorry, you lose!"
    end

  end

  def play_turn
    @board.render
    make_play
  end

  def make_play
    pos = get_pos
    if pos.length == 3
      @board.place_flag(pos[0..1])
      return
    elsif @board.mines == 0
      @board.reveal(pos)
      @board.populate(@mine_count)
    end
    @board.tile_search(pos)
  end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g., '3,4')"
      print "> "

      begin
        pos = parse_pos(gets.chomp)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    pos
  end


  def get_mine_count
    mine_count = nil
    until mine_count && valid_count?(mine_count)
      puts "Before we begin, choose how many mines you want to place on the board."
      puts "You may place between #{@minimum_mines} and #{@maximum_mines} mines."
      print "> "

      begin
        mine_count = parse_count(gets.chomp)
      rescue
        puts "Invalid mine count! Please try again."
        puts ""

        mine_count = nil
      end
    end

    mine_count

  end

  def parse_count(count)
    Integer(count)
  end

  def parse_pos(pos)
    chars = pos.split(",")
    option = []
    if chars.length == 3
      option << chars.pop
    end
    chars.map! { |char| Integer(char) } + option
  end

  def valid_count?(count)
      count.is_a?(Integer) &&
        count.between?(@minimum_mines, @maximum_mines)
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      ((pos.length == 2) || ((pos.length == 3) && pos[-1] == "f")) &&
      @board.include?(pos)
      return true
    else
      false
    end
  end

  def game_over?
    @board.solved? || @board.mine_hit?
  end

  def game_won?
    @board.solved?
  end

end


if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Minesweeper! Choose the size of your board, e.g. 9x9"
  board_size = gets.chomp

  game = Minesweeper.new(Board.generate(board_size))
  game.run
end
