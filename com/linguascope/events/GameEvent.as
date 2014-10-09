////////////////////////////////////////////////////////////////////////////////
//
//  LINGUASCOPE
//  Copyright 2014 LINGUASCOPE
//  All Rights Reserved.
//
//  NOTICE: You may not use, distribute or modify this document without the
//  written permission of its copyright owner
//
////////////////////////////////////////////////////////////////////////////////


package com.linguascope.events 
{
	/**
	 * This class implements a standard game with external xml data loader and parser.
	 * @author Richard West-Soley - Richard@linguascope.com
	 */
	import flash.events.Event;

	public class GameEvent extends Event
	{

		public static const ANSWER_CORRECT:String = "answer correct";
		public static const ANSWER_INCORRECT:String = "answer incorrect";

		public static const GAME_LOST:String = "game lost";
		public static const GAME_WON:String = "game won";
		public static const GAME_DRAW:String = "game draw";

		public static const TIME_UP:String = "time up";
		public static const NEXT_TURN:String = "next turn";
		public static const PLAYER_CHANGED:String = "player changed";
		public static const GAME_STARTED:String = "game started";
		public static const GAME_PAUSED:String = "game paused";

		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
	
}