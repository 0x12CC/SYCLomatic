// UNSUPPORTED: cuda-8.0, cuda-9.0, cuda-9.1, cuda-9.2, cuda-10.0, cuda-10.1, cuda-10.2, cuda-11.0, cuda-11.2, cuda-11.4
// UNSUPPORTED: v8.0, v9.0, v9.1, v9.2, v10.0, v10.1, v10.2, v11.0, v11.2, v11.4
// RUN: dpct --format-range=none -in-root %S -out-root %T/devicelevel/device_segmented_radix_sort %S/device_segmented_radix_sort.cu --cuda-include-path="%cuda-path/include" -- -std=c++14 -x cuda --cuda-host-only
// RUN: FileCheck --input-file %T/devicelevel/device_segmented_radix_sort/device_segmented_radix_sort.dp.cpp %s

// CHECK:#include <oneapi/dpl/execution>
// CHECK:#include <oneapi/dpl/algorithm>
// CHECK:#include <dpct/dpl_utils.hpp>
#include <cub/cub.cuh>

int n, num_segments, *d_keys_in, *d_keys_out, *d_values_in, *d_values_out, *d_offsets;

// CHECK:dpct::io_iterator_pair<int *> d_keys(d_keys_in, d_keys_out), d_values(d_values_in, d_values_out);
cub::DoubleBuffer<int> d_keys(d_keys_in, d_keys_out), d_values(d_values_in, d_values_out);

void test1(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1);
// CHECK: void test1(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, false);
}

void test2(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1);
// CHECK: void test2(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, false, 1);
}

void test3(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
// CHECK: void test3(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, false, 1, 4);
}

void test4(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cudaStream_t s = 0;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
// CHECK: void test4(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: dpct::queue_ptr s = &q_ct1;
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(*s), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, false, 1, 4);
}

void test5(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1);
// CHECK: void test5(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, true);
}

void test6(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1);
// CHECK: void test6(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, true, 1);
}

void test7(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
// CHECK: void test7(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, true, 1, 4);
}

void test8(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cudaStream_t s = 0;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
// CHECK: void test8(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: dpct::queue_ptr s = &q_ct1;
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(*s), d_keys_in, d_keys_out, d_values_in, d_values_out, n, num_segments, d_offsets, d_offsets + 1, true, 1, 4);
}

void test9(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1);
// CHECK: void test9(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, false, true);
}

void test10(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1);
// CHECK: void test10(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, false, true, 1);
}

void test11(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
// CHECK: void test11(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, false, true, 1, 4);
}

void test12(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cudaStream_t s = 0;
  cub::DeviceSegmentedRadixSort::SortPairs(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairs(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
// CHECK: void test12(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: dpct::queue_ptr s = &q_ct1;
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(*s), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, false, true, 1, 4);
}

void test13(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1);
// CHECK: void test13(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, true, true);
}

void test14(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1);
// CHECK: void test14(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, true, true, 1);
}

void test15(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4);
// CHECK: void test15(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(q_ct1), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, true, true, 1, 4);
}

void test16(void) {
  void *temp_storage;
  size_t temp_storage_size;
  cudaStream_t s = 0;
  cub::DeviceSegmentedRadixSort::SortPairsDescending(nullptr, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
  cudaMalloc(&temp_storage, temp_storage_size);
  cub::DeviceSegmentedRadixSort::SortPairsDescending(temp_storage, temp_storage_size, d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, 1, 4, s);
// CHECK: void test16(void)
// CHECK-NOT: void *temp_storage;
// CHECK-NOT: size_t temp_storage_size;
// CHECK-NOT: cudaMalloc(&temp_storage, temp_storage_size);
// CHECK: dpct::queue_ptr s = &q_ct1;
// CHECK: DPCT1026:{{.*}}
// CHECK: dpct::segmented_sort_pairs(oneapi::dpl::execution::device_policy(*s), d_keys, d_values, n, num_segments, d_offsets, d_offsets + 1, true, true, 1, 4);
}
