class AnalyticsController < ApplicationController
  
  # Main statistics
  def global
    @total_searches = SearchAnalytic.count
    @unique_users = SearchAnalytic.distinct.count(:user_ip)

    @top_global_queries = SearchAnalytic.group(:query).order('count_all DESC').limit(10).count

    @recent_searches = SearchAnalytic.order(created_at: :desc).limit(10)
  end

  # User statistics
  def user
    @user_ip = request.remote_ip

    user_scope = SearchAnalytic.for_user(@user_ip)

    @user_total_searches = user_scope.count

    @user_top_queries = user_scope.group(:query).order('count_all DESC').limit(5).count

    @user_search_history = user_scope.order(created_at: :desc)
  end
end
