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
	 * This class implements a standard Fill The Gap game with combo boxes.
	 * @author Costantino Panza - costantino@linguascope.com
	 */
	
	import fl.controls.ComboBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FillTheGapGame extends GeneralGame
	{
		public static const COMBO_PARSER_TYPE:String = "combo";
		
		/**
		 * contains all the sentences loaded from the xml and parsed. Gaps are represented by the "*" chars.
		 */
		protected var sentences:Array = [];
		/**
		 * contains all the alternative answers for each gap. The alternatives are separated by the "-" char.
		 */
		protected var gap_alternatives:Array = [];
		/**
		 * contains all the solutions for each gap.
		 */
		protected var solutions:Array = [];
		/**
		 * index of the current sentence displayed when showCurrentRound() is called.
		 */
		protected var current_round:int = 0;
		/**
		 * contains all the ComboBox instances for each gap.
		 */
		protected var combo_array:Array = [];
		/**
		 * height of the ComboBox instances.
		 */
		protected var combo_height:Number = 30;
		/**
		 * textfield where the function showCurrentRound() will render the sentence.
		 */
		protected var sentence_text:TextField;
		
		private var single_char_combo_width:Number;
		private var combo_textformat:TextFormat = new TextFormat(null, 16,null,null,null,null,null,null,"center");
		
		/**
		 * Sprite where the function showCurrentRound() will render the "sentence_text" with ComboBox instaces.
		 */
		protected var sentence_window:Sprite;
		
		
		public function FillTheGapGame(xml_url:String = null, language:String = null, parser:String = null) 
		{
			trace("FillTheGapGame instance created ...");			
			super(xml_url);
			
	
			if (parser == null)
			{
				parser_type = COMBO_PARSER_TYPE;
			}
			else
			{
				parser_type = parser;
			}
			
			
			sentence_window = new Sprite();
			
			sentence_text = new TextField();
			sentence_text.wordWrap = true;
			sentence_text.width = 500;
			sentence_text.height  = 200;
			sentence_text.border = true;
			var sentece_texformat:TextFormat = new TextFormat(null, 18);
			sentece_texformat.leading = 20;
			sentence_text.defaultTextFormat  = sentece_texformat;
			
			sentence_window.addChild(sentence_text);
			
			setComboBoxesStyle();
		}

		override protected function parseXML(e:Event):void
		{
			
			trace("\n_ _ _ _ _ _ _ _ _ _ _ _ _  parseXML: " + xml_url);
						
			game_xml = new XML(e.target.data);
			
			sentences = [];
			solutions = [];
			
			switch(parser_type)
			{
				case COMBO_PARSER_TYPE:
					var roundsNumber:uint = game_xml.game.round.length();
					for (var i:int = 0; i < roundsNumber; i++)
					{
						//game_xml.game.round[i].@id;
						//game_xml.game.round[i].@name;
						
						sentences[i] = game_xml.game.round[i].sentence;
						solutions[i] = game_xml.game.round[i].solution;
						//trace("sentence["+i+"] = " + sentences[i]);
						//trace("solution[" + i + "] = " + solutions[i]);
						parseRoundData(i);
					}
					break;
			}
			
			
			trace("_ _ _ _ _ _ _ _ _ _ _ _ _  success\n");
			
			startGame();
		
		}
		
		
		
		private function parseRoundData(round:int):void
		{			
			gap_alternatives[round] = new Array();
			
			var current_sentence:String = sentences[round];
			var filtered_sentence:String = "";
			var curr_char:String;
			var gap_found:Boolean = false;
			var start_index:int;
			var end_index:int;
			for (var i:int = 0; i < current_sentence.length; i++)
			{
				curr_char = current_sentence.charAt(i);
				
				if (gap_found)
				{
					if (curr_char == "*")
					{
						end_index = i;
						gap_found = false;
						gap_alternatives[round].push(current_sentence.substring(start_index + 1, end_index));
					}
				}
				else
				{
					if (curr_char == "*")
					{
						start_index = i;
						gap_found = true;
					}
					
					filtered_sentence += curr_char;
				}
			}
			
			
			sentences[round] = filtered_sentence;
			
			trace("gap_alternatives["+round+"]: "+gap_alternatives[round]);
			trace("sentences["+round+"]: " + sentences[round]);
						
		}
		

		 /**
		  *  Set the ComboBox instances style.
		  * @param	textFormat textFormat of the text in the boxes.
		  * @param	height height of the combo boxes.
		  */
		public function setComboBoxesStyle(textFormat:TextFormat = null, height:Number = 0):void
		{
			if (textFormat)
			{
				combo_textformat = textFormat;
				combo_textformat.align = "center";
			}
			
			if(height > 0) combo_height = height;
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = combo_textformat;
			tf.text = "A";
			
			single_char_combo_width = tf.textWidth;
		}
		
		/**
		 * Will render the game round with index "current_round" in the sentence_window.
		 */
		public function showCurrentRound():void
		{
			
			trace("_________________________________________showCurrentRound: "+current_round);

			_canvas.addChild(sentence_window);
			
			var curr_sentence:String = sentences[current_round];
			var alternatives:Array = gap_alternatives[current_round];

			var curr_alternatives:Array ;
			var max_alt_lenght:int = 0;
			var max_text_lenght:Number = 0;
			var i:int;
			var j:int;
			var curr_combo:ComboBox;
			for (i = 0; i < alternatives.length; i++)
			{
				curr_combo = new ComboBox();
				curr_alternatives = (alternatives[i] as String).split("/");
				
				trace("curr_alternatives: "+curr_alternatives);
				
				for (j = 0; j < curr_alternatives.length; j++)
				{
					curr_combo.addItem( { value: curr_alternatives[j], label: curr_alternatives[j] } );
					max_alt_lenght = Math.max((curr_alternatives[j] as String).length, max_alt_lenght);
				}
				combo_array[i] = curr_combo;
				curr_combo.dropdown.setRendererStyle("textFormat", combo_textformat);
				curr_combo.textField.setStyle("textFormat", combo_textformat);
				curr_combo.width = max_alt_lenght * single_char_combo_width + 30;
				curr_combo.height = combo_height;
				sentence_window.addChild(curr_combo);
			}
			
			var gap_chars:String = " *";
			for (i = 0; i < max_alt_lenght + 8; i++)
			{
				gap_chars += " ";
			}
			
			gap_chars += " ";
			
			trace("max_alt_lenght: " + max_alt_lenght);
			
			curr_sentence = curr_sentence.replace(/\*/g, gap_chars);
			sentence_text.text = curr_sentence;
			
			//positioning comboboxes
			var combo_index:int = 0;
			for (var index:int = 0; index < sentence_text.text.length; index++)
			{
				if (sentence_text.text.charAt(index) == "*")
				{
					combo_array[combo_index].x  = sentence_text.getCharBoundaries(index).x;
					combo_array[combo_index].y  = sentence_text.getCharBoundaries(index).y;
					combo_index++;
				}
			}
			
			sentence_text.text = sentence_text.text.replace(/\*/g, " ");
		}
		
		private function disposeRound():void
		{
			var curr_combo:ComboBox;
			for (var i:int = 0; i < combo_array.length; i++)
			{
				curr_combo = combo_array[i];
				//curr_combo.removeEventListener(Event.SELECT, onComboBoxSelection);
			}
		}

		
	}

}