# A simple graph library

module GraphNjae
  # A vertex in a graph. The edge can have arbitrary attributes,treated as 
  # method names.
  class Vertex < OpenStruct
    def initialize(values = {})
      super(values)
      self.edges = []
      self
    end
    
    # Connect this vertex to another, creating an Edge to do so, and returning
    # the Edge
    def connect(other, edge_attributes = {})
      e = Edge.new edge_attributes
      e << self << other
      # self.edges << e
      # other.edges << e unless self === other
      e
    end
    
    # Connect this vertex to another, creating an Edge to do so, and returning
    # this Vertex
    def <<(other)
      connect(other)
      self
    end
    
    # Return the set of neighbouring vertices
    def neighbours
      #vertices = self.edges.map {|e| e.vertices}.flatten
      #vertices_to_me = vertices.select {|v| v == self}
      #other_vertices = vertices.select {|v| v != self}
      #(vertices_to_me[1..-1] || []) + other_vertices#
      self.edges.map {|e| e.vertices.take_while {|v| v != self} + 
                      e.vertices.drop_while {|v| v != self}[1..-1]}.flatten
    end
    
    def to_s
      '<V: ' + self.name.to_s + '>'
    end
    
    def to_dot(opts = {})
      if block_given?
        yield self
      else
        dot = self.object_id.to_s
        if opts.size > 0
          dot << ' {'
          dot << opts.keys.map { |k|
            (k.to_s + ' = "' + self.instance_eval(opts[k].to_s).to_s) + '"'
                        }.join(', ')
          dot << '}'
        end
        dot << ';'
      end
    end
    
  end
end
