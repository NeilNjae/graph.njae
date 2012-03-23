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
    
    # Connects two vertices, creating and storing a new edge
    # Also adds the vertices, unless they're already in the graph
    def connect(vertex1, vertex2)
      self.vertices << vertex1 unless self.vertices.include? vertex1
      self.vertices << vertex2 unless self.vertices.include? vertex2
      edge = Edge.new
      self.edges << edge
      edge << vertex1 << vertex2
    end
    
    # Form a product graph of this graph and the other.
    # Return the product graph.
    def product(other)
      product_graph = Graph.new
      self.vertices.each do |v1|
        other.vertices.each do |v2|
          product_graph << Vertex.new({:g1_vertex => v1, :g2_vertex => v2})
        end
      end
      self.edges.each do |e1|
        e1_vertices = e1.vertices
        other.edges.each do |e2|
          e2_vertices = e2.vertices
          source = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[0] and v.g2_vertex == e2_vertices[0]}
          destination = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[1] and v.g2_vertex == e2_vertices[1]}
          product_graph.connect source, destination
          source = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[0] and v.g2_vertex == e2_vertices[1]}
          destination = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[1] and v.g2_vertex == e2_vertices[0]}
          product_graph.connect source, destination
        end
      end
      product_graph
    end
    
    
    def initial_similarity
      self.vertices.each do |v|
        if block_given?
          v.initial_similarity = yield v
        else
          v.initial_similarity = 1.0
        end
        v.similarity = v.initial_similarity
      end
    end
    
    # Performs similarity flooding on a graph
    # Assumes that the initial similarity has already been calculated
    def similarity_flood(opts = {})
      max_iterations = opts[:iterations] || 100
      max_residual = opts[:max_residual] || 0.001
      iteration = 1
      residual = max_residual + 1
      while residual > max_residual and iteration <= max_iterations
        self.vertices.each do |v|
          v.last_similarity = v.similarity
        end
        self.vertices.each do |v|
           n = v.neighbours.length
           v.neighbours.each do |neighbour|
             neighbour.similarity += v.last_similarity / n
           end
        end
        max_similarity = vertices.max {|v, w| v.similarity <=> w.similarity}.similarity
        self.vertices.each do |v|
          v.similarity = v.similarity / max_similarity
        end
        residual = Math.sqrt(self.vertices.reduce(0) {|a, v| a += (v.similarity - v.last_similarity) ** 2})
        iteration += 1
      end
      
    end
    
  end # class
end
