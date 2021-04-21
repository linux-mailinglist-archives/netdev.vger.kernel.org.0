Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968A6366CE9
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhDUNei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235588AbhDUNeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8546161449;
        Wed, 21 Apr 2021 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619012044;
        bh=4k+3XsmvhTwItuQS7ASo+R/yH2hxOaxaEo+U/U0QH/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qttmIBdSLiFBQ13ZleEC5e15kCiD8LSCqN5dnCyOpBXvpp2ZWfknVwfbvad1IMpfi
         B2E7FchubxZhfT7uEQBac79LxhXEBPIcjJkqLu5bDTo5lOua6HLB2X0Zf05KssXLdN
         xIRt9kIcTo5Vz7FF8WOdzmDg+WvhkShi/ETffqI8MsVKP3O/L6N0WUdCZ6jZ5gMlHC
         eiWk6Pg6ygib+foGevry08qh6a7yqWCKQaX1q/pCoJzVvCXk1rInYRsgPp0AwwUHim
         rqTMTfD6relnvKt8SdC4Z5teH2BzgmdsH75h3+y8dVKbss/ZhZ44/cBBmfGMQ6bcho
         ZRhB8TgtBTHvg==
Date:   Wed, 21 Apr 2021 16:34:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "a.shelat@northeastern.edu" <a.shelat@northeastern.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "pakki001@umn.edu" <pakki001@umn.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIApyFQNCBOgNkhU@unreal>
References: <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <YIAYThdIoAPu2h7b@unreal>
 <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
 <YIAmy0zgrQW/44Hz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YIAmy0zgrQW/44Hz@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 03:21:15PM +0200, gregkh@linuxfoundation.org wrote:
> On Wed, Apr 21, 2021 at 01:11:03PM +0000, Trond Myklebust wrote:
> > On Wed, 2021-04-21 at 15:19 +0300, Leon Romanovsky wrote:
> > > On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> > > > > > 
> > > > > > > > They introduce kernel bugs on purpose. Yesterday, I took a
> > > > > > > > look on 4
> > > > > > > > accepted patches from Aditya and 3 of them added various
> > > > > > > > severity security
> > > > > > > > "holes".
> > > > > > > 
> > > > > > > All contributions by this group of people need to be
> > > > > > > reverted, if they
> > > > > > > have not been done so already, as what they are doing is
> > > > > > > intentional
> > > > > > > malicious behavior and is not acceptable and totally
> > > > > > > unethical.  I'll
> > > > > > > look at it after lunch unless someone else wants to do it…
> > > > > > 
> > > > 
> > > > <snip>
> > > > 
> > > > Academic research should NOT waste the time of a community.
> > > > 
> > > > If you believe this behavior deserves an escalation, you can
> > > > contact the Institutional Review Board (irb@umn.edu) at UMN to
> > > > investigate whether this behavior was harmful; in particular,
> > > > whether the research activity had an appropriate IRB review, and
> > > > what safeguards prevent repeats in other communities.
> > > 
> > > The huge advantage of being "community" is that we don't need to do
> > > all
> > > the above and waste our time to fill some bureaucratic forms with
> > > unclear
> > > timelines and results.
> > > 
> > > Our solution to ignore all @umn.edu contributions is much more
> > > reliable
> > > to us who are suffering from these researchers.
> > > 
> > 
> > <shrug>That's an easy thing to sidestep by just shifting to using a
> > private email address.</shrug>
> 
> If they just want to be jerks, yes.  But they can't then use that type
> of "hiding" to get away with claiming it was done for a University
> research project as that's even more unethical than what they are doing
> now.
> 
> > There really is no alternative for maintainers other than to always be
> > sceptical of patches submitted by people who are not known and trusted
> > members of the community, and to scrutinise those patches with more
> > care.
> 
> Agreed, and when we notice things like this that were determined to be
> bad, we have the ability to easily go back and rip the changes out and
> we can slowly add them back if they are actually something we want to
> do.
> 
> Which is what I just did:
> 	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/

Greg,

Did you push your series to the public git? I would like to add you a
couple of reverts.

And do you have a list of not reverted commits? It will save us from
doing same comparison of reverted/not reverted over and over.

Thanks

> 
> thanks,
> 
> greg k-h
