require 'ostruct'

module Graph
  class Vertex < OpenStruct
    def initialize
      super
      self.edges = []
      self
    end
    
    def connect(other)
      e = Edge.new
      e << self << other
      self.edges << e
      other.edges << e unless self === other
      e
    end
    
    def <<(other)
      connect(other)
      self
    end
    
    def neighbours
      vertices = self.edges.map {|e| e.vertices}.flatten
      vertices_to_me = vertices.select {|v| v == self}
      other_vertices = vertices.select {|v| v != self}
      (vertices_to_me[1..-1] || []) + other_vertices
    end
    
  end
end
