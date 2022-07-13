module ApplicationHelper
  include Pagy::Frontend
  def full_title title = ""
    base_title = t("ruby")
    title.blank? ? base_title : "#{title} | #{base_title}"
  end
end
