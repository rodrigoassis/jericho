class Evaluation < ApplicationRecord
  validates :grid, presence: true
  validate :grid_format

  has_many :conductive_paths

  after_create :generate_conductive_paths
  before_validation :text_content_to_grid

  default_scope { includes(:conductive_paths) }

  mount_uploader :grid_file, GridFileUploader

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "grid", "id", "id_value", "result", "updated_at"]
  end

  def treated_grid
    grid.split("\n").map(&:chomp).map { |row| row.split('').map(&:to_i) }
  end

  private

  def grid_format
    return unless grid.present?

    errors.add(:grid, 'must be made of 0s and 1s') unless (grid.split('') - ['1'] - ['0'] - ["\r"] - ["\n"]).blank?

    rows = grid.split("\n").map(&:chomp)
    errors.add(:grid, 'must be NxN') if rows.any? { |row| row.chomp.size != rows.size }
  end

  def text_content_to_grid
    self.grid = File.read(grid_file.path) if grid_file.present?
  end

  def generate_conductive_paths
    cols = treated_grid.size

    # Iterate through the top edge cells and check for conductive path
    (0...cols).each do |col|
      positions = [] # Initialize a 2D array to track positions visited
      update(result: true) if dfs(0, col, positions, treated_grid)
    end
  end

  # Depth-first search
  def dfs(row, col, positions, grid)
    rows = grid.length
    cols = grid[0].length

    return false if row < 0 || row >= rows || col < 0 || col >= cols # out of grid limits
    return false if positions.include?([row, col]) || grid[row][col] == 0 # has already been visited or has no path

    positions << [row, col]

    # Check if reached the bottom edge
    if row == rows - 1
      ConductivePath.create(positions: positions, evaluation: self)
      return true
    end

    # Recursive DFS in all four directions
    directions = [[1, 0], [0, 1], [-1, 0], [0, -1]] # try down, right, up, left in this order
    directions.each do |dr, dc|
      new_row, new_col = row + dr, col + dc
      return true if dfs(new_row, new_col, positions, grid)
    end

    false
  end
end
