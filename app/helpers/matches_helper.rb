module MatchesHelper
  def show_result
    case @match.status.to_sym
    when :not_occur
      render html: ("<p><strong>" + t("matches.show.not_occur") +
        "</strong></p>").html_safe
    when :live
      render html: ("<p><strong>" + t("matches.show.live") +
        "</strong></p>").html_safe
    when :finished
      render_match_result
    end
  end

  def render_match_result
    render html: ("<p><strong>" + t("matches.show.finished") +
      "</strong></p>" + "<p>" + @match.match_result_score1.to_s +
      "<strong> - </strong>" + @match.match_result_score2.to_s +
      "</p>").html_safe
  end
end
