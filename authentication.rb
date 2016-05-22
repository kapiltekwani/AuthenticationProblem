class Graph
  def initialize(vertices_count)
    @number_of_vertices = vertices_count
    @adjacent_list = Array.new(vertices_count){Array.new}
    @indegree = Array.new(vertices_count, 0)
    @visited = Array.new(vertices_count, false)
  end

  def number_of_vertices
    @number_of_vertices
  end

  def visited(i)
    @visited[i]
  end

  def adjacent_list(i)
    @adjacent_list[i]
  end

  def indegree(i)
    @indegree[i]
  end

  #Method to add new-edge to the graph
  def add_edge(source_vertex, destination_vertex)
    @adjacent_list[source_vertex].push(destination_vertex)
    @indegree[destination_vertex] += 1
  end

  #Method for DFS traversal of Graph
  def dfs_traversal(source_vertex)

    @visited[source_vertex] = true;

    @adjacent_list[source_vertex].each do |i|
      dfs_traversal(i) if !@visited[i]
    end

  end

  #Method to get transpose of given graph
  def get_transpose()
    transpose_graph = Graph.new(26)

    for i in 0..@number_of_vertices -1 do
      @adjacent_list[i].each do |x|
        transpose_graph.add_edge(x, i)
      end
    end

    transpose_graph
  end

  #Method to validate a given sequence of Strings
  def authenticated?()

    odd_degree_count = 0;

    for i in 0..@number_of_vertices-1 do
      if @adjacent_list[i].length != @indegree[i]
        odd_degree_count += 1
      end
    end

    return false if(odd_degree_count!= 0 && odd_degree_count!= 2)

    (odd_degree_count == 0 && self.is_eulerian_circuit?) || (odd_degree_count ==2 && self.is_eulerian_path?)
  end

  #Method to check whether DFS traversal visites all the non-zero degree vertices of not
  def traverse_graph
    for i in 0..@number_of_vertices-1 do
      if @adjacent_list[i].length > 0 && @adjacent_list[i].length > @indegree[i]
        break
      end
    end

    return true if (i == @number_of_vertices)

    dfs_traversal(i);

    for i in 0..@number_of_vertices-1
      if (@visited[i] == false && @adjacent_list[i].length > 0)
        return false
      end
    end
  end

  #Method to check if given graph contains an Eulerian path
  def is_eulerian_path?

    if self.traverse_graph == false
      return false
    end

    transpose = self.get_transpose()

   if transpose.traverse_graph == false
     return false
   end

    return true;
  end

  #Method to check if given graph contains an Eulerian Circuit
  def is_eulerian_circuit?
    for i in 0..@number_of_vertices-1 do
      if @adjacent_list[i].length > 0
        break
      end
    end

    return true if (i == @number_of_vertices)

    dfs_traversal(i);

    for j in 0..@number_of_vertices-1
      if (@visited[j] == false && @adjacent_list[j].length > 0)
        return false
      end
    end

    transpose = self.get_transpose()

    transpose.dfs_traversal(i);

    for i in 0..transpose.number_of_vertices-1
      if (transpose.visited(i) == false && transpose.adjacent_list(i).length > 0)
        return false
      end
    end

    return true;
  end

  #Method to print graph in Adjacency Format along with indegrees for all vertices of Given Graph
  def print_graph()
   puts "Adjacency Matrix"
   @adjacent_list.each_with_index {|value, index| puts "#{index} #{value} \n" }

   puts "Indegree Matrix"
   @indegree.each_with_index {|value, index| puts "#{index} #{value} \n" }
  end

end

# Example of Graph with Eulerian path(All Vertices with even degree and exactly two vertices with odd degree)
example1 = ["Goibibio", "Top", "People", "eat", "Orange"].collect!(&:downcase)

# Example of Graph with Eulerian circuit(All Vertices with even degree and one connectec component)
example2 = ["Cat", "Tigers", "Snake", "Elephantc"].collect!(&:downcase)

#Example of random graph
example3 = ["aab", "abb", "abc"]


example1_graph = Graph.new(26)

example1.each { |word| example1_graph.add_edge(word[0].ord - 97, word[-1].ord - 97)}

example2_graph = Graph.new(26)

example2.each { |word| example1_graph.add_edge(word[0].ord - 97, word[-1].ord - 97)}

example3_graph = Graph.new(26)

example3.each { |word| example3_graph.add_edge(word[0].ord - 97, word[-1].ord - 97)}


if example1_graph.authenticated?
  puts "Person1 with passcode #{example1} - Authentication Successful"
else
  puts "Person1 with passcode #{example1} - Authentication Failed"
end

if example2_graph.authenticated?
  puts "Person1 with passcode #{example2} - Authentication Successful"
else
  puts "Person1 with passcode #{example2} - Authentication Failed"
end

if example3_graph.authenticated?
  puts "Person1 with passcode #{example3} - Authentication Successful"
else
  puts "Person1 with passcode #{example3} - Authentication Failed"
end