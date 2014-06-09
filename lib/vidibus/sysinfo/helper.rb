module Helper
  # Rounds float with given precision.
  def round(float, precision = 2)
    m = 10**precision
    (float.to_f*m).round.to_f/m
  end
end
