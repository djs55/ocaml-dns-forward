(*
 * Copyright (C) 2016 David Scott <dave@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)
open Lwt.Infix

type 'a t = ('a, [ `Msg of string ]) Dns_forward_lwt_result.t

module FromFlowError(Flow: V1_LWT.FLOW) = struct
  let (>>=) m f = m >>= function
    | `Eof -> Lwt.return (Result.Error (`Msg "Unexpected end of file"))
    | `Error e -> Lwt.return (Result.Error (`Msg (Flow.error_message e)))
    | `Ok x -> f x
end

let errorf fmt = Printf.ksprintf (fun s -> Lwt.return (Result.Error (`Msg s))) fmt

module Infix = Dns_forward_lwt_result.Infix
