Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4F022B2DF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgGWPsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgGWPsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:48:33 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F927C0619DC;
        Thu, 23 Jul 2020 08:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bRI26vrweI1jYqRMYzCR/gnwvQu3h9j+kI22DqtyZ9U=; b=vXaAGsSIFSa8ve1IkIIa+yBEtc
        6j6rSD2cYy8nAVnlRdfgYbXbK9bA/nkkTIb3BPJOA/0b/KNItf7nuTZJ+2sFNnIMxPrwWgjOQB2r5
        8/Z1op7CUkGdDLO/U3QjxUlvkFgGSWqMl+x1Fcq52jG3GUhN2LQsXZ61Wp/RrjdMKcW4P0qKXUN1F
        iaQ/0s7zhIDjJygAhLWrO+BrZCU4JvhsCB56lqxaCcpGQY68Hf8M8B1xXKZmx8LBGVYngdwfZucNg
        vOpUwdE8fZTFNjfVD2VKW88sUialZE2BOi1RjTFTHMx7qXMi3Yf80Omu2z4mivirbaC/nDIOet6KE
        gZ8E8CwQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jydSI-0005lT-2b; Thu, 23 Jul 2020 15:48:22 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 22849983422; Thu, 23 Jul 2020 17:48:20 +0200 (CEST)
Date:   Thu, 23 Jul 2020 17:48:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 00/13] "Task_isolation" mode
Message-ID: <20200723154820.GA709@worktop.programming.kicks-ass.net>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <87imeextf3.fsf@nanos.tec.linutronix.de>
 <20200723142902.GT5523@worktop.programming.kicks-ass.net>
 <670609a91be23ebb4f179850601439fbed844479.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670609a91be23ebb4f179850601439fbed844479.camel@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:41:46PM +0000, Alex Belits wrote:
> 
> On Thu, 2020-07-23 at 16:29 +0200, Peter Zijlstra wrote:
> > .
> > 
> > This.. as presented it is an absolutely unreviewable pile of junk. It
> > presents code witout any coherent problem description and analysis.
> > And
> > the patches are not split sanely either.
> 
> There is a more complete and slightly outdated description in the
> previous version of the patch at 
> https://lore.kernel.org/lkml/07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com/

Not the point, you're mixing far too many things in one go. You also
have the patches split like 'generic / arch-1 / arch-2' which is wrong
per definition, as patches should be split per change and not care about
sily boundaries.

Also, if you want generic entry code, there's patches for that here:

  https://lkml.kernel.org/r/20200722215954.464281930@linutronix.de


