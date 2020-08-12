Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69373242440
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHLDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:22:26 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39819 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLDW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 23:22:26 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07C3Ldd1010123;
        Wed, 12 Aug 2020 05:21:39 +0200
Date:   Wed, 12 Aug 2020 05:21:39 +0200
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
Message-ID: <20200812032139.GA10119@1wt.eu>
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG>
 <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG>
 <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:51:43PM +0200, Sedat Dilek wrote:
> Can you share this "rebased to mainline" version of George's patch?

You can pick it from there if that helps, but keep in mind that
it's just experimental code that we use to explain our ideas and
that we really don't care a single second what kernel it's applied
to:

   https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/cleanups.git/log/?h=20200811-prandom-1

Willy
