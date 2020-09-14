Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F36269188
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgINQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:31:11 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41804 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgINQah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:30:37 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 08EGT9Np012442;
        Mon, 14 Sep 2020 18:29:09 +0200
Date:   Mon, 14 Sep 2020 18:29:09 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Amit Klein <aksecurity@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tytso@mit.edu" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Message-ID: <20200914162909.GA12439@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <20200901064302.849-2-w@1wt.eu>
 <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com>
 <20200901131623.GB1059@1wt.eu>
 <CANEQ_+Kuw6cxWRBE6NyXkr=8p3W-1f=o1q91ZESeueEnna9fvw@mail.gmail.com>
 <CA+icZUUmQeww+94dVOe1JFFQRkvUYVZP3g2GP+gOsdX4kP4x+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUmQeww+94dVOe1JFFQRkvUYVZP3g2GP+gOsdX4kP4x+A@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 06:16:40PM +0200, Sedat Dilek wrote:
> On Mon, Sep 14, 2020 at 4:53 PM Amit Klein <aksecurity@gmail.com> wrote:
> >
> > Hi
> >
> > Is this patch being pushed to any branch? I don't see it deployed anywhere (unless I'm missing something...).
> >
> 
> It's here:
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise

By the way I didn't get any feedback from those who initially disagreed
with the one that was mergd, so for now I'm not doing anything on it
anymore. I can propose it again for 5.10-rc1 but will not push anymore
if there's no interest behind it.

Cheers,
Willy
