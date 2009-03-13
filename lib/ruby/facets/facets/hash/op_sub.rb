class Hash

  # Operator for remove hash paris. If another hash is given
  # the pairs are only removed if both key and value are equal.
  # If an array is given then matching keys are removed.
  #
  # CREDIT: Trans

  def -(other)
    h = self.dup
    if other.respond_to?(:to_ary)
      other.to_ary.each do |k|
        h.delete(k)
      end
    else
      other.each do |k,v|
        if h.key?(k)
          h.delete(k) if v == h[k]
        end
      end
    end
    h
  end

end

