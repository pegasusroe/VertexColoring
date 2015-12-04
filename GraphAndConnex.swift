import Foundation

// 節點連結
public struct Connex: Hashable, CustomStringConvertible {
  
  let nodes: Set<Int>
  
  public init?(node1: Int, node2: Int) {
    
    if node1 == node2 { return nil }
    
    var nodes = Set<Int>()
    nodes.insert(node1)
    nodes.insert(node2)
    
    self.nodes = nodes
  }
  
  public func replace(oldNode: Int, with newNode: Int) -> Connex {
    assert(self.nodes.count == 2, "connex.replace(with:) - nodes.count != 2")
    var nodes = self.nodes
    var node1 = nodes.removeFirst()
    var node2 = nodes.removeFirst()
    node1 = (oldNode == node1) ? newNode : node1
    node2 = (oldNode == node2) ? newNode : node2
    return Connex(node1: node1, node2: node2)!
  }
  
  // Hashable protocol
  public var hashValue: Int {
    var hash = 0
    
    for node in nodes {
      hash ^= node.hashValue
    }
    
    return hash
  }
  
  // CustomStringConvertible
  public var description: String {
    
    return self.nodes.description
    
  }
  
}


// Equatable protocol
public func ==(c1: Connex, c2: Connex) -> Bool {
  return c1.nodes == c2.nodes
}

// 節點圖 --------------------------------------------
public struct Graph {
  
  // 節點
  public let nodes: Set<Int>
  
  // 節點間的相鄰連結
  public let connections: Set<Connex>
  
  
  // 移除一個連結後的兩個子圖
  public func subgraphsByRemovingFirstConnection() -> (graph1: Graph, graph2: Graph) {
    
    assert(!self.connections.isEmpty, "Graph has no connections to remove.")
    
    // 抓出第一個連結
    let con = self.connections.first!
    var conNodes = con.nodes
    let nodeToRemove = conNodes.removeFirst()
    let nodeToStay = conNodes.removeFirst()
    
    var nodes = self.nodes
    var cons = self.connections
    
    // 產生去掉第一個連結的子圖
    cons.remove(con)
    let graph1 = Graph(nodes: nodes, connections: cons)
    
    // 產生去掉一個節點的子圖
    nodes.remove(nodeToRemove)
    var cons2 = Set<Connex>()
    
    for c in cons {
      let conReplaced = c.replace(nodeToRemove, with: nodeToStay)
      cons2.insert(conReplaced)
    }
    
    let graph2 = Graph(nodes: nodes, connections: cons2)
    
    return(graph1, graph2)
  }
  
  // 計算塗色問題的方法數
  public func vertexColoring(colors k: Int) -> Int {
    
    let n = nodes.count
    
    if connections.count == 0 { return Int(k^^n) }
    
    let (g1, g2) = self.subgraphsByRemovingFirstConnection()
    
    return g1.vertexColoring(colors: k) - g2.vertexColoring(colors: k)
  }
  
}

extension Graph {
  
  public init(pairs: [(Int, Int)]) {
    
    // 準備要加入的節點與連結
    var nodes = Set<Int>()
    var cons = Set<Connex>()
    
    for con in pairs {
      
      // 略過兩個節點相同的連結
      if con.0 == con.1 { continue }
      
      // 如果連結中的節點是新的，就加入節點集合
      if !nodes.contains(con.0) { nodes.insert(con.0) }
      if !nodes.contains(con.1) { nodes.insert(con.1) }
      
      // 加入新的連結
      cons.insert(Connex(node1: con.0, node2: con.1)!)
    }
    
    // 完成初始化設定
    self.nodes = nodes
    self.connections = cons
  }
  
}
