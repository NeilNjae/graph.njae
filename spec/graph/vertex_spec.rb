require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Graph
  describe Vertex do
    let (:v) { Vertex.new }
    
    describe "#initialize" do
      it "creates an empty vertex" do
        v = Vertex.new
        v.edges.should be_empty
      end
    end # #initialize
    
    describe "adds attribues" do
      it "adds then reports arbitrary attributes" do
        v.score = 15
        v.score.should == 15
      end
    end # adds attributes
    
    describe "#<<" do
      it "adds a single edge between vertices" do
        v.neighbours.should be_empty
        v.edges.should be_empty
        
        v1 = Vertex.new
        v << v1
        
        v1.id = :v1 # Need this to ensure that v != v1
        
        v.should have(1).edges
        v1.should have(1).edges
        e = v.edges[0]
        v1.edges.should include(e)
        
        v.should have(1).neighbours
        v.neighbours.should include(v1)
        v.neighbours.should_not include(v)
        v1.should have(1).neighbours
        v1.neighbours.should include(v)
        v1.neighbours.should_not include(v1)
      end

      it "adds a single edge as a self-loop" do
        v.neighbours.should be_empty
        v.edges.should be_empty
        
        v << v
        
        v.should have(1).edges
        v.should have(1).neighbours
        v.neighbours.should include(v)
      end
    end # #<<
    
    describe "connect" do
      it "connects two vertices" do
        v1 = Vertex.new
        v1.id = :v1 # Need this to ensure that v != v1

        e = v.connect v1
        
        v.should have(1).neighbours
        v.neighbours.should include(v1)
        v.neighbours.should_not include(v)

        v1.should have(1).neighbours
        v1.neighbours.should include(v)
        v1.neighbours.should_not include(v1)

        v.should have(1).edges
        v.edges.should include(e)
        v1.should have(1).edges
        v1.edges.should include(e)
        
        e.should have(2).vertices
        e.vertices.should include(v)
        e.vertices.should include(v1)

              e.should have(2).connections
      end

      it "creates a self-connection" do
        e = v.connect v
        
        v.should have(1).neighbours
        v.neighbours.should include(v)

        v.should have(1).edges
        v.edges.should include(e)
        
        e.should have(2).vertices
        e.vertices.uniq.length.should == 1
        e.vertices.should include(v)

        e.should have(2).connections
      end

    end # #connect
  end
end
