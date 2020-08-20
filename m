Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC5124B0BB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgHTIFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:05:20 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40533 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgHTIFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 04:05:19 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07K853tv021567;
        Thu, 20 Aug 2020 10:05:03 +0200
Date:   Thu, 20 Aug 2020 10:05:03 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>, George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200820080503.GC21526@1wt.eu>
References: <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu>
 <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu>
 <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
 <20200820043323.GA21461@1wt.eu>
 <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
 <20200820060843.GA21526@1wt.eu>
 <20200820065838.GB21526@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820065838.GB21526@1wt.eu>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 08:58:38AM +0200, Willy Tarreau wrote:
> I've just pushed a new branch "20200820-siphash-noise" that I also
> rebased onto latest master. It's currently running make allmodconfig
> here, so that will take a while, but I think it's OK as random32.o is
> already OK. I've also addressed a strange build issue caused by having
> an array instead of 4 ints in siprand_state.
> 
> Please just let me know if that's OK for you now.

At least it worked for me now (built with no errors on x86_64):

$ time make -j 8 bzImage modules
(...)
real    65m7.986s
user    477m22.477s
sys     38m0.545s
$ find . -name '*.ko' |wc -l
7983

Willy
