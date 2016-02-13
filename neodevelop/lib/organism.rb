require "matrix"
require "colorize"

class Organism

  attr_accessor :cells, :next_generation, :cell_colors
  NEW_LINE = "\n"

  def initialize

  end

  def feed(population)
    @cells = Matrix.rows population
    @next_generation = Matrix.rows population
    colors = []
    population.each do |line|
      colors << line.collect do |c| c == 0 ? :black : :green end
    end
    @cell_colors = colors
    self
  end

  def cell_at(x, y)
    @cells[x,y]
  end

  def neighbors_at(posx,posy)
    neighbors = []
    (posx-1..posx+1).each do |x|
      (posy-1..posy+1).each do |y|
        if not(posx == x && posy == y)
          neighbors << @cells[ x < @cells.row_size ? x : 0,  y < @cells.column_size ? y : 0 ]
        end
      end
    end
    neighbors
  end

  def prepare_to_evolve
    local_cells = @next_generation.to_a
    @cells.each_with_index do |c, x, y|
      neighbors = neighbors_at x, y
      case
      when c == 1
        if neighbors.count(1)  <= 1 then # 1
          local_cells[x][y] = 0
          @cell_colors[x][y] = :black
        end
        if neighbors.count(1)  >= 4 then # 2
          local_cells[x][y] = 0
          @cell_colors[x][y] = :black
        end
        #local_cells[x][y] = 1 if(neighbors.count(1)  >= 2 and neighbors.count 1 <= 3)# 3
      else
        if neighbors.count(1)  == 3 then #4
          local_cells[x][y] = 1
          @cell_colors[x][y] = :green
        end
      end
    end
    @next_generation = Matrix.rows local_cells
  end

  def evolve
    @cells = @next_generation
  end

  def body
    display = ""
    @cells.each_with_index do |e, row, col|
      if e == 1 then
        display += "*"
      else
        display += " "
      end
      display += NEW_LINE if ((col+1) % @cells.column_count) == 0
    end
    display
  end

  def show_with_colors
    @cells.each_with_index do |e, row, col|
      if e == 1 then
        print "*".colorize(@cell_colors[row][col])
      else
        print " ".colorize(@cell_colors[row][col])
      end
      print NEW_LINE if ((col+1) % @cells.column_count) == 0
    end
  end

end
