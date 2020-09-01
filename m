Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6338258ADA
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgIAI5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:57:17 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41185 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgIAI5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 04:57:16 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0818uwQb001003;
        Tue, 1 Sep 2020 10:56:58 +0200
Date:   Tue, 1 Sep 2020 10:56:58 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Yann Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Message-ID: <20200901085658.GC901@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <20200901064302.849-2-w@1wt.eu>
 <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com>
 <20200901083947.GB901@1wt.eu>
 <CA+icZUXjDaoLG36X7Jd7i6=Ncf6xTm44qL7ZV+i7pmNgtLuJSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXjDaoLG36X7Jd7i6=Ncf6xTm44qL7ZV+i7pmNgtLuJSA@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 10:46:16AM +0200, Sedat Dilek wrote:
> Will you push the updated patchset to your prandom Git - for easy fetching?

Yeah if you want, feel free to use this one :
   https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise

Willy
