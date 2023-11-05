public class Main {
    public static void main(String[] args) {
        BST tree = new BST();
        Pupil[] pupils = {
                new Pupil(5, 5),
                new Pupil(3, 3),
                new Pupil(2, 2),
                new Pupil(4, 44),
                new Pupil(7, 47),
                new Pupil(6, 100),
                new Pupil(8, 88),
                new Pupil(1, 11),
                new Pupil(9, 99)
        };

        for (Pupil pupil : pupils) {
            tree.insert(pupil);
        }

        tree.determineLevels();
        System.out.println("Is AVL: " + tree.isAVL());
        System.out.println("Pre-order traversal:");
        tree.preorderLoop();

        System.out.println("\nDecreasing marks:");
        tree.decreaseMarks();
        tree.preorderLoop();

        System.out.println("\nSorted Pupils by mark using RadixSort:");
        RadixSort.sort(pupils);
        for (Pupil pupil : pupils) {
            System.out.println("Rollno: " + pupil.rollno + ", Mark: " + pupil.mark);
        }
    }
}