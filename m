Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405A244B4D3
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbhKIVfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbhKIVfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 16:35:31 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E233C061764;
        Tue,  9 Nov 2021 13:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dJw8Ik3ylTfPa2P+lNYAI2E2MHLc1nH0ayoDuzAKkgA=; b=OOkUgSDXP7m4WHp+xHkR0poveQ
        F4isHITGM8YcAaTGbZj0pvoTb+4BCJTmjqojBg4GfhXkZZXUzCNjHAYHDC80RJzSF2L5hDRJZsnaY
        NtGk4eumtBy/xPnr89A8E9WSXDGJ7jc2XWB3w0hTg4wy0vplWcJb+HB68jvs/fSOE0Y6NadAmTH8M
        0/oR/kogdOGavrcWaV+75SpbQRGwB+TWzk0lLgRRcUP0STDeNykaS6lv5SzTLxwlaN+WbJzNrHCU2
        5GkLZTjl3/QeOpKdfwfPLGIs1qt7FlguhfDJPvfIAtHa8UtmS619YcDGNU+iGkaKQfsTSyQEVpxZB
        P+pMNIzQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkYj3-00F8o8-Sd; Tue, 09 Nov 2021 21:32:19 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1C45A985A2A; Tue,  9 Nov 2021 22:25:56 +0100 (CET)
Date:   Tue, 9 Nov 2021 22:25:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Julia Lawall <julia.lawall@inria.fr>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>, jeyu@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] module: Fix implicit type conversion
Message-ID: <20211109212556.GX174703@worktop.programming.kicks-ass.net>
References: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
 <alpine.LSU.2.21.2111081925580.1710@pobox.suse.cz>
 <YYrghnBqTq5ZF2ZR@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYrghnBqTq5ZF2ZR@bombadil.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 12:56:38PM -0800, Luis Chamberlain wrote:

> If we're going to do this we we must ask, is it really worth it and
> moving forward then add a semantic patch rule which will pick up on
> misuses.

Please, no!

This guy has been going around sending silly patches on his own, but the
moment you add this script all the robots will join him, adding to the
pile of useless crap we get to wade through each day.

I've yet to see one of these patches fix an actual problem.
