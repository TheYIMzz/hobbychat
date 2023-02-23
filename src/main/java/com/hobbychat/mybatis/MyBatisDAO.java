package com.hobbychat.mybatis;

import java.util.ArrayList;
import java.util.HashMap;

import com.hobbychat.vo.HcChatRoom_List;
import com.hobbychat.vo.HcChatRoom_VO;
import com.hobbychat.vo.HcMsg_VO;
import com.hobbychat.vo.HcUser_VO;


public interface MyBatisDAO {


// < Home 페이지 >

	// userVO 조회
	HcUser_VO selectUser(String userId);

	// 참여중인 채팅방 리스트 조회
	ArrayList<HcChatRoom_VO> selectRoomListByUserId(String userId);

	// 채팅방VO 조회
	HcChatRoom_VO selectRoom(String roomId);

	// 채팅방의 새메세지 개수 조회
	int selectCountNewMsg(HashMap<String, String> hmap);



// < 방검색 페이지 >

	int selectCountChatRoomList_rName(String item);
	int selectCountChatRoomList_rTag(String item);

	ArrayList<HcChatRoom_VO> selectChatRoomListByRName(HcChatRoom_List chatRoomList);
	ArrayList<HcChatRoom_VO> selectChatRoomListByRTag(HcChatRoom_List chatRoomList);

	// < 방 입장 >
	void updateRoomUser(HashMap<String, String> hmap);


// < 채팅방 페이지 >

	// 채팅방의 대화 목록 조회
	ArrayList<HcMsg_VO> selectMsgList(String roomId);

	// 새메세지(안읽은 메세지) -> 읽은 메세지로 변경
	void updateMsgUnread(HashMap<String, String> hmap);

	// 메세지 전송 시, DB에 insert
	void insertMsg(HcMsg_VO msgVO);



// < 마이페이지 >

	// 유저 수정하기
	void updateUser(HcUser_VO hcUser_VO);















}
