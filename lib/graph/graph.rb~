require 'ostruct'

module Graph
  class Graph < OpenStruct
    def initialize
      super
      self.edges = Array.new
      self.vertices = Array.new
      self
    end
    
    def <<(other)
      if other.class == Vertex
        self.vertices << other
      elsif
        self.edges << other
      end
      self
    end
  end
end
