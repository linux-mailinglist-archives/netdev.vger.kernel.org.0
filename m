Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91008366D34
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhDUNvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhDUNvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4816144C;
        Wed, 21 Apr 2021 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619013061;
        bh=hxz1+u48XJ6VHbnoKXDnKDX1HjLwKmh9R25IjjCmcE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TNo0JmtXlQ84nXPmGgc3ry8at2qU2ZBKznmVuMgCd2kjwl8VJJWzKQgfN2L2gwBjS
         9mox/RXx/uJM4muoh5hQ2um6OHD1RUeO9uW+0QkEe6u11ZeGcvr2bq2oR3r302QjH8
         wwvtRHGPjVtwWG3qy4m7od8jLP477vkI3IPaYsqk=
Date:   Wed, 21 Apr 2021 15:50:58 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <YIAtwtOpy/emQWr2@kroah.com>
References: <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <YIAYThdIoAPu2h7b@unreal>
 <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
 <YIAmy0zgrQW/44Hz@kroah.com>
 <YIApyFQNCBOgNkhU@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YIApyFQNCBOgNkhU@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:34:00PM +0300, Leon Romanovsky wrote:
> On Wed, Apr 21, 2021 at 03:21:15PM +0200, gregkh@linuxfoundation.org wrote:
> > On Wed, Apr 21, 2021 at 01:11:03PM +0000, Trond Myklebust wrote:
> > > On Wed, 2021-04-21 at 15:19 +0300, Leon Romanovsky wrote:
> > > > On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> > > > > > > 
> > > > > > > > > They introduce kernel bugs on purpose. Yesterday, I took a
> > > > > > > > > look on 4
> > > > > > > > > accepted patches from Aditya and 3 of them added various
> > > > > > > > > severity security
> > > > > > > > > "holes".
> > > > > > > > 
> > > > > > > > All contributions by this group of people need to be
> > > > > > > > reverted, if they
> > > > > > > > have not been done so already, as what they are doing is
> > > > > > > > intentional
> > > > > > > > malicious behavior and is not acceptable and totally
> > > > > > > > unethical.  I'll
> > > > > > > > look at it after lunch unless someone else wants to do it…
> > > > > > > 
> > > > > 
> > > > > <snip>
> > > > > 
> > > > > Academic research should NOT waste the time of a community.
> > > > > 
> > > > > If you believe this behavior deserves an escalation, you can
> > > > > contact the Institutional Review Board (irb@umn.edu) at UMN to
> > > > > investigate whether this behavior was harmful; in particular,
> > > > > whether the research activity had an appropriate IRB review, and
> > > > > what safeguards prevent repeats in other communities.
> > > > 
> > > > The huge advantage of being "community" is that we don't need to do
> > > > all
> > > > the above and waste our time to fill some bureaucratic forms with
> > > > unclear
> > > > timelines and results.
> > > > 
> > > > Our solution to ignore all @umn.edu contributions is much more
> > > > reliable
> > > > to us who are suffering from these researchers.
> > > > 
> > > 
> > > <shrug>That's an easy thing to sidestep by just shifting to using a
> > > private email address.</shrug>
> > 
> > If they just want to be jerks, yes.  But they can't then use that type
> > of "hiding" to get away with claiming it was done for a University
> > research project as that's even more unethical than what they are doing
> > now.
> > 
> > > There really is no alternative for maintainers other than to always be
> > > sceptical of patches submitted by people who are not known and trusted
> > > members of the community, and to scrutinise those patches with more
> > > care.
> > 
> > Agreed, and when we notice things like this that were determined to be
> > bad, we have the ability to easily go back and rip the changes out and
> > we can slowly add them back if they are actually something we want to
> > do.
> > 
> > Which is what I just did:
> > 	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/
> 
> Greg,
> 
> Did you push your series to the public git? I would like to add you a
> couple of reverts.

Yes, it can be found here:
	git@gitolite.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core.git umn.edu-reverts

You can send reverts in email if you want, whatever works best.

> And do you have a list of not reverted commits? It will save us from
> doing same comparison of reverted/not reverted over and over.

Below is the list that didn't do a simple "revert" that I need to look
at.  I was going to have my interns look into this, there's no need to
bother busy maintainers with it unless you really want to, as I can't
tell anyone what to work on :)

thanks,

greg k-h

-------------------------
# commits that need to be looked at as a clean revert did not work
990a1162986e
58d0c864e1a7
a068aab42258
8816cd726a4f
c705f9fc6a17
8b6fc114beeb
169f9acae086
8da96730331d
f4f5748bfec9
e08f0761234d
cb5173594d50
06d5d6b7f994
d9350f21e5fe
6f0ce4dfc5a3
f0d14edd2ba4
46953f97224d
3c77ff8f8bae
0aab8e4df470
8e949363f017
f8ee34c3e77a
fd21b79e541e
766460852cfa
41f00e6e9e55
78540a259b05
208c6e8cff1b
7ecced0934e5
48f40b96de2c
9aabb68568b4
2cc12751cf46
534c89c22e26
6a8ca24590a2
d70d70aec963
d7737d425745
3a10e3dd52e8
d6cb77228e3a
517ccc2aa50d
07660ca679da
0fff9bd47e13
6ade657d6125
2795e8c25161
4ec850e5dfec
035a14e71f27
10010493c126
4280b73092fe
5910fa0d0d98
40619f7dd3ef
0a54ea9f481f
44fabd8cdaaa
02cc53e223d4
c99776cc4018
7fc93f3285b1
6ae16dfb61bc
9c6260de505b
eb8950861c1b
46273cf7e009
89dfd0083751
c9c63915519b
cd07e3701fa6
15b3048aeed8
7172122be6a4
47db7873136a
58f5bbe331c5
6b995f4eec34
8af03d1ae2e1
f16b613ca8b3
6009d1fe6ba3
8e03477cb709
dc487321b1e6
