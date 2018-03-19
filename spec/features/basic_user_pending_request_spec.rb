# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Publish Record', type: :feature do
  before do
    stub_request(:get, 'https://country.register.gov.uk/record/zz.tsv')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' })
      .to_return(status: 404, headers: {})

    stub_request(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email')
      .to_return(status: 200, body: '{}')

    stub('https://country.register.gov.uk/download-rsf', './spec/support/country.rsf')
    stub('https://register.register.gov.uk/record/register.tsv', './spec/support/register_register.tsv')
    stub('https://field.register.gov.uk/record/register.tsv', './spec/support/field_register.tsv')
    stub('https://field.register.gov.uk/record/text.tsv', './spec/support/text.tsv')
    stub('https://field.register.gov.uk/record/phase.tsv', './spec/support/phase.tsv')
    stub('https://field.register.gov.uk/record/registry.tsv', './spec/support/registry.tsv')
    stub('https://field.register.gov.uk/record/copyright.tsv', './spec/support/copyright.tsv')
    stub('https://field.register.gov.uk/record/fields.tsv', './spec/support/fields.tsv')
    stub('https://register.register.gov.uk/records.tsv', './spec/support/register_records.tsv')
    stub('https://register.register.gov.uk/record/country.tsv', './spec/support/country.tsv')
    stub('https://field.register.gov.uk/record/country.tsv', './spec/support/field_country.tsv')
    stub('https://field.register.gov.uk/record/name.tsv', './spec/support/field_name.tsv')
    stub('https://field.register.gov.uk/record/official-name.tsv', './spec/support/field_official_name.tsv')
    stub('https://field.register.gov.uk/record/citizen-names.tsv', './spec/support/field_citizen_name.tsv')
    stub('https://field.register.gov.uk/record/start-date.tsv', './spec/support/field_start_date.tsv')
    stub('https://field.register.gov.uk/record/end-date.tsv', './spec/support/field_end_date.tsv')
    stub('https://country.register.gov.uk/records.tsv', './spec/support/records.tsv')
  end

  before :each do
    ObjectsFactory.new.create_user_with_team('basicuser@gov.uk', true, 'basic')
    create(:register, key: 'country')
    expect(User.count).to eq(1)

    visit '/'
    expect(page).to have_content 'Sign in'
    fill_in 'Email', with: 'basicuser@gov.uk'
    fill_in 'Password', with: 'password123'
    click_button 'Continue'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'basic user can submit change for review' do
    click_on('Country')
    click_on('Add a new record')
    fill_in 'country', with: 'zz'
    fill_in 'name', with: 'name'
    fill_in 'official-name', with: 'official name'
    fill_in 'start-date', with: '2014-05'
    fill_in 'end-date', with: '2014-05'
    click_button 'Continue'
    expect(page).to have_content 'Check your new record'
    expect(page).to have_content 'sent for review'
    click_button 'Submit'
    expect(page).to have_content 'Your update has been submitted and sent for review.'
  end
end
