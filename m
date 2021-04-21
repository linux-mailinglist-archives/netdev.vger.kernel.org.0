Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66783666DC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhDUIQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhDUIQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 04:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B590161264;
        Wed, 21 Apr 2021 08:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618992950;
        bh=8feRFI+Nf7CsMwsoYsmAwHpr1e9275LaSeUvdaoYQT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3BHKnNimm0EQCUx2EoeWZa/23frWnb8N7x1me4NyuKUEgcMKb+wnCVnYaVZxZac+
         XjrmGYQoWAykLubQIICJ/UsMPHimRlr28qs0D/VApT64+Pck0NFDSPnNE3eV9uYigJ
         U3iSTwp0UPoYC7+Xz9HZgkceMCwp4LXDcU2GNd30=
Date:   Wed, 21 Apr 2021 10:15:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH/fM/TsbmcZzwnX@kroah.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Apr 21, 2021 at 02:56:27AM -0500, Aditya Pakki wrote:
> Greg,
> 
> I respectfully ask you to cease and desist from making wild accusations
> that are bordering on slander.
> 
> These patches were sent as part of a new static analyzer that I wrote and
> it's sensitivity is obviously not great. I sent patches on the hopes to get
> feedback. We are not experts in the linux kernel and repeatedly making
> these statements is disgusting to hear.
> 
> Obviously, it is a wrong step but your preconceived biases are so strong
> that you make allegations without merit nor give us any benefit of doubt.
> 
> I will not be sending any more patches due to the attitude that is not only
> unwelcome but also intimidating to newbies and non experts.

You, and your group, have publicly admitted to sending known-buggy
patches to see how the kernel community would react to them, and
published a paper based on that work.

Now you submit a new series of obviously-incorrect patches again, so
what am I supposed to think of such a thing?

They obviously were _NOT_ created by a static analysis tool that is of
any intelligence, as they all are the result of totally different
patterns, and all of which are obviously not even fixing anything at
all.  So what am I supposed to think here, other than that you and your
group are continuing to experiment on the kernel community developers by
sending such nonsense patches?

When submitting patches created by a tool, everyone who does so submits
them with wording like "found by tool XXX, we are not sure if this is
correct or not, please advise." which is NOT what you did here at all.
You were not asking for help, you were claiming that these were
legitimate fixes, which you KNEW to be incorrect.

A few minutes with anyone with the semblance of knowledge of C can see
that your submissions do NOT do anything at all, so to think that a tool
created them, and then that you thought they were a valid "fix" is
totally negligent on your part, not ours.  You are the one at fault, it
is not our job to be the test subjects of a tool you create.

Our community welcomes developers who wish to help and enhance Linux.
That is NOT what you are attempting to do here, so please do not try to
frame it that way.

Our community does not appreciate being experimented on, and being
"tested" by submitting known patches that are either do nothing on
purpose, or introduce bugs on purpose.  If you wish to do work like
this, I suggest you find a different community to run your experiments
on, you are not welcome here.

Because of this, I will now have to ban all future contributions from
your University and rip out your previous contributions, as they were
obviously submitted in bad-faith with the intent to cause problems.

*plonk*

greg k-h
