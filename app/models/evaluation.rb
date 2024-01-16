class Evaluation < ApplicationRecord
  validates :grid, presence: true
  validate :grid_format

  has_many :conductive_paths

  after_create :generate_conductive_paths

  default_scope { includes(:conductive_paths) }

  def grid_format
    return unless grid.present?

    errors.add(:grid, 'must be made of 0s and 1s') unless (grid.split('') - ['1'] - ['0'] - ["\r"] - ["\n"]).blank?

    rows = grid.split("\r\n")
    errors.add(:grid, 'must be NxN') if rows.any? { |row| row.size != rows.size }
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "grid", "id", "id_value", "result", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["conductive_paths"]
  end

  def treated_grid
    grid.split("\r\n").map { |row| row.split('').map(&:to_i) }
  end

  private

  def generate_conductive_paths
    # Initialize a 2D array to track positions visited
    positions = []

    cols = treated_grid.size
    # Iterate through the top edge cells and check for conductive path
    (0...cols).each do |col|
      if dfs(0, col, positions, treated_grid)
        positions = []
        update(result: true)
      end
    end
  end

  # Depth-first search
  def dfs(row, col, positions, grid)
    rows = grid.length
    cols = grid[0].length

    return false if row < 0 || row >= rows || col < 0 || col >= cols
    return false if positions.include?([row, col]) || grid[row][col] == 0

    positions << [row, col]

    # Check if reached the bottom edge
    if row == rows - 1
      ConductivePath.create(positions: positions, evaluation: self)
      return true
    end

    # Recursive DFS in all four directions
    directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    directions.each do |dr, dc|
      new_row, new_col = row + dr, col + dc
      return true if dfs(new_row, new_col, positions, grid)
    end

    false
  end
end
