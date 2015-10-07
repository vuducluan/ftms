module RailsAdminCourse
  extend ActiveSupport::Concern
  included do
    rails_admin do
      edit do
        field :name
        field :description
      end
      list do
        field :name do
          formatted_value do
            bindings[:view].content_tag :a, "#{bindings[:object].name}",
              href: "course/#{bindings[:object].id}?locale=#{I18n.locale}"
          end
        end
        field :start_date
        field :end_date
        field :status do
          pretty_value do
            status = bindings[:object]
            class_label = if status.init?
              "label label-success"
            elsif status.progress?
              "label label-info"
            else status.finish?
              "label label-default"
            end
            %{<div class="#{class_label}">#{status.status}</div>}.html_safe
          end
        end
        field :leaders do
          pretty_value do
            value = bindings[:object].leaders.first.name
            %{<div><a href= user/#{bindings[:object].leaders.first.id}?locale=#{I18n.locale}>
              #{value}<a></div>}.html_safe
          end
        end
      end
    end
  end
end
