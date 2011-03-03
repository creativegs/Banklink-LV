String.class_eval do
  def to_squawk
    "squawk! #{self}".strip
  end
end