module ApplicationHelper
  def alert_class(name)
    name = name.to_sym
    case name
    when :notice, :success then :success
    when :warning then :warning
    when :info then :info
    else :danger
    end
  end

  def empty_char
    '&#8709;'.html_safe
  end

  def provider_profile_link(provider, uid)
    case provider
    when 'twitter'
      link_to provider.capitalize, "https://twitter.com/intent/user?user_id=#{uid}"
    when 'facebook'
      link_to provider.capitalize, "https://www.facebook.com/#{uid}"
    else
      empty_char
    end
  end

  def roles_list(roles)
    roles.any? ? roles.map(&:name).join(', ') : empty_char
  end
end
