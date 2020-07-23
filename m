Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E920D22B15C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgGWO3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgGWO3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:29:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D16C0619DC;
        Thu, 23 Jul 2020 07:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=upOiIS7dMuAye0nblqH4s7ijqqWrvcTJhfr37DrOQV4=; b=NXnhLWyzLS186oz1sFOcrgLsjP
        wqswZUN8nPVkVOwndoUqsF7gfC2ZxKdZQCwGixtBlpofMFffF/EjHEPBljpMLAh8NEIb+GWShTLxE
        qSNjgEb8x5KIxJyWKY+I1Wy3wsvp+yPXIv3dACcd0VqcZlI/7eoC5IRec+tZVNCRZe184WGpSozhk
        CvN5XmIyHTaRw44j/WGYE+N6OLt25YAvJyVdEHG5nt1uNTZYubIMudeszyZkroKmGPNLmWm8fq7Cm
        GpFfjYgDqTZB6cKPZMF8/YFlhLIN8uceUVDtQTVDRnXEgTmQCUgX5H8Any/+y/RIVCID1b84LZb/Y
        Sghus1pw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jycDX-0006yA-8C; Thu, 23 Jul 2020 14:29:03 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64E5F983422; Thu, 23 Jul 2020 16:29:02 +0200 (CEST)
Date:   Thu, 23 Jul 2020 16:29:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alex Belits <abelits@marvell.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
Message-ID: <20200723142902.GT5523@worktop.programming.kicks-ass.net>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <87imeextf3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imeextf3.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:17:04PM +0200, Thomas Gleixner wrote:
>   8) Changelogs
> 
>      Most of the changelogs have something along the lines:
> 
>      'task isolation does not want X, so do Y to make it not do X'
> 
>      without any single line of explanation why this approach was chosen
>      and why it is correct under all circumstances and cannot have nasty
>      side effects.
> 
>      It's not the job of the reviewers/maintainers to figure this out.
> 
> Please come up with a coherent design first and then address the
> identified issues one by one in a way which is palatable and reviewable.
> 
> Throwing a big pile of completely undocumented 'works for me' mess over
> the fence does not get you anywhere, not even to the point that people
> are willing to review it in detail.

This.. as presented it is an absolutely unreviewable pile of junk. It
presents code witout any coherent problem description and analysis. And
the patches are not split sanely either.
