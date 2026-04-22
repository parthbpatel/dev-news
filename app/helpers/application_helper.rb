module ApplicationHelper
  include Pagy::Frontend

  def pagy_next_url_for(pagy)
    return unless pagy&.next

    pagy_url_for(pagy, pagy.next)
  end
end
