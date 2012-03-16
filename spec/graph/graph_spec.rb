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
      
    describe "adds attribues" do
      it "adds then reports arbitrary attributes" do
        g.score = 15
        g.score == 15
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
        
        product.should have(1).vertices
        product.vertices.first.g1_vertex.should == g1v1
        product.vertices.first.g2_vertex.should == g2v1
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
      end

    end
    
    describe "similarity flood" do
        it "similarity floods a graph of two nodes" do
        end
        
        it "similarity floods a graph of three nodes, a -- b -- c" do
        end
        
        it "simialrity floods a sample graph" do
        end
    end
    
  end
end
