class PagesController < ApplicationController

  def home
    @word_cloud = SearchAnalytic.word_cloud
  end

  def leave
    session[:ip_consent_given] = false
    redirect_to root_path
  end

  def save_query
    query = params.fetch(:query, "").strip
    return head :ok if query.blank? # Ignore blank queries

    SearchAnalytic.create(query: query, user_ip: request.remote_ip)

    head :ok
  end

  def analytics
    @search_analytics = SearchAnalytics
      .group(:query)
      .order('count_all DESC')
      .limit(20)
      .count
  end
end
