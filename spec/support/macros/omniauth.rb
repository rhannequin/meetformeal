module Macros
  module Omniauth
    def self.provides_mock_for(provider)
      class_eval %(
        def mock_auth_#{provider}
          OmniAuth.config.add_mock :#{provider}, uid: '12345', info: { name: '#{provider.capitalize} User' }
        end
      )
    end

    %i(twitter facebook).each do |provider|
      provides_mock_for provider
    end
  end
end
