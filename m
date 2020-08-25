Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6986625196D
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHYNUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgHYNUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:20:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E071C061574;
        Tue, 25 Aug 2020 06:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LRm0a/AB7+1jHaa0sot49R1mIGi0p1SlyxSDm8WQBUY=; b=lrAraWCD0S6gbXfgpQDHWUO/c9
        h9fHLCFKRmzwX3tEO6KmBBJPdc2hC2xC5WOzhw8pvEPStATv125pL/mG+LzD+hfrKqJVp27Y0mNER
        9aeCh3lIVcvwz3xMQ30QSJ9oELZaSR2ANlcR1FM80B7yrdX7N9ZB8JEqVgcWQp0CQfufwfzgf9B+W
        feHcq1Y1tQnTThv0sDdbo49HNl0TnG08P6WBYs3Ic3AfN5b814aejFz/QqC408/5ipz+8R/Eb/wk0
        IaozjHE1Ud/5cy0pdrYHwhGtwPqKow6xBRZvgY7qyHtHQjlGwSR+Y2nXk7DN6GtMra4WkUZ9wvtcg
        v36HK0hA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAYrq-0006b2-89; Tue, 25 Aug 2020 13:20:02 +0000
Date:   Tue, 25 Aug 2020 14:20:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        anchalag@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
Subject: Re: [PATCH v3 05/11] genirq: Shutdown irq chips in suspend/resume
 during hibernation
Message-ID: <20200825132002.GA25009@infradead.org>
References: <cover.1598042152.git.anchalag@amazon.com>
 <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com>
 <87h7svqzxm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7svqzxm.fsf@nanos.tec.linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 02:36:37AM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> followed by an empty new line before the actual changelog text
> starts. That way the attribution of the patch when applying it will be
> correct.

The way he sent it attribution will be correct as he managed to get his
MTU to send out the mail claiming to be from you.  But yes, it needs
the second From line, _and_ the first from line needs to be fixed to
be from him.
