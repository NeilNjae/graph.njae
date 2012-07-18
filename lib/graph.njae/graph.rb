require 'logger'
$log = Logger.new(STDERR)
$log.level = Logger::WARN

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
    def connect(vertex1, vertex2, edge_attributes = {})
      self.vertices << vertex1 unless self.vertices.include? vertex1
      self.vertices << vertex2 unless self.vertices.include? vertex2
      edge = Edge.new(edge_attributes)
      self.edges << edge
      edge << vertex1 << vertex2
    end
    
    def to_dot(opts = {})
      vertex_args = opts[:vertex_args] || {}
      vertex_block = opts[:vertex_block] || nil
      edge_args = opts[:edge_args] || {}
      edge_block = opts[:edge_block] || nil
      dot = "graph {\n"
      self.vertices.each do |v|
        if vertex_block.nil?
          dot << v.to_dot(vertex_args)
        else
          dot << v.to_dot(&vertex_block)
        end
        dot << "\n"
      end
      self.edges.each do |e|
        if edge_block.nil?
          dot << e.to_dot(edge_args)
        else
          dot << e.to_dot(&edge_block)
        end
        dot << "\n"
      end
      dot << '}'
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
          if e1.type == e2.type
            e2_vertices = e2.vertices
            source = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[0] and v.g2_vertex == e2_vertices[0]}
            destination = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[1] and v.g2_vertex == e2_vertices[1]}
            product_graph.connect source, destination
            source = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[0] and v.g2_vertex == e2_vertices[1]}
            destination = product_graph.vertices.find {|v| v.g1_vertex == e1_vertices[1] and v.g2_vertex == e2_vertices[0]}
            product_graph.connect source, destination
          end
        end
      end
      product_graph.vertices.reject! {|v| v.neighbours.empty?}      
      product_graph
    end
    
    
    # Calculates the initial similarity of each vertex in a product graph.
    # If passed an optional block, that block is used to find the 
    # initial similarity. If no block is given, every vertex is given
    # an initial similarity of 1.0.
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
    
    # Performs similarity flooding on a graph, as described by 
    # Sergey Melnik, Hector Garcia-Molina, and Erhard Rahm, 
    # "Similarity Flooding: A Versatile Graph Matching Algorithm 
    #    and its Application to Schema Matching", Proceedings of 
    # the 18th International Conference on Data Engineering (ICDE’02)
    #
    # Assumes that the initial similarity has already been calculated
    # If passed an optional block, it uses that block to update the 
    # similarity on each iteration. If no block is passed, it uses the 
    # default similarity updating method from the paper.
    def similarity_flood(opts = {})
      max_iterations = opts[:iterations] || 100
      max_residual = opts[:max_residual] || 0.001
      iteration = 1
      residual = max_residual + 1
      while residual > max_residual and iteration <= max_iterations
        $log.debug { "Starting iteration #{iteration}" }
        self.vertices.each do |v|
          v.last_similarity = v.similarity
        end
        self.vertices.each do |v|
          if block_given?
            v.similarity = yield v
          else
            $log.debug { "Processing vertex #{v.name}" }
            edge_groups = v.edges.group_by {|e| e.type }
            $log.debug { "  Edge groups {#{edge_groups.keys.map {|t| t.to_s + ' => {' + edge_groups[t].map {|e| e.to_s}.join(', ')}.join('; ')}}" }
            edge_groups.each do |type, edges|
              $log.debug { "    Processing group type #{type}" }
              n = edges.length
              edges.each do |e|
                e.other_end(v).similarity += v.last_similarity / n
              end
            end
          end
        end
        max_similarity = vertices.map {|v| v.similarity}.max
        self.vertices.each do |v|
          v.similarity = v.similarity / max_similarity
        end
        residual = Math.sqrt(self.vertices.reduce(0) {|a, v| a += (v.similarity - v.last_similarity) ** 2})
        $log.debug { puts "Residual = #{residual.round(3)}, sims = #{self.vertices.map {|v| v.name + " = " + v.similarity.round(2).to_s}}" }
        iteration += 1
      end
      
    end
    
  end # class
end
