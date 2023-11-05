public class Node {
    Pupil data;
    Node left;
    Node right;
    int level;

    public Node(Pupil data) {
        this.data = data;
        this.left = null;
        this.right = null;
        this.level = -1; // Will be updated later
    }
}
