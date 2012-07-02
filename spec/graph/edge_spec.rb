require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae
  describe Edge do
    let (:e) { Edge.new }
    let(:v1) {Vertex.new :name => :v1}
    let(:v2) {Vertex.new :name => :v2}
    let(:v3) {Vertex.new :name => :v3}

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
        e << v1 << v2
        e.vertices.should include(v1)
        e.vertices.should include(v2)
        e.should have(2).vertices
      end

      it "adds a self-loop" do
        e.connections.should be_empty
        e << v1 << v1
        e.vertices.should include(v1)
        e.should have(2).vertices
        e.vertices.uniq.length.should == 1
      end
    end # #<<
    
    describe "connection_at" do
      it "returns the connection that links to a vertex" do
        e.connections.should be_empty
        e << v1 << v2
        
        e.connection_at(v1).end.should be v1
        e.connection_at(v2).end.should be v2
      end
      
      it "returns nil if there is no connection to that vertex" do
        e.connections.should be_empty
        e << v1 << v2
        
        e.connection_at(v3).should be nil
      end
      
      it "returns the vertex for a self-loop" do
        e.connections.should be_empty
        e << v1 << v1
        
        e.connection_at(v1).end.should be v1
      end
    end # #connection_at
    
    describe "other_end" do
      it "returns the vertex at the other end of the given one" do
        e.connections.should be_empty
        e << v1 << v2
        
        e.other_end(v1).should be v2
        e.other_end(v2).should be v1
      end
      
      it "returns the same vertex in a self-loop" do
        e.connections.should be_empty
        e << v1 << v1
        
        e.other_end(v1).should be v1
      end
      
      it "returns one of the connected edges if given a vertex not connected to it" do
        e.connections.should be_empty
        e << v1 << v2
        
        [v1, v2].should include e.other_end(v3)
      end 
      
      it "returns nil if it can't return something sensible" do
        e.other_end(v1).should be_nil
        e << v1
        e.other_end(v1).should be_nil
      end
    end # other_end
    
    describe "#to_dot" do
      it "describes an edge in dot notation" do
        e << v1 << v2

        e.to_dot.should == "#{v1.object_id.to_s} -- #{v2.object_id.to_s};"
      end
      
      it "describes an edge in dot notation, using given attributes" do
        e << v1 << v2
        #vdot = v1.to_dot :label => :name, :shape => :shape
        #vdot.should == "#{v.object_id.to_s} {label = \"vertex\", shape = \"house\"};"
      end

      
      it "describes an edge in dot notation, given a block" do
        e << v1 << v2

        e.to_dot {|e| e.object_id.to_s}.should == e.object_id.to_s
      end
    end # dot
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
