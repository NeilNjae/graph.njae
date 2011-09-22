require 'ostruct'

# A simple graph library

module Graph
  
  # A container for all the parts of a graph.  The graph can have arbitrary attributes,
  # treated as method names.
  class Graph < OpenStruct
    def initialize
      super
      self.edges = Array.new
      self.vertices = Array.new
      self
    end
    
    # Add a Vertex or Edge to the graph.
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
