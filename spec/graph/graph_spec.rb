require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae
  describe Graph do
    let (:g) { Graph.new }
    describe "#initialize" do
      it "creates an empty graph" do
        g = Graph.new
        g.edges.should be_empty
        g.vertices.should be_empty
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
    end # #<<

    describe "connect" do
      it "adds and records an edge between vertices" do
      end
    end # #connect
    
  end
end
