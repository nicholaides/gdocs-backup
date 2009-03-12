class Numeric
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.1f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, units[e])
  end
end

class Time
  def time_ago_human
    #thanks to http://snippets.dzone.com/posts/show/5715
    val = Time.now - self
    #puts val
    if val < 10
      'just a moment ago'
    elsif val < 60
      'less than a minute ago'
    elsif val < 60 * 50
      mins = (val / 60).to_i
      "#{mins} minute#{'s' if mins > 1} ago"
    elsif val < 60  * 60  * 1.4
      'about 1 hour ago'
    elsif val < 60  * 60 * (24 / 1.02)
      "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
    else
      self.strftime("%B %d, %Y")
    end
  end
end