import java.util.Stack;

public class BST {
    Node root;

    public BST() {
        root = null;
    }

    public void insert(Pupil pupil) {
        root = insertRec(root, pupil);
    }

    private Node insertRec(Node root, Pupil pupil) {
        if (root == null) {
            return new Node(pupil);
        }

        if (pupil.rollno < root.data.rollno) {
            root.left = insertRec(root.left, pupil);
        } else if (pupil.rollno > root.data.rollno) {
            root.right = insertRec(root.right, pupil);
        }

        return root;
    }

    // Helper function to find the minimum mark in the tree
    private int findMinMark(Node root) {
        if (root == null) {
            return Integer.MAX_VALUE;
        }
        int lMin = findMinMark(root.left);
        int rMin = findMinMark(root.right);
        return Math.min(root.data.mark, Math.min(lMin, rMin));
    }

    // Decrease m/2.0 from each pupil's mark
    public void decreaseMarks() {
        int m = findMinMark(root);
        decreaseMarksRec(root, m/2);
    }

    private void decreaseMarksRec(Node root, int value) {
        if (root != null) {
            root.data.mark -= value;
            decreaseMarksRec(root.left, value);
            decreaseMarksRec(root.right, value);
        }
    }

    // Determine the level for all nodes
    public void determineLevels() {
        determineLevelsRec(root, 0);
    }

    private void determineLevelsRec(Node root, int level) {
        if (root != null) {
            root.level = level;
            determineLevelsRec(root.left, level + 1);
            determineLevelsRec(root.right, level + 1);
        }
    }

    // Helper function to determine height for AVL check
    private int height(Node root) {
        if (root == null) {
            return 0;
        }
        return 1 + Math.max(height(root.left), height(root.right));
    }

    // Check if AVL tree
    public boolean isAVL() {
        return isAVLRec(root);
    }

    private boolean isAVLRec(Node root) {
        if (root == null) {
            return true;
        }
        int balance = height(root.left) - height(root.right);
        return Math.abs(balance) <= 1 && isAVLRec(root.left) && isAVLRec(root.right);
    }

    // Pre-order traversal with a loop
    public void preorderLoop() {
        Stack<Node> stack = new Stack<>();
        if (root != null) {
            stack.push(root);
        }
        while (!stack.isEmpty()) {
            Node current = stack.pop();
            System.out.println("Rollno: " + current.data.rollno + ", Mark: " + current.data.mark);
            if (current.right != null) {
                stack.push(current.right);
            }
            if (current.left != null) {
                stack.push(current.left);
            }
        }
    }

}
