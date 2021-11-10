Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBF044B988
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 01:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhKJAHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 19:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhKJAHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 19:07:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB1C061764;
        Tue,  9 Nov 2021 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W4JXu1rHCfgcAycLD9SJGRX/eyfzpCW48FoE6kijWtQ=; b=MDKwUbeI+LFdj+HS6z6K3uDMe+
        ozmAT+MwXU6hjELyei1iaefsdmdXEAOjcyA3euZPYyRD+uXAgGXUzwPFO7X8lEnTLS29NS/Ard96x
        KpzXWRbPJvWFV5X3dTM1anQbKJVgd6om6loxAvbvBftR+ioVWQWuDebMTmK7CsbNs46ti3M/+tLX3
        e1VJYQnRJdYAyKnerVXY11ELrGWxPaEhnbI3mairqP+LHgCWc+XiJ+Wr7TpEPZtM6Ow5241xtxTMT
        BoZt39BhRAvznxTiNVSpY49IQ7YCLHNxDyxi7nQ3nRZojyZkEUwCQHvVLuyFMRq14Dldi0NM8v936
        kM09ntOw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkb6d-00474g-P2; Wed, 10 Nov 2021 00:04:47 +0000
Date:   Tue, 9 Nov 2021 16:04:47 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <YYsMn6HpYHyJZ8c9@bombadil.infradead.org>
References: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
 <alpine.LSU.2.21.2111081925580.1710@pobox.suse.cz>
 <YYrghnBqTq5ZF2ZR@bombadil.infradead.org>
 <20211109212556.GX174703@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109212556.GX174703@worktop.programming.kicks-ass.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:25:56PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 09, 2021 at 12:56:38PM -0800, Luis Chamberlain wrote:
> 
> > If we're going to do this we we must ask, is it really worth it and
> > moving forward then add a semantic patch rule which will pick up on
> > misuses.
> 
> Please, no!
> 
> This guy has been going around sending silly patches on his own, but the
> moment you add this script all the robots will join him, adding to the
> pile of useless crap we get to wade through each day.
> 
> I've yet to see one of these patches fix an actual problem.

Glad we were able to swat this fly fast.

  Luis
