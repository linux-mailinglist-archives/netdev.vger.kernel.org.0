Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BF2770E2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgIXMY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgIXMY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:24:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB60DC0613CE;
        Thu, 24 Sep 2020 05:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h6ZjDVpARQmoVPgdF+zXfNDaRDvpx+lMRIGHPuMBPtY=; b=aOAz9t9fqjembb+394L2A1bdbS
        z/vtPluZC+nVb3yOaU1S+Fq6jcMR7ammr4tS1JqhyGzj63uuYsLw9Gm+g3Il2eWJKtdH7irakPNSV
        AyCpkbHXvIcIPg2R9o0JL4rTkaXPhdHfxJCipWE0wvTnVVZ6y1sJvk3ruEzy04oB8eCckhOsh1VKw
        nsasweiQEUZIp/j66KN/XMrmJfHSh6WLy9ImN8LAkH/5DDBSR1dk9OW3TwRrqTxBJXUt6PtV/sJmS
        XMIrli2fh1iV3Io+Ljl61Z3BG2nRYu6zzswKCqzCFLDu5OCv257xpqTZwomAknTyuD6uZVTn8MPEm
        YeBG2WwQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLQIA-0005qN-Om; Thu, 24 Sep 2020 12:24:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 508843059DE;
        Thu, 24 Sep 2020 14:24:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ECE7E20315103; Thu, 24 Sep 2020 14:24:02 +0200 (CEST)
Date:   Thu, 24 Sep 2020 14:24:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
Message-ID: <20200924122402.GH2628@hirez.programming.kicks-ass.net>
References: <20200923181126.223766-1-nitesh@redhat.com>
 <20200923181126.223766-2-nitesh@redhat.com>
 <20200924084029.GC1362448@hirez.programming.kicks-ass.net>
 <20200924120956.GA19346@lenoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924120956.GA19346@lenoir>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 02:09:57PM +0200, Frederic Weisbecker wrote:

> > > +static inline unsigned int hk_num_online_cpus(void)
> > 
> > This breaks with the established naming of that header.
> 
> I guess we can make it housekeeping_num_online_cpus() ?

That would be consistent :-)
