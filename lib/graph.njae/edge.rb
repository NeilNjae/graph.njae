require 'ostruct'

# A simple graph library

module GraphNjae
  
  # An edge (or multiedge) in a graph. The edge can have arbitrary attributes,
  # treated as method names.
  #
  # Each connection is handled by a Graph::Connection object, so that each end
  # of the Edge can have it's own attributes.
  class Edge < OpenStruct
    def initialize(values = {})
      super(values)
      self.connections = []
      self
    end
    
    # Connect this edge to a vertex
    def <<(other)
      c = Connection.new
      c.end = other
      other.edges << self unless other.edges.include? self
      self.connections << c
      self
    end
    
    # Return the set of vertices this edge connects.
    def vertices
      self.connections.map {|c| c.end}
    end
    
    # Return the connection object that joins this Edge to the specified Vertex
    def connection_at(vertex)
      self.connections.find {|c| c.end.equal?  vertex}
    end
    
    # Return the vertex at the other end of the one given.
    # Self-loops should still return the vertex
    def other_end(vertex)
      if self.vertices[0] == vertex
        self.vertices[1]
      else
        self.vertices[0]
      end
    end
    
    def to_s
      '<E: ' + self.type.to_s + ' [' + self.vertices.map {|n| n.to_s}.join(', ') + '] >'
    end
  end
  
  # A connection between an Edge and a Vertex.The connection can have arbitrary attributes,
  # treated as method names.
  class Connection < OpenStruct
    def initialize(values = {})
      super(values)
      self
    end
  end
end
