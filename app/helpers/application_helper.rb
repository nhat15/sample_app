module ApplicationHelper
  def full_title title = ""
    base_title = t("ruby")
    title.blank? ? base_title : "#{title} | #{base_title}"
  end
end
