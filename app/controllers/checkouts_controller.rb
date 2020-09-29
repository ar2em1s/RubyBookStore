class CheckoutsController < ApplicationController
  def show
    return redirect_to(root_path) if user_signed_in?

    store_location_for(:user, checkout_path)
  end
end
