
(*
 * test.sml
 *   Tests for TermAnsi.
 *
 * This file is part of TermAnsi.
 * 
 * Copyright (c) 2004 Michael Imamura <zoogie@lugatgt.org>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of the author nor the names of its contributors may be
 *    used to endorse or promote products derived from this software without
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * $Id: test.sml 1812 2004-09-01 02:09:13Z zoogie $
 *)

local
    open TermAnsi
in
structure TermAnsiTest = struct

    (* testReset
         Tests the RESET color, which resets the colors to the default. *)
    fun testReset() =
        print(
            color(FG_RED) ^ "This is red. " ^
            color(RESET) ^ "This is reset. " ^
            color(FG_RED) ^ "This is red again.\n" ^
            color(RESET))
    
    (* testAttributes
         Tests the attributes such as BOLD, UNDERLINE, etc.
         Some attributes may not be supported by the terminal. *)
    fun testAttributes() =
        print(
            color(NORMAL FG_GREEN) ^ "This is normal green.\n" ^
            color(INVISIBLE FG_GREEN) ^ "This is invisible green. " ^
            color(RESET) ^ "<-- (Invisible green)\n" ^
            color(BOLD FG_GREEN) ^ "This is bold green.\n" ^
            color(NORMAL(UNDERLINE FG_GREEN)) ^ "This is underlined green.\n" ^
            color(BOLD(UNDERLINE FG_GREEN)) ^ "This is bold underlined green.\n" ^
            color(BLINK FG_GREEN) ^ "This is blinking green.\n" ^
            color(REVERSE FG_GREEN) ^ "This is reversed green.\n" ^
            color(RESET))
    
    (* testColor
         Tests all combinations of foreground and background colors. *)
    fun testColor() =
        let
            val allColors = [
                ("k","black",FG_BLACK,BG_BLACK),
                ("r","red",FG_RED,BG_RED),
                ("g","green",FG_GREEN,BG_GREEN),
                ("y","yellow",FG_YELLOW,BG_YELLOW),
                ("b","blue",FG_BLUE,BG_BLUE),
                ("m","magenta",FG_MAGENTA,BG_MAGENTA),
                ("c","cyan",FG_CYAN,BG_CYAN),
                ("w","white",FG_WHITE,BG_WHITE)
                ]
                
            fun drawElems(_,[]) = ()
              | drawElems(bgColor,(_,_,fg,_)::rest) = (
                print(color(bgColor fg) ^ "X ");
                drawElems(bgColor,rest)
                )
                
            fun drawRow(heading,desc,_,bgColor) = (
                print(heading ^ " ");
                drawElems(bgColor,allColors);
                print(color(RESET) ^ "  " ^ heading ^ " = " ^ desc ^ "\n")
                )
        in
            print("  ");
            app (fn (x,_,_,_) => print(x ^ " ")) allColors;
            print("\n");
            app (drawRow) allColors
        end
    
    (* testOnly
         Tests the ONLY marker, which allows you to switch background
         colors or attributes without specifying a new foreground color. *)
    fun testOnly() =
        print(
            color(FG_RED) ^ "This is only red. " ^
            color(BG_BLUE FG_RED) ^ "This is red on blue. " ^
            color(BG_YELLOW ONLY) ^ "This is red on yellow. " ^
            color(RESET) ^ "\n")
    
    (* testAll
         Run the entire test suite. *)
    fun testAll() = (
        print("\n");
        testReset(); print("\n");
        testAttributes(); print("\n");
        testColor(); print("\n");
        testOnly(); print("\n")
        )

end
end