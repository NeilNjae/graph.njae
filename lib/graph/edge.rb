require 'ostruct'

module Graph
  class Edge < OpenStruct
    def initialize
      super
      self.connections = []
      self
    end
    
    def <<(other)
      c = Connection.new
      c.end = other
      self.connections << c
      self
    end
    
    def vertices
      self.connections.map {|c| c.end}
    end
    
    def connection_at(vertex)
      self.connections.select {|c| c.end.equal?  vertex}.first
    end
  end
  
  class Connection < OpenStruct
    def initialize
      super
      self
    end
  end
end
