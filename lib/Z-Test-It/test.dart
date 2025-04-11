class FriendCircles {
  late DisjointSet ds;

  FriendCircles(int n) {
    ds = DisjointSet(n);
  }

  void becomeFriends(int a, int b) {
    ds.union(a, b);
  }

  bool areFriends(int a, int b) {
    return ds.connected(a, b);
  }
}

class DisjointSet {
  List<int> parent;
  List<int> rank;

  DisjointSet(int size)
    : parent = List.generate(size, (i) => i),
      rank = List.filled(size, 0);

  int find(int x) {
    if (parent[x] != x) {
      parent[x] = find(parent[x]);
    }
    return parent[x];
  }

  void union(int x, int y) {
    int rootX = find(x);
    int rootY = find(y);
    if (rootX == rootY) return;

    if (rank[rootX] < rank[rootY]) {
      parent[rootX] = rootY;
    } else if (rank[rootX] > rank[rootY]) {
      parent[rootY] = rootX;
    } else {
      parent[rootY] = rootX;
      rank[rootX]++;
    }
  }

  bool connected(int x, int y) => find(x) == find(y);
}

void main() {
  var camp = FriendCircles(5); // 5 campers

  camp.becomeFriends(0, 1); // Alice & Bob
  camp.becomeFriends(1, 2); // Bob & Charlie

  print(camp.areFriends(0, 2)); // true (Alice & Charlie)
  print(camp.areFriends(0, 3)); // false (Alice & David)

  camp.becomeFriends(3, 4); // David & Emma
  print(camp.areFriends(3, 4)); // true
}
