Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3587C24AF11
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgHTGJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:09:00 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40515 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHTGJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 02:09:00 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07K68hSw021529;
        Thu, 20 Aug 2020 08:08:43 +0200
Date:   Thu, 20 Aug 2020 08:08:43 +0200
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
Message-ID: <20200820060843.GA21526@1wt.eu>
References: <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu>
 <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu>
 <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu>
 <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
 <20200820043323.GA21461@1wt.eu>
 <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 06:42:23AM +0200, Sedat Dilek wrote:
> On Thu, Aug 20, 2020 at 6:33 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> > On Thu, Aug 20, 2020 at 05:05:49AM +0200, Sedat Dilek wrote:
> > > We have the same defines for K0 and K1 in include/linux/prandom.h and
> > > lib/random32.c?
> > > More room for simplifications?
> >
> > Definitely, I'm not surprized at all. As I said, the purpose was to
> > discuss around the proposal, not much more. If we think it's the way
> > to go, some major lifting is required. I just don't want to invest
> > significant time on this if nobody cares.
> >
> 
> OK.
> 
> Right now, I will try with the attached diff.

No, don't waste your time this way, it's not the right way to address it,
you're still facing competition between defines. I'll do another one if
you want to go further in the tests.

> Unclear to me where this modpost "net_rand_noise" undefined! comes from.
> Any hints?

Sure, the symbol is not exported. I'll address it as well for you.

Willy
