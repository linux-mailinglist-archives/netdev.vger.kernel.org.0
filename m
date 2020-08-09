Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C474023FF27
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 18:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgHIQI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 12:08:58 -0400
Received: from mx.sdf.org ([205.166.94.24]:53627 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHIQIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 12:08:54 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 079G8CdI026930
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 9 Aug 2020 16:08:13 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 079G8BVv001093;
        Sun, 9 Aug 2020 16:08:11 GMT
Date:   Sun, 9 Aug 2020 16:08:11 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     Jason@zx2c4.com, edumazet@google.com, fw@strlen.de,
        keescook@chromium.org, lkml.mplumb@gmail.com, luto@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        stephen@networkplumber.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tytso@mit.edu, w@1wt.eu
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809160811.GA25124@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <CANEQ_++a4YcwQQ2XhuguTono9=RxbSRVsMw08zLWBWJ_wxG2AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_++a4YcwQQ2XhuguTono9=RxbSRVsMw08zLWBWJ_wxG2AQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:26:31AM +0300, Amit Klein wrote:
> BITS_PER_LONG==23 ???
> Should be ==32, I guess.

Of course.  I've been testing on a 64-bit system so hadn't
exercised that branch yet, and it's a case of "seeing what
I expect to see".
