// 測試碼

// 相鄰的區域
let pairs = [ (1,2), (2,3), (3,4), (4,1) ]

// 顏色數
let k = 5

let g = Graph(pairs: pairs)
g.nodes                       // {1, 2, 3, 4}
g.vertexColoring(colors: k)   // 260

let (g1, g2) = g.subgraphsByRemovingFirstConnection()

g1.nodes                      // {1, 2, 3, 4}
g1.connections.description    // [3, 4], [2, 1], [2, 3]
g1.vertexColoring(colors: k)  // 320

g2.nodes                      // {1, 2, 3}
g2.connections.description    // [3, 1], [2, 1], [2, 3]
g2.vertexColoring(colors: k)  // 60
