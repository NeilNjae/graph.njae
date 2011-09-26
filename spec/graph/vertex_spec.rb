require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae
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
    
    describe "#neighbours" do
      it "finds neighbours of a self loop" do
        v << v
        v.should have(1).neighbours
        v.neighbours.should include v
      end
      
      it "finds neighbours on an edge" do
        v1 = Vertex.new
        v << v1
        v.should have(1).neighbours
        v.neighbours.should include v1
        v1.should have(1).neighbours
        v1.neighbours.should include v
      end
      
      it "finds neighbours with multiple edges" do
        v1 = Vertex.new
        v1.id = :v1
        v << v1
        v1 << v
        v.should have(2).neighbours
        v.neighbours.should include v1
        v.neighbours.should_not include v
        v1.should have(2).neighbours
        v1.neighbours.should include v
        v1.neighbours.should_not include v1
      end
      
      it "finds neighbours with multiple self loops" do
        v << v << v << v
        v.should have(3).neighbours
        v.neighbours.should include v
        v.neighbours.uniq.length.should == 1
      end
      
      it "finds neighbours with all sorts of edges" do
        v1 = Vertex.new ; v1.id = :v1
        v2 = Vertex.new ; v2.id = :v2
        v3 = Vertex.new ; v3.id = :v3
        v1 << v
        v << v2
        v2 << v3
        v2 << v2
        
        v.should have(2).neighbours
        v.neighbours.should include v1
        v.neighbours.should include v2
        
        v1.should have(1).neighbours
        v1.neighbours.should include v
        
        v2.should have(3).neighbours
        v2.neighbours.should include v
        v2.neighbours.should include v2
        v2.neighbours.should include v3
        
        v3.should have(1).neighbours
        v3.neighbours.should include v2
      end
      
      it "finds neighbours in graphs with several vertices" do
        v1 = Vertex.new ; v1.id = :v1
        v2 = Vertex.new ; v2.id = :v2
        v3 = Vertex.new ; v3.id = :v3
        v4 = Vertex.new ; v4.id = :v4
        v << v1
        v1 << v2
        v2 << v3
        v << v3
        v4 << v3
        v.should have(2).neighbours
        v.neighbours.should include v1
        v.neighbours.should include v3
        v.neighbours.should_not include v
        v1.should have(2).neighbours
        v1.neighbours.should include v
        v1.neighbours.should include v2
        v1.neighbours.should_not include v1
        v2.should have(2).neighbours
        v2.neighbours.should include v1
        v2.neighbours.should include v3
        v2.neighbours.should_not include v2
        v3.should have(3).neighbours
        v3.neighbours.should include v
        v3.neighbours.should include v2
        v3.neighbours.should include v4
        v3.neighbours.should_not include v3
        v4.should have(1).neighbours
        v4.neighbours.should include v3
        v4.neighbours.should_not include v4
      end
      
      it "finds neighbours with multiple edges between vertices" do
        v1 = Vertex.new ; v1.id = :v1
        v2 = Vertex.new ; v2.id = :v2
        v3 = Vertex.new ; v3.id = :v3
        v1 << v1 << v
        v << v2
        v << v
        v3 << v2
        v2 << v3
        v2 << v2
        
        v.should have(3).neighbours
        v.neighbours.should include v1
        v.neighbours.should include v2
        v.neighbours.should include v
        
        v1.should have(2).neighbours
        v1.neighbours.should include v
        v1.neighbours.should include v1
        
        v2.should have(4).neighbours
        v2.neighbours.should include v
        v2.neighbours.should include v2
        v2.neighbours.should include v3
        v2.neighbours.uniq.length.should == 3
        
        v3.should have(2).neighbours
        v3.neighbours.should include v2
        v3.neighbours.uniq.length.should == 1
      end
    end # #neighbours
  end
end
