module ApplicationHelper
  def full_title page_title = ""
    base_title = t "staticpages.framgia"
    "#{page_title} | #{base_title}"
  end

  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def flash_message flash_type, *params
    if params.empty?
      t "flashs.messages.#{flash_type}", model_name: controller_name.classify
    else
      t "flashs.messages.#{flash_type}",
        models_name: params[0].join(", ") unless params[0].empty?
    end
  end

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def link_to_function name, function, html_options = {}
    message = t "message-link-to-function"
    ActiveSupport::Deprecation.warn message
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'
    content_tag :a, name, html_options.merge(href: href, onclick: onclick)
  end

  def tab_active tab_name, current_tab
    current_tab == tab_name ? "active" : nil
  end

  def member_list members
    members.map {|member| link_to member.name, member}.join(", ").html_safe
  end

  def select_profile_field target, target_array, builder
    builder.select "#{target}_id".to_sym,
      options_for_select(target_array.collect {|t|
      [t.name, t.id ]}, builder.object.send("#{target}_id")),
      {include_blank: true}, class: "form-control"
  end

  def avatar_user_tag user, class_name
    image_tag user.avatar_url ? user.avatar_url : "profile",
      class: class_name.to_sym
  end

  def image_target_tag target
    image_tag target.image_url ? target.image_url : "no_image",
      size: Settings.image_size
  end

  def image_course_tag course, language
    image_tag course.image_url ? course.image_url : language,
      size: Settings.image_size
  end

  def image_task_tag user_task
    image_tag user_task.task.image_url ? user_task.task.image_url : "level-1-on-rails-for-zombies", class: "img-circle"
  end
end
