require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae
  describe Edge do
    let (:e) { Edge.new }
    describe "#initialize" do
      it "creates an empty edge" do
        e = Edge.new
        e.connections.should be_empty
      end
      
      it "creates an edge with some parameters" do
        e = Edge.new :value1 => 1, :value2 => "value2", :value3 => :v3
        e.value1.should == 1
        e.value2.should == "value2"
        e.value3.should == :v3
        e.value4.should be_nil
      end

    end # #initialize
    
    describe "adds attribues" do
      it "adds then reports arbitrary attributes" do
        e.score = 15
        e.score.should == 15
      end
    end # adds attributes
    
    describe "#<<" do
      it "adds a new vertex to an edge (with a connection)" do
        e.connections.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        e << v1
        e.should have(1).connections
        e.should have(1).vertices
        e.vertices.should include(v1)
        v1.edges.should include(e)
        e << v2
        e.should have(2).connections
        e.should have(2).vertices
        e.vertices.should include(v1)
        e.vertices.should include(v2)
        v2.edges.should include(e)
      end
      
      it "adds several vertices to an edge" do
        e.connections.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        e << v1 << v2
        e.vertices.should include(v1)
        e.vertices.should include(v2)
        e.should have(2).vertices
      end

      it "adds a self-loop" do
        e.connections.should be_empty
        v1 = Vertex.new
        e << v1 << v1
        e.vertices.should include(v1)
        e.should have(2).vertices
        e.vertices.uniq.length.should == 1
      end
    end # #<<
    
    describe "connection_at" do
      it "returns the connection that links to a vertex" do
        e.connections.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        e << v1 << v2
        
        e.connection_at(v1).end.should be v1
        e.connection_at(v2).end.should be v2
      end
      
      it "returns nil if there is no connection to that vertex" do
        e.connections.should be_empty
        v1 = Vertex.new
        v2 = Vertex.new
        v3 = Vertex.new
        e << v1 << v2
        
        e.connection_at(v3).should be nil
      end
      
      it "returns the vertex for a self-loop" do
        e.connections.should be_empty
        v1 = Vertex.new
        e << v1 << v1
        
        e.connection_at(v1).end.should be v1
      end

    
    end # #connection_at
  end # Edge
  
  describe Connection do
    let (:c) {Connection.new }
    
    describe "adds attribues" do
      it "adds then reports arbitrary attributes" do
        c.score = 15
        c.score.should == 15
      end
    end # adds attributes
  end # Connection
  
end
