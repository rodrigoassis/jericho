ActiveAdmin.register Evaluation do
  filter :result

  controller do
    actions :all, except: [:edit, :destroy, :update]
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      input :grid, hint: "<a href='#' id='random_grid'>Generate random grid</a>".html_safe

      li "Or upload a .txt file"

      input :grid_file
    end
    f.actions
  end

  show do
    attributes_table do
      row :result
      row "Grid" do |evaluation|
        simple_format(evaluation.grid)
      end
      row "Grid File" do |evaluation|
        link_to(evaluation.grid_file&.identifier, evaluation.grid_file&.url, target: '_blank') if evaluation.grid_file.present?
      end
      row :created_at
    end

    evaluation.conductive_paths.each do |conductive_path|
      render partial: 'conductive_path', locals: { conductive_path: conductive_path, evaluation: evaluation }
    end
  end

  index do
    id_column
    column :result
    column "Grid" do |evaluation|
      simple_format(evaluation.grid)
    end
    column "Conductive Paths Count" do |evaluation|
      evaluation.conductive_paths.size
    end
    column "Grid File" do |evaluation|
      link_to(evaluation.grid_file&.identifier, evaluation.grid_file&.url, target: '_blank') if evaluation.grid_file.present?
    end
    column :created_at
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :grid, :grid_file
  #
  # or
  #
  # permit_params do
  #   permitted = [:grid, :result]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
