require 'rails_helper'

describe 'routing to users' do
  it 'routes GET /admin/users to admin_users#index' do
    expect(get: '/admin/users').to route_to(
      controller: 'admin/users',
      action: 'index'
    )
  end
end
