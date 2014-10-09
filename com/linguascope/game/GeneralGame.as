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

package com.linguascope.game 
{
	/**
	 * This class implements a standard game with external xml data loader and parser.
	 * @author Costantino Panza - costantino@linguascope.com
	 */
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GeneralGame
	{
		protected var xml_url:String;
		/**External data*/
		protected var game_xml:XML;
		
		/**Sprite where the game is rendered*/
		protected var _canvas:Sprite;
		/**Sprite where the game is rendered, add this to the stage to visualize the game.*/
		public function get canvas():Sprite
		{
			return _canvas;
		}
		
		/**Label to detected the parser to use for the xml data loaded*/
		protected var parser_type:String;
		/**Label to detected the choosen language*/
		protected var language:String;
		
		public function GeneralGame(xml_url_value:String = null, language:String = null, parser:String = null)
		{
			trace("GeneralGame instance created ...");
			
			_canvas = new Sprite();
			
			parser_type = parser;
			
			if (xml_url_value)
			{
				xml_url = xml_url_value;
			}
			
			if (xml_url)
			{
				loadXML(xml_url);
			}
			else
			{
				trace("INFO: no xml url has been passed.");
			}
			
			
		}
		
		protected function startGame():void
		{
			trace("WARNING: you should override the startGame method and use it as entry point of the game.");
		}
		
		
		protected function loadXML(url:String = null):void
		{
			trace("GeneralGame loadXML: "+url+"  ...");		
			
			if (url) xml_url = url;
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.load(new URLRequest(xml_url));
			xmlLoader.addEventListener(Event.COMPLETE, parseXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadingErrorHandler);
		}
		
		protected function parseXML(e:Event):void
		{
			trace("GeneralGame parseXML ...");
			trace("WARNING: you should override this function for parsing the xml data loaded.");
						
		}
		
		private function xmlLoadingErrorHandler(e:IOErrorEvent):void
		{
			trace("xmlLoadingErrorHandler --> the file '"+xml_url+"' can't be loaded!");
		}
		
		
	}

}