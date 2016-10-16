require 'support/user_sign_in_helper'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include(UserSignInHelper)
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
