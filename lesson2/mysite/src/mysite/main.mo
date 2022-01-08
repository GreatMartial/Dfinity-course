import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Array "mo:base/Array"

actor Quicksort {
    public  func qsort(arr: [Int]): async [Int] {
        var mutArr: [var Int] = Array.thaw(arr); 
        let left: Int = 0;
        let right: Int = arr.size() - 1;
        quickSort(mutArr, left, right);
        Array.freeze(mutArr);
    };

    func quickSort(arr: [var Int], left: Int, right: Int) {
        var pivot = arr[Int.abs(left)];
        var low = left;
        var high = right;
        var swap = arr[0];

        while (low <= high) {
            while (arr[Int.abs(high)] > pivot) {
                high -= 1;
            };
            while (arr[Int.abs(low)] < pivot) {
                low += 1;
            };
            if (low <= high) {
                swap := arr[Int.abs(low)];
                arr[Int.abs(low)] := arr[Int.abs(high)];
                arr[Int.abs(high)] := swap;
                low += 1;
                high -= 1;
            };    
        };
        if (low < right) {
            quickSort(arr, low, right);
        };
        if (left < high) {
            quickSort(arr, left, high);
        };
    };
};

/*
    func qsort(arr: [Int]): [Int] {
        var mutArr: [var Int] = Array.thaw(arr); 
        let left: Int = 0;
        let right: Int = arr.size() - 1;
        quickSort(mutArr, left, right);
        Array.freeze(mutArr);
    };

    func quickSort(arr: [var Int], left: Int, right: Int) {
        var pivot = arr[Int.abs(left)];
        var low = left;
        var high = right;
        var swap = arr[0];

        while (low <= high) {
            while (arr[Int.abs(high)] > pivot) {
                high -= 1;
            };
            while (arr[Int.abs(low)] < pivot) {
                low += 1;
            };
            if (low <= high) {
                swap := arr[Int.abs(low)];
                arr[Int.abs(low)] := arr[Int.abs(high)];
                arr[Int.abs(high)] := swap;
                low += 1;
                high -= 1;
            };    
        };
        if (low < right) {
            quickSort(arr, low, right);
        };
        if (left < high) {
            quickSort(arr, left, high);
        };
    };

var arr: [Int] = [10,4,2,1,5,6,3,9,7,8];
Debug.print("src:" # debug_show(arr));
Debug.print("target:" # debug_show(qsort(arr)));
*/