Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591312591EC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgIAO5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:57:35 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41251 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgIAO53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 10:57:29 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 081Et9cK001156;
        Tue, 1 Sep 2020 16:55:09 +0200
Date:   Tue, 1 Sep 2020 16:55:09 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [PATCH 0/2] prandom_u32: make output less predictable
Message-ID: <20200901145509.GC1059@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <CA+icZUVvOArpuR=PJBg288pJmLmYxtgZxJOHnjk943e9M22WOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVvOArpuR=PJBg288pJmLmYxtgZxJOHnjk943e9M22WOQ@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 04:41:13PM +0200, Sedat Dilek wrote:
> I have tested with the patchset from [1].
> ( Later I saw, you dropped "WIP: tcp: reuse incoming skb hash in
> tcp_conn_request()". )

Yes because it's a bit out of the cope of this series and makes sense
even without these patches, thus I assume Eric will take care of it
separately.

Willy
