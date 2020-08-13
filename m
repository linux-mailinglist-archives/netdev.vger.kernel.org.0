Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3DA2435BC
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHMIHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 04:07:35 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39975 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgHMIHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 04:07:35 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07D86kSg010942;
        Thu, 13 Aug 2020 10:06:46 +0200
Date:   Thu, 13 Aug 2020 10:06:46 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200813080646.GB10907@1wt.eu>
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG>
 <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG>
 <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu>
 <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 09:53:11AM +0200, Sedat Dilek wrote:
> On Wed, Aug 12, 2020 at 5:21 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> > On Tue, Aug 11, 2020 at 12:51:43PM +0200, Sedat Dilek wrote:
> > > Can you share this "rebased to mainline" version of George's patch?
> >
> > You can pick it from there if that helps, but keep in mind that
> > it's just experimental code that we use to explain our ideas and
> > that we really don't care a single second what kernel it's applied
> > to:
> >
> >    https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/cleanups.git/log/?h=20200811-prandom-1
> >
> 
> Thanks Willy.
> 
> I disagree: the base for testing should be clear(ly communicated).

It is. As you can see on the log above, this was applied on top of
fc80c51fd4b2, there's nothing special here. In addition we're not even
talking about testing nor calling for testers, just trying to find a
reasonable solution. Maybe today I'll be able to re-run a few tests by
the way.

> There are two diffs from Eric to #1: add a trace event for
> prandom_u32() and #2: a removal of prandom_u32() call in
> tcp_conn_request().
> In case you have not seen.

I've seen, just not had the time to test yet.

Willy
