module MatchingHelper
  def distance_color(distance)
    if distance <= 2
      'font-weight-bold text-success'
    else
      if distance <= 5
        'font-weight-bold text-info'
      else
        'text-danger'
      end
    end

  end
end
