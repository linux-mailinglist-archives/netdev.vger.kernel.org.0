Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC2D366CA7
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbhDUNWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241745AbhDUNVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16FB1601FD;
        Wed, 21 Apr 2021 13:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619011250;
        bh=eC3IDRJsjjQbiM4nyZrpIMd+T/Oe9fAhzosf/ug5/bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rh9Z60yMfDSNGgDgoGe+JGQMX6J+cEE//zgJ7r24476K5FT7c0VZs7UzyqmrCJj/0
         y4eSWG7/975skGcV9dWZ+if67mmJgE+xLwsK1R6b7iTe5/zEkfkxYarKRqZ0fIT3Qc
         23vLUCfj4ckU02ZFtXEqiMF6JB1R98GksD2e9B+z0cBhDUk7sIRYCntFlAB4w3EV33
         ROO7ZXEV8f1tsWsY0HMuF5SEYWzCyGuN8PN5/wX9RPFL5K+xIxEUc08OTVFXslT5RG
         Yvx8n/2X6sMRRPOY2tUODJuq5hnJcVkmXJQEaFwCNHG6Kpw81MULdO109f0LPR4YRV
         fOni1bpb9Lm4w==
Date:   Wed, 21 Apr 2021 16:20:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "a.shelat@northeastern.edu" <a.shelat@northeastern.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <YIAmrgZ4Bnqo/nmI@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <YIAYThdIoAPu2h7b@unreal>
 <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 01:11:03PM +0000, Trond Myklebust wrote:
> On Wed, 2021-04-21 at 15:19 +0300, Leon Romanovsky wrote:
> > On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> > > > > 
> > > > > > > They introduce kernel bugs on purpose. Yesterday, I took a
> > > > > > > look on 4
> > > > > > > accepted patches from Aditya and 3 of them added various
> > > > > > > severity security
> > > > > > > "holes".
> > > > > > 
> > > > > > All contributions by this group of people need to be
> > > > > > reverted, if they
> > > > > > have not been done so already, as what they are doing is
> > > > > > intentional
> > > > > > malicious behavior and is not acceptable and totally
> > > > > > unethical.  I'll
> > > > > > look at it after lunch unless someone else wants to do it…
> > > > > 
> > > 
> > > <snip>
> > > 
> > > Academic research should NOT waste the time of a community.
> > > 
> > > If you believe this behavior deserves an escalation, you can
> > > contact the Institutional Review Board (irb@umn.edu) at UMN to
> > > investigate whether this behavior was harmful; in particular,
> > > whether the research activity had an appropriate IRB review, and
> > > what safeguards prevent repeats in other communities.
> > 
> > The huge advantage of being "community" is that we don't need to do
> > all
> > the above and waste our time to fill some bureaucratic forms with
> > unclear
> > timelines and results.
> > 
> > Our solution to ignore all @umn.edu contributions is much more
> > reliable
> > to us who are suffering from these researchers.
> > 
> 
> <shrug>That's an easy thing to sidestep by just shifting to using a
> private email address.</shrug>
> 
> There really is no alternative for maintainers other than to always be
> sceptical of patches submitted by people who are not known and trusted
> members of the community, and to scrutinise those patches with more
> care.

Right, my guess is that many maintainers failed in the trap when they
saw respectful address @umn.edu together with commit message saying
about "new static analyzer tool".

The mental bias here is to say that "oh, another academic group tries
to reinvent the wheel, looks ok".

Thanks

> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 
