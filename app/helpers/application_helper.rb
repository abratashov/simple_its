module ApplicationHelper

  def render_sign_up
    (current_user ? '' : "<li><a href='" + signup_path + "'>Sing up</a></li>").html_safe
  end

  def render_log_in
    (current_user ? '' : "<li><a href='" + login_path + "'>Log in</a></li>").html_safe
  end

  def render_confirm_uri uri
    (current_user ? '' : "<li><a href='" + uri + "'>" + uri + "</a></li>").html_safe
  end
end
