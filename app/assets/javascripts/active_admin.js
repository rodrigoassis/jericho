//= require active_admin/base

jQuery(document).ready(function($) {
  $('#random_grid').click(function() {
    var final_matrix = [];
    var matrix = [];

    matrix_size = Math.floor(Math.random() * 10) + 2;

    for(var y = 0; y < matrix_size; y++){
      matrix[y] = [];
      for(var x = 0; x < matrix_size; x++){
        matrix[y][x] = Math.round(Math.random())
        final_matrix.push(matrix[y][x])
      }
    }

    document.getElementById("evaluation_grid").value = matrix.join("\n").replace(/,/g, '');

    return false;
  });
});
