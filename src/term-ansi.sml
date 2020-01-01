
(*
 * term-ansi.sml
 *   Provides ANSI terminal colors and control.
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
 * $Id: infocmd.sml 1801 2004-08-19 01:07:27Z zoogie $
 *)

structure TermAnsi :> TERMANSI = struct

    datatype color =
        RESET |
        ONLY |
        (* Attributes. *)
        NORMAL of color |
        BOLD of color |
        UNDERLINE of color |
        BLINK of color |
        REVERSE of color |
        INVISIBLE of color |
        (* Background. *)
        BG_BLACK of color |
        BG_RED of color |
        BG_GREEN of color |
        BG_YELLOW of color |
        BG_BLUE of color |
        BG_MAGENTA of color |
        BG_CYAN of color |
        BG_WHITE of color |
        (* Foreground. *)
        FG_BLACK |
        FG_RED |
        FG_GREEN |
        FG_YELLOW |
        FG_BLUE |
        FG_MAGENTA |
        FG_CYAN |
        FG_WHITE
    
    (* color2code c
         Convert a color to a series of ANSI color codes. *)
    fun color2code(c) =
        let
            fun chain(code,ONLY) = code
              | chain(code,next) = code ^ ";" ^ color2code(next)
        in
            case c
              of RESET => "0"
               | ONLY => "0"
               | NORMAL(c') => chain("0",c')
               | BOLD(c') => chain("1",c')
               | UNDERLINE(c') => chain("4",c')
               | BLINK(c') => chain("5",c')
               | REVERSE(c') => chain("7",c')
               | INVISIBLE(c') => chain("8",c')
               | BG_BLACK(c') => chain("40",c')
               | BG_RED(c') => chain("41",c')
               | BG_GREEN(c') => chain("42",c')
               | BG_YELLOW(c') => chain("43",c')
               | BG_BLUE(c') => chain("44",c')
               | BG_MAGENTA(c') => chain("45",c')
               | BG_CYAN(c') => chain("46",c')
               | BG_WHITE(c') => chain("47",c')
               | FG_BLACK => "30"
               | FG_RED => "31"
               | FG_GREEN => "32"
               | FG_YELLOW => "33"
               | FG_BLUE => "34"
               | FG_MAGENTA => "35"
               | FG_CYAN => "36"
               | FG_WHITE => "37"
        end
    
    (* See sig. *)
    fun color(RESET) = "\^[[0m"
      | color(c) = "\^[[" ^ color2code(c) ^ "m"

end
