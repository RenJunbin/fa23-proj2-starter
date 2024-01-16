int *matmul(int *a0, int a1, int a2, \
			int *a3, int a4, int a5 \
			int *a6) {
		for (int t1=0; t1<a1; t1++) {
				int *t0 = a0 + t1 * a2;
				for (int t5=0; t5<a5; t5++) {
						int *t6 = a6 + t1 * a5 + t5;
						int *t3 = a3 + t5;
						*t6 = dot(t0, t3, a2, 1, a4);
				}
		}
		return a6;
}
