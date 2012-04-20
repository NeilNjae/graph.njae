require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae

  class SVertex < Vertex
  end
  
  class SEdge < Edge
  end
  
  describe Graph do
    let (:g) { Graph.new }
    describe "#initialize" do
      it "creates an empty graph" do
        g = Graph.new
        g.edges.should be_empty
        g.vertices.should be_empty
      end
      
      it "creates a graph with some parameters" do
        g = Graph.new :value1 => 1, :value2 => "value2", :value3 => :v3
        g.value1.should == 1
        g.value2.should == "value2"
        g.value3.should == :v3
        g.value4.should be_nil
      end

    end # #initialize
      
    describe "adds attributes" do
      it "adds then reports arbitrary attributes" do
        g.score = 15
        g.score.should == 15
      end
    end # adds attributes
    
    describe "#<<" do
      it "adds a set of vertices" do
        g.vertices.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        g << v1 << v2
        g.should have(2).vertices
        g.vertices.should include(v1)
        g.vertices.should include(v2)
      end
      
      it "adds a set of edges" do
        g.edges.should be_empty
        e1 = Edge.new
        e2 = Edge.new
        g << e1 << e2
        g.should have(2).edges
        g.edges.should include(e1)
        g.edges.should include(e2)
      end
      
      it "adds a mixed set of vertices and edges" do
        g.vertices.should be_empty
        g.edges.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        e1 = Edge.new
        e2 = Edge.new
        g << v1 << e1 << v2 << e2
        g.should have(2).vertices
        g.vertices.should include(v1)
        g.vertices.should include(v2)
        g.should have(2).edges
        g.edges.should include(e1)
        g.edges.should include(e2)
      end
      
      it "adds a subclass of Vertex" do
        g.vertices.should be_empty
        v1 = SVertex.new
        v2 = SVertex.new
        g << v1 << v2
        g.should have(2).vertices
        g.vertices.should include(v1)
        g.vertices.should include(v2)        
      end
    end # #<<

    describe "connect" do
      it "adds and records an edge between vertices" do
        g.vertices.should be_empty
        g.edges.should be_empty
        v1 = Vertex.new(:name => :v1)
        v2 = Vertex.new(:name => :v2)
        g.connect(v1, v2)
        
        g.should have(2).vertices
        g.vertices.should include(v1)
        g.vertices.should include(v2)
        g.should have(1).edges
      end
      
      it "adds and records an edge with attributes between vertices" do
        g.vertices.should be_empty
        g.edges.should be_empty
        v1 = Vertex.new(:name => :v1)
        v2 = Vertex.new(:name => :v2)
        g.connect(v1, v2, :type => :edge_type)
        
        g.should have(2).vertices
        g.vertices.should include(v1)
        g.vertices.should include(v2)
        g.should have(1).edges
        g.edges[0].type.should == :edge_type
      end
    end # #connect
    
    describe "product" do
      it "finds a product graph of a pair of one-vertex graphs" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new
        g1 << g1v1
        g2v1 = Vertex.new
        g2 << g2v1
        product = g1.product g2
        
        product.vertices.should be_empty
        #product.vertices.first.g1_vertex.should == g1v1
        #product.vertices.first.g2_vertex.should == g2v1
        product.edges.should be_empty
      end

      it "finds a product graph of a pair of simple graphs" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1.connect(g1v1, g1v2)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2.connect(g2v1, g2v2)
        pg = g1.product g2
        
        pg.should have(4).vertices
        pg.should have(2).edges
      end
      
      it "finds a product graph of not-quite-simple graph" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1v3 = Vertex.new(:name => :g1v3)
        g1.connect(g1v1, g1v2)
        g1.connect(g1v2, g1v3)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2v3 = Vertex.new(:name => :g2v3)
        g2.connect(g2v1, g2v2)
        g2.connect(g2v2, g2v3)
        pg = g1.product g2
        
        pg.should have(9).vertices
        pg.should have(8).edges
      end

      it "finds a product graph of a simple graph with edge types" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1v3 = Vertex.new(:name => :g1v3)
        g1.connect(g1v1, g1v2, :type => :t1)
        g1.connect(g1v2, g1v3, :type => :t2)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2v3 = Vertex.new(:name => :g2v3)
        g2.connect(g2v1, g2v2, :type => :t1)
        g2.connect(g2v2, g2v3, :type => :t2)
        pg = g1.product g2
        
        pg.should have(7).vertices
        pg.should have(4).edges
      end

      it "finds a product graph of the example graph from paper" do
        pending "implementation of directed graphs as operands of the product graph"
        g1 = Graph.new
        g2 = Graph.new
        a = Vertex.new(:name => :a)
        a1 = Vertex.new(:name => :a1)
        a2 = Vertex.new(:name => :a2)
        g1.connect(a, a1, :type => :l1)
        g1.connect(a, a2, :type => :l1)
        g1.connect(a1, a2, :type => :l2)
        b = Vertex.new(:name => :b)
        b1 = Vertex.new(:name => :b1)
        b2 = Vertex.new(:name => :b2)
        g2.connect(b, b1, :type => :l1)
        g2.connect(b, b2, :type => :l2)
        g2.connect(b1, b2, :type => :l2)
        pg = g1.product g2

        pg.should have(4).edges
        pg.should have(6).vertices
      end

      
    end #product
    
    describe "initial_similarity" do
      before(:each) do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1.connect(g1v1, g1v2)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2.connect(g2v1, g2v2)
        @pg = g1.product g2
      end
      
      def simple_name_similarity(n1, n2)
        1 - n1.to_s.codepoints.to_a.delete_if {|c| n2.to_s.codepoints.to_a.include? c}.length / n1.to_s.length.to_f
      end

      it "should give all nodes an initial similarity of 1 if no block is given" do
        @pg.initial_similarity
        @pg.vertices.each do |v|
          v.initial_similarity.should be_within(0.001).of(1.0)
          v.similarity.should be_within(0.001).of(1.0)
        end
      end
      
      it "should give all nodes the similarity as defined by the given block" do
        @pg.initial_similarity {|v| simple_name_similarity v.g1_vertex.name, v.g2_vertex.name}
        @pg.vertices.each do |v|
          v.initial_similarity.should be_within(0.001).of( simple_name_similarity v.g1_vertex.name, v.g2_vertex.name )
          v.similarity.should be_within(0.001).of( simple_name_similarity v.g1_vertex.name, v.g2_vertex.name )
        end

      end
    end #initial similarity
    
    describe "similarity flood" do
      it "similarity floods a graph of two nodes" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1.connect(g1v1, g1v2)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2.connect(g2v1, g2v2)
        pg = g1.product g2

        pg.initial_similarity
        pg.similarity_flood
        pg.vertices.each do |v|
          v.similarity.should be_within(0.001).of(1.0)
        end
      end
        
      it "similarity floods a graph of three nodes, a -- b -- c" do
        g1 = Graph.new
        g2 = Graph.new
        g1v1 = Vertex.new(:name => :g1v1)
        g1v2 = Vertex.new(:name => :g1v2)
        g1v3 = Vertex.new(:name => :g1v3)
        g1.connect(g1v1, g1v2, :type => :t1)
        g1.connect(g1v2, g1v3, :type => :t2)
        g2v1 = Vertex.new(:name => :g2v1)
        g2v2 = Vertex.new(:name => :g2v2)
        g2v3 = Vertex.new(:name => :g2v3)
        g2.connect(g2v1, g2v2, :type => :t1)
        g2.connect(g2v2, g2v3, :type => :t2)
        pg = g1.product g2
        
        pg.initial_similarity
        pg.similarity_flood
        expected_similarities = {
          "g1v1:g2v1" => 0.5,
          "g1v1:g2v2" => 0.6666666666666666,
          "g1v2:g2v1" => 0.6666666666666666,
          "g1v2:g2v2" => 1.0,
          "g1v2:g2v3" => 0.6666666666666666,
          "g1v3:g2v2" => 0.6666666666666666,
          "g1v3:g2v3" => 0.5}
        pg.vertices.each do |v|
          name = v.g1_vertex.name.to_s + ':' + v.g2_vertex.name.to_s
          v.similarity.should be_within(0.001).of(expected_similarities[name])
        end
      end
        
      it "simialrity floods the sample graph from the paper" do
        pg = Graph.new
        ab = Vertex.new(:name => "a:b")
        a1b1 = Vertex.new(:name => "a1:b1")
        a2b1 = Vertex.new(:name => "a2:b1")
        a1b2 = Vertex.new(:name => "a1:b2")
        a1b = Vertex.new(:name => "a1:b")
        a2b2 = Vertex.new(:name => "a2:b2")
        pg.connect(ab, a1b1, :type => :l1)
        pg.connect(ab, a2b1, :type => :l1)
        pg.connect(a2b1, a1b2, :type => :l2)
        pg.connect(a1b, a2b2, :type => :l2)
        pg.initial_similarity
        pg.similarity_flood 

        expected_similarities = {
          "a:b" => 1.0,
          "a2:b1" => 0.92,
          "a1:b2" => 0.71,
          "a1:b1" => 0.38,
          "a1:b" => 0.0,
          "a2:b2" => 0.0}
        pg.vertices.each do |v|
          v.similarity.should be_within(0.02).of(expected_similarities[v.name])
        end
      end
    end # similarity_flood
    
  end
end
