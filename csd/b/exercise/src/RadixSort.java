public class RadixSort {
    public static void sort(Pupil[] arr) {
        int maxMark = getMaxMark(arr);
        for (int exp = 1; maxMark / exp > 0; exp *= 10) {
            countSort(arr, exp);
        }
    }

    private static int getMaxMark(Pupil[] arr) {
        int max = arr[0].mark;
        for (Pupil pupil : arr) {
            if (pupil.mark > max) {
                max = pupil.mark;
            }
        }
        return max;
    }

    private static void countSort(Pupil[] arr, int exp) {
        int n = arr.length;
        Pupil[] output = new Pupil[n];
        int[] count = new int[10];

        // Initialize count array
        for (int i = 0; i < 10; i++) {
            count[i] = 0;
        }

        // Store count of occurrences
        for (int i = 0; i < n; i++) {
            count[(arr[i].mark / exp) % 10]++;
        }

        // Change count[i] to store actual position
        for (int i = 1; i < 10; i++) {
            count[i] += count[i - 1];
        }

        // Build the output array
        for (int i = n - 1; i >= 0; i--) {
            output[count[(arr[i].mark / exp) % 10] - 1] = arr[i];
            count[(arr[i].mark / exp) % 10]--;
        }

        // Copy to original array
        for (int i = 0; i < n; i++) {
            arr[i] = output[i];
        }
    }
}
