require 'ostruct'

# A simple graph library

module GraphNjae
  
  # A container for all the parts of a graph.  The graph can have arbitrary attributes,
  # treated as method names.
  class Graph < OpenStruct
    def initialize(values = {})
      super(values)
      self.edges = Array.new
      self.vertices = Array.new
      self
    end
    
    # Add a Vertex or Edge to the graph.
    def <<(other)
      if other.class.ancestors.include? Vertex
        self.vertices << other
      elsif other.class.ancestors.include? Edge
        self.edges << other
      end
      self
    end
    
    # Form a product graph of this graph and the other.
    # Return the new graph.
    def product(other)
      product_graph = Graph.new
      self.vertices.each do |v1|
        other.vertices.each do |v2|
          product_vertex = Vertex.new
          product_vertex.left_node = v1
          product_vertex.right_node = v2
          product_graph << product_vertex
        end
      end
    end
    
  end # class
end
