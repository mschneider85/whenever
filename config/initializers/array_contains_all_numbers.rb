class String
  def number?
    return true if Float(self)
  rescue
    false
  end
end

class Array
  def all_numbers?
    any? && all?(&:number?)
  end
end
