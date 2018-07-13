/*
 * Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

.pragma library

var keyboards = {
    en: {
        name: "English",
        local_name: "English",
        row1: ["q1€", "w2£", "e3$", "r4¥", "t5₹", "y6%", "u7<", "i8>", "o9[", "p0]"],
        row2: ["a*`", "s#^", "d+|", "f-_", "g=§", "h({", "j)}", "k?¿", "l!¡"],
        row3: ["z@«", "x~»", "c/\"", "v\\“", "b'”", "n;„", "m:&"],
        accents_row1: ["", "", "eèéêë", "", "tþ", "yý", "uûùúü", "iîïìí", "oöôòó", ""],
        accents_row2: ["aäàâáãå", "", "dð", "", "", "", "", "", ""],
        accents_row3: ["", "", "cç", "", "", "nñ", ""]
    },
    ru : {
        name: "Russian",
        local_name: "Русский",
        row1: ["й1€", "ц2£", "у3$", "к4¥", "е5₹", "н6%", "г7<", "ш8>", "щ9[", "з0]", "х0]"],
        row2: ["ф*`", "ы#^", "в+|", "а-_", "п=§", "р{}", "о?¿", "л!¡", "д!¡", "ж!¡", "э!¡"],
        row3: ["я@«", "ч~»", "с/\"", "м\\“", "и'”", "т;„", "ь:&", "б;„", "ю:&"],
        accents_row1: ["", "", "eèéêë", "", "tþ", "yý", "uûùúü", "iîïìí", "oöôòó", ""],
        accents_row2: ["aäàâáãå", "", "dð", "", "", "", "", "", ""],
        accents_row3: ["", "", "cç", "", "", "nñ", ""]
    },
    fi : {
        name: "Finnish",
        local_name: "Suomi",
        row1: ["q1€", "w2£", "e3$", "r4¥", "t5₹", "y6¤", "u7<", "i8>", "o9[", "p0]", "å%‰]"],
        row2: ["a*`", "s#^", "d+|", "f-_", "g=§", "h({", "j)}", "k\"°", "l~·", "ö!¡", "ä?¿"],
        row3: ["z@«", "x&»", "c/÷", "v\\“", "b'”", "n;„", "m:×"],
        accents_row1: ["", "", "", "", "", "", "", "", "", "", ""],
        accents_row2: ["", "", "", "", "", "", "", "", "", "", ""],
        accents_row3: ["", "", "", "", "", "", ""]
    }
}
