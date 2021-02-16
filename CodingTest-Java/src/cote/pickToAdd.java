package cote;

import java.util.TreeSet;

public class pickToAdd {
	public static int[] numbers = { 2, 1, 3, 4, 1 };

	public static int[] solution(int[] numbers) {

		TreeSet<Integer> answers = new TreeSet<Integer>();
		// TreeSet 자동정렬, 중복불가
		for (int n = 0; n < numbers.length - 1; n++) {
			for (int nn = n + 1; nn < numbers.length; nn++) {
				answers.add(numbers[n] + numbers[nn]);
			}
		}

		Object[] answer2 = answers.toArray();
		// toArray() 저장된 객체들을 객체배열의 형태로 변환
		int[] intArray = new int[answer2.length];
		for (int i = 0; i < answer2.length; i++) {
			intArray[i] = (int) answer2[i];
		}
		System.out.println(intArray);
		return intArray;
	}

	public static int[] solution2() {
		int[] numbers = { 2, 1, 3, 4, 1 };

		TreeSet<Integer> answers = new TreeSet<Integer>();

		for (int n = 0; n < numbers.length - 1; n++) {
			for (int nn = n + 1; nn < numbers.length; nn++) {
				answers.add(numbers[n] + numbers[nn]);
			}
		}

		int[] answer = answers.stream().mapToInt(Integer::intValue).toArray();

		return answer;
	}
}
