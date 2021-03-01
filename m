Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CDE327AEF
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 10:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhCAJhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 04:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhCAJhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 04:37:08 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02252C06174A;
        Mon,  1 Mar 2021 01:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OZ3bH+JR4+9gsZSrCT9awdEOfcNtvsdE0dvn419/Fmc=; b=DX9/HwOxU590uSE3bJsNni+pBS
        Y5AKXm7VU8ZiPsGZ6jY1XKB/MY6YPKWrvogr1MMA4TldP2ku9rcMaRbezJdmQIk/tXOoxDZ4uZimz
        K5wdcmrrkKjohNoppvizvdF88ov2bPrZ9We421bwSajl7yxeMsaljX5jekRWEE+lDWWs0V410Yq1Q
        gDNJRiL1EIOIm6hyXy5rIU7d2b1jwo+pN51SgOiY0ltW/yO6WVEQ3Be0KDTR2MHRuhEMFMonL5jum
        r2d2vDUEKce2p3ZEWbxrA2K3Q2n0OGCqwgs4zQ7+/m0ey0gNkFGW5KEvm1r+ijuWxX4ohKVrv6WO2
        ui13Rb1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lGeyR-0005i8-GM; Mon, 01 Mar 2021 09:36:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2A72F301959;
        Mon,  1 Mar 2021 10:36:15 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 19776206A2928; Mon,  1 Mar 2021 10:36:15 +0100 (CET)
Date:   Mon, 1 Mar 2021 10:36:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, mingo@redhat.com, kuba@kernel.org,
        will@kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 0/3] Add lockdep_assert_not_held()
Message-ID: <YDy1j+hMLGUWKKV6@hirez.programming.kicks-ass.net>
References: <cover.1614383025.git.skhan@linuxfoundation.org>
 <YDyn+6N6EfgWJ5GV@hirez.programming.kicks-ass.net>
 <878s779s9f.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s779s9f.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 10:45:32AM +0200, Kalle Valo wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Fri, Feb 26, 2021 at 05:06:57PM -0700, Shuah Khan wrote:
> >> Shuah Khan (3):
> >>   lockdep: add lockdep_assert_not_held()
> >>   lockdep: add lockdep lock state defines
> >>   ath10k: detect conf_mutex held ath10k_drain_tx() calls
> >
> > Thanks!
> 
> Via which tree should these go?

I've just queued the lot for locking/core, which will show up in tip
when the robots don't hate on it.

Does that work for you?
