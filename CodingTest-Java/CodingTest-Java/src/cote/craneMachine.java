package cote;

import java.util.Stack;

public class craneMachine {
	static int board[][] = { { 0, 0, 0, 0, 0 }, { 0, 0, 1, 0, 3 }, { 0, 2, 5, 0, 1 }, { 4, 2, 4, 4, 2 },
			{ 3, 5, 1, 3, 1 } };
	static int moves[] = { 1, 5, 3, 5, 1, 2, 1, 4 };

	public static int solution(int[][] board, int[] moves) {
		Stack<Integer> stack = new Stack<>();
		int answer = 0;
		for (int m = 0; m < moves.length; m++) {
			for (int b = 0; b < board.length; b++) {
				if (board[b][moves[m] - 1] != 0) {
					stack.push(board[b][moves[m] - 1]);
					board[b][moves[m] - 1] = 0;

					if (stack.size() > 1) {
						int stack1 = 0;
						int stack2 = 0;
						stack1 = stack.pop();
						stack2 = stack.peek();
						if (stack1 == stack2) {
							stack.pop();
							answer += 2;
						} else {
							stack.push(stack1);
						}
					}
					break;
				}
			}
		}
		return answer;
	}
}