package cote;

import java.util.ArrayList;
import java.util.HashMap;

//getOrDefault
//default V getOrDefault(Object key, V defaultValue)
//찾는 키가 존재한다면 찾는 키의 값을 반환하고 없다면 기본 값을 반환한다.
public class incompleteAthlete {
	static String participant[] = { "mislav", "stanko", "mislav", "ana" };
	static String completion[] = { "stanko", "ana", "mislav" };

	public static String solution(String[] participant, String[] completion) {
		String answer = "";
		HashMap<String, Integer> hm = new HashMap<>();
		for (String player : participant) {
			hm.put(player, hm.getOrDefault(player, 0) + 1);
		}
		for (String player : completion) {
			hm.put(player, hm.get(player) - 1);
		}

		for (String key : hm.keySet()) {
			if (hm.get(key) != 0) {
				answer = key;
			}
		}
		return answer;
	}

	public static String solution2(String[] participant, String[] completion) {
		String answer = "";

		ArrayList<String> c = new ArrayList<String>();
		for (int i = 0; i < completion.length; i++) {
			c.add(completion[i]);
		}

		for (int i = 0; i < participant.length; i++) {

			if (c.contains(participant[i])) {
				c.remove(participant[i]);
			} else {
				answer = participant[i];
			}

		}
		System.out.println(answer);
		return answer;
	}
}
