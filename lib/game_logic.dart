// package kr.co.naamk.util;

// import java.util.ArrayList;
// import java.util.HashMap;
// import java.util.List;
// import java.util.Map;

// public class TestPlay {
//     List<String> allUser = new ArrayList<>();
//     List<String> pairedUser = new ArrayList<>();
//     Map<String, List<String>> allUserExceptionSelf = new HashMap<>();
//     Map<String, Map<String, String>> result = new HashMap<>();

//     final String KEY_PAIR = "pair";
//     final String KEY_PWD = "pwd";

//     void settingUser(String userName) {
//         allUser.add(userName);
//     }

//     // 유저 모두 넣고 게임판 세팅
//     void readyForPlay() {
//         for(String user : allUser) {
//             List<String> list = allUser.stream()
//                     .filter(el -> !el.equals(user)).toList();
//             allUserExceptionSelf.put(user, list);
//         }
//     }

//     // 유저 이름 클릭 시
//     boolean isAlreadyPlayUser(String userName) {
//         Map<String, String> userInResult = result.get(userName);

//         return (userInResult != null);
//     }

//     // 마니또 play !
//     String play(String userName, String password) {
//         /*
//         * user : {
//         *   pwd: "",
//         *   pair: ""
//         * }
//         * */

//         // 내 게임판 가져오기
//         List<String> myBoard = getMyBoard(userName);

//         // 랜덤 추출
//         int randomIndex = (int) (Math.random() * myBoard.size());
//         String myPair = myBoard.get(randomIndex);

//         // 결과 넣기
//         Map<String, String> userVal = new HashMap<>();
//         userVal.put(KEY_PWD, password);
//         userVal.put(KEY_PAIR, myPair);
//         result.put(userName, userVal);

//         // 짝궁이 된 자는 중복 짝궁이 안되게 넣기
//         pairedUser.add(myPair);

//         return myPair;
//     }

//     // 나의 게임판 가져오기
//     List<String> getMyBoard(String userName) {
//         List<String> myBoard = allUserExceptionSelf.get(userName);

//         // 이미 짝궁이된 유저는 제외하기
//         for(String user : pairedUser) {
//             if(myBoard.contains(user)) {
//                 myBoard.remove(user);
//             }
//         }

//         return myBoard;
//     }


//     // 참여한 유저의 경우 비밀번호 입력 후 짝궁 보기
//     String showMyPair(String userName, String password) {
//         String myPairUser = "누구냐 너 !!!";
//         Map<String, String> val = result.get(userName);

//         if(val.get(KEY_PWD).equals(password)) {
//             myPairUser = val.get(KEY_PAIR);
//         }

//         return myPairUser;
//     }
// }
