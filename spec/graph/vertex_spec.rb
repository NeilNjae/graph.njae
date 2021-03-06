require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module GraphNjae
  describe Vertex do
    let (:v) { Vertex.new }
    
    describe '#initialize' do
      it 'creates an empty vertex' do
        v = Vertex.new
        v.edges.should be_empty
      end
      
      it 'creates a vertex with some parameters' do
        v = Vertex.new :value1 => 1, :value2 => 'value2', :value3 => :v3
        v.value1.should == 1
        v.value2.should == 'value2'
        v.value3.should == :v3
        v.value4.should be_nil
      end
    end # #initialize
    
    describe 'adds attribues' do
      it 'adds then reports arbitrary attributes' do
        v.score = 15
        v.score.should == 15
      end
    end # adds attributes

    describe "#to_s" do
      it "returns the string form of a vertex" do
        v.name = :v1
        v.to_s.should == '<V: v1>'
      end
    end

    
    describe '#<<' do
      it 'adds a single edge between vertices' do
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

      it 'adds a single edge as a self-loop' do
        v.neighbours.should be_empty
        v.edges.should be_empty
        
        v << v
        
        v.should have(1).edges
        v.should have(1).neighbours
        v.neighbours.should include(v)
      end
    end # #<<
    
    describe 'connect' do
      it 'connects two vertices' do
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

      it 'connects two vertices by an edge with attributes' do
        v1 = Vertex.new
        v1.id = :v1
        e = v.connect(v1, {:type => :edge_type})
        e.type.should == :edge_type
      end
      
      it 'creates a self-connection' do
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

      it 'creates a self-connection with an edge with attributes' do
        e = v.connect(v, {:type => :edge_type})
        e.type.should == :edge_type
      end

    end # #connect
    
    describe '#neighbours' do
      it 'finds neighbours of a self loop' do
        v << v
        v.should have(1).neighbours
        v.neighbours.should include v
      end
      
      it 'finds neighbours on an edge' do
        v1 = Vertex.new
        v << v1
        v.should have(1).neighbours
        v.neighbours.should include v1
        v1.should have(1).neighbours
        v1.neighbours.should include v
      end
      
      it 'finds neighbours with multiple edges' do
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
      
      it 'finds neighbours with multiple self loops' do
        v << v << v << v
        v.should have(3).neighbours
        v.neighbours.should include v
        v.neighbours.uniq.length.should == 1
      end
      
      it 'finds neighbours with all sorts of edges' do
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
      
      it 'finds neighbours in graphs with several vertices' do
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
      
      it 'finds neighbours with multiple edges between vertices' do
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
    
    describe '#to_dot' do
      it 'describes a vertex in dot notation' do
        v = Vertex.new
        v.to_dot.should == "#{v.object_id.to_s};"
      end

      it 'describes a vertex in dot notation, using given attributes' do
        v = Vertex.new
        v.name = 'vertex'
        v.shape = 'house'
        vdot = v.to_dot :label => :name, :shape => :shape
        vdot.should == "#{v.object_id.to_s} {label = \"#{v.name}\", shape = \"#{v.shape}\"};"
      end
      
      it 'describes a vertex using a block' do
        v = Vertex.new
        v.field1 = 'f1'
        vdot = v.to_dot {|v| v.field1 + ';'}
        vdot.should == "#{v.field1};"
      end
    end # #to_dot
  end
end
