require 'ostruct'

# A simple graph library

module GraphNjae
  
  # An edge (or multiedge) in a graph. The edge can have arbitrary attributes,
  # treated as method names.
  #
  # Each connection is handled by a Graph::Connection object, so that each end
  # of the Edge can have it's own attributes.
  class Edge < OpenStruct
    def initialize
      super
      self.connections = []
      self
    end
    
    # Connect this edge to a vertex
    def <<(other)
      c = Connection.new
      c.end = other
      self.connections << c
      self
    end
    
    # Return the set of vertices this edge connects.
    def vertices
      self.connections.map {|c| c.end}
    end
    
    # Return the connection object that joins this Edge to the specified Vertex
    def connection_at(vertex)
      self.connections.select {|c| c.end.equal?  vertex}.first
    end
  end
  
  # A connection between an Edge and a Vertex.The connection can have arbitrary attributes,
  # treated as method names.
  class Connection < OpenStruct
    def initialize
      super
      self
    end
  end
end
