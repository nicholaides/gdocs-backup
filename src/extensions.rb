class Numeric
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.1f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, units[e])
  end
end
