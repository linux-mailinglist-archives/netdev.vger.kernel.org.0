Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDF253B49
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 03:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgH0BKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 21:10:04 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40660 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgH0BKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 21:10:04 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07R19Fb4028384;
        Thu, 27 Aug 2020 03:09:15 +0200
Date:   Thu, 27 Aug 2020 03:09:15 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200827010915.GA28379@1wt.eu>
References: <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu>
 <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
 <20200820043323.GA21461@1wt.eu>
 <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
 <20200820060843.GA21526@1wt.eu>
 <20200820065838.GB21526@1wt.eu>
 <20200820080503.GC21526@1wt.eu>
 <CANEQ_+L+22Hkdqf38Zr0bfq16fcL1Ax2X9fToXV_niHKXCB8aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_+L+22Hkdqf38Zr0bfq16fcL1Ax2X9fToXV_niHKXCB8aA@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Amit,

On Thu, Aug 27, 2020 at 02:06:39AM +0300, Amit Klein wrote:
> Hi
> 
> Is there an ETA for this patch then?

No particular ETA on my side, I was waiting for potential criticisms
before going further. I suspect that if nobody complains anymore, it's
an implicit voucher and I'll have to clean up and post the series then.

Thanks,
Willy
