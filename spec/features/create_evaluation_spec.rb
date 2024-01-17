require 'rails_helper'

RSpec.describe 'Creating an evaluation', type: :feature do
  scenario 'access evaluation form' do
    visit root_path
    click_on 'New Evaluation'
    expect(page).to have_content('Or upload a .txt file')
  end

  scenario 'create evaluation with text' do
    visit root_path
    click_on 'New Evaluation'

    fill_in 'Grid', with: "11\n10"
    click_on 'Create Evaluation'

    expect(page).to have_content('Evaluation was successfully created.')
  end

  scenario 'create evaluation with file' do
    visit root_path
    click_on 'New Evaluation'

    attach_file('Grid file', Rails.root.join("spec/fixtures/valid.txt"))
    click_on 'Create Evaluation'

    expect(page).to have_content('Evaluation was successfully created.')

    visit admin_evaluations_path
    expect(page).to have_content('Yes')
  end
end