Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE06117100
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIQBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:01:43 -0500
Received: from mail.toke.dk ([45.145.95.4]:59815 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfLIQBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 11:01:43 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1575907301; bh=NraEdSdmsvgNaRPHVYtyMr8NW/WE9oChAqBR+CFL2UA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JBF82fVA8spExcXgZ1B/AJSG+SveqdtENFg491FU+rQAmkRWaYRGgveRDwJqBMfeI
         bZIt9MNk3J3s3qt05aIaacyx13oSbuVn74iYKrRj4UmNmNEIXq2TipgDkQk3KcGyD7
         Be0jOMIChfUOqudRZvGyZC4aOPy4EqfHbV5yaxCZMHgdR4MfyE41YCQTDx0+knG6do
         XpICGEUxpyNvyXWWb1slRWRs1tVTeqrMwGrRG0fvNBwlU1QPkY7JAxsXFrOdIhhEEb
         EUX/raM+zwFzzT7vjzJ51u134N4F5pmB+EREdOk+LhyyjmhGSe5kXfr99GWJD9dvWl
         WfnuB7Hfla40w==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: organization of wireguard linux kernel repos moving forward
In-Reply-To: <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
References: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com> <87d0cxlldu.fsf@toke.dk> <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
Date:   Mon, 09 Dec 2019 17:01:41 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87blshij2y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On Mon, Dec 9, 2019 at 1:43 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
>>
>> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>>
>> > 2) wireguard-tools.git will have the userspace utilities and scripts,
>> > such as wg(8) and wg-quick(8), and be easily packageable by distros.
>> > This repo won't be live until we get a bit closer to the 5.6 release,
>> > but when it is live, it will live at:
>> > https://git.zx2c4.com/wireguard-tools/ [currently 404s]
>> > https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-tools.=
git/
>> > [currently 404s]
>>
>> Any plans for integrating this further with iproute2? One could imagine
>> either teaching 'ip' about the wireguard-specific config (keys etc), or
>> even just moving the 'wg' binary wholesale into iproute2?
>
> I'd definitely be interested in this. Back in 2015, that was the plan.
> Then it took a long time to get to where we are now, and since then
> wg(8) has really evolved into its own useful thing. The easiest thing
> would be to move wg(8) wholesale into iproute2 like you suggested;
> that'd allow people to continue using their infrastructure and whatnot
> they've used for a long time now. A more nuanced approach would be
> coming up with a _parallel_ iproute2 tool with mostly the same syntax
> as wg(8) but as a subcommand of ip(8). Originally the latter appealed
> to me, but at this point maybe the former is better after all. I
> suppose something to consider is that wg(8) is actually a
> cross-platform tool now, with a unified syntax across a whole bunch of
> operating systems.

Hmm, I don't really have any opinion about which approach makes the most
sense; I'm primarily concerned with getting the support into iproute2 so
that it is possible to set up and configure a wireguard tunnel "out of
the box". Both approaches would achieve that, I think...

> But it's also just boring C.

Well, we could always rewrite it in Rust or something? ;)

-Toke
