Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AC77B815
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 04:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfGaC5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 22:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfGaC5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 22:57:25 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2708206E0;
        Wed, 31 Jul 2019 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564541844;
        bh=oaJrCOH+JADa8zy97fYyMIm3ThsxnzOC4vYOhOEcIv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yVNe4M49GrbLbaKCuwRXYKsSFtH/KSl9apD2e2SUyP9PYL1k+R8wxgiR/4ApygZ4S
         29P6IfNYgLQkCaDMD27petYwc36lKZB8V6q9QsBBn0fmi9foMRPMQuTUCBLZe2JkDn
         seRrksdk3CZ5VpsUPLtQCQj9XOAxxP0fERR4BtwY=
Date:   Tue, 30 Jul 2019 19:57:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, dvyukov@google.com,
        netdev@vger.kernel.org, fw@strlen.de, i.maximets@samsung.com,
        edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190731025722.GE687@sol.localdomain>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, dvyukov@google.com,
        netdev@vger.kernel.org, fw@strlen.de, i.maximets@samsung.com,
        edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
 <20190724210950.GH213255@gmail.com>
 <1e07462d-61e2-9885-edd0-97a82dd7883e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e07462d-61e2-9885-edd0-97a82dd7883e@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 07:04:47AM +0200, Eric Dumazet wrote:
> 
> 
> On 7/24/19 11:09 PM, Eric Biggers wrote:
> > On Wed, Jul 24, 2019 at 01:09:28PM -0700, David Miller wrote:
> >> From: Eric Biggers <ebiggers@kernel.org>
> >> Date: Wed, 24 Jul 2019 11:37:12 -0700
> >>
> >>> We can argue about what words to use to describe this situation, but
> >>> it doesn't change the situation itself.
> >>
> >> And we should argue about those words because it matters to humans and
> >> effects how they feel, and humans ultimately fix these bugs.
> >>
> >> So please stop with the hyperbole.
> >>
> >> Thank you.
> > 
> > Okay, there are 151 bugs that syzbot saw on the mainline Linux kernel in the
> > last 7 days (90.1% with reproducers).  Of those, 59 were reported over 3 months
> > ago (89.8% with reproducers).  Of those, 12 were reported over a year ago (83.3%
> > with reproducers).
> > 
> > No opinion on whether those are small/medium/large numbers, in case it would
> > hurt someone's feelings.
> > 
> > These numbers do *not* include bugs that are still valid but weren't seen on
> > mainline in last 7 days, e.g.:
> > 
> > - Bugs that are seen only rarely, so by chance weren't seen in last 7 days.
> > - Bugs only in linux-next and/or subsystem branches.
> > - Bugs that were seen in mainline more than 7 days ago, and then only on
> >   linux-next or subsystem branch in last 7 days.
> > - Bugs that stopped being seen due to a change in syzkaller.
> > - Bugs that stopped being seen due to a change in kernel config.
> > - Bugs that stopped being seen due to other environment changes such as kernel
> >   command line parameters.
> > - Bugs that stopped being seen due to a kernel change that hid the bug but
> >   didn't actually fix it, i.e. still reachable in other ways.
> > 
> 
> We do not doubt syzkaller is an incredible tool.
> 
> But netdev@ and lkml@ are mailing lists for humans to interact,
> exchange ideas, send patches and review them.
> 
> To me, an issue that was reported to netdev by a real user is _way_ more important
> than potential issues that a bot might have found doing crazy things.
> 
> We need to keep optimal S/N on mailing lists, so any bots trying to interact
> with these lists must be very cautious and damn smart.
> 
> When I have time to spare and can work on syzbot reports, I am going to a web
> page where I can see them and select the ones it makes sense to fix.
> I hate having to set up email filters.
> 

syzbot finds a lot of security bugs, and security bugs are important.  And the
bugs are still there regardless of whether they're reported by human or bot.

Also, there *are* bugs being fixed because of these reminders; some subsystem
maintainers have even fixed all the bugs in their subsystem.  But I can
understand that for subsystems with a lot of open bug reports it's overwhelming.

What I'll try doing next time (if there *is* a next time; it isn't actually my
job to do any of this, I just care about the security and reliability of
Linux...) is for subsystems with lots of open bug reports, only listing the ones
actually seen in the last week or so, and perhaps also spending some more time
manually checking those bugs.  That should cut down the noise a lot.

- Eric
