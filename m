Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D08736B1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfGXShP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbfGXShP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 14:37:15 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECBA42173B;
        Wed, 24 Jul 2019 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563993434;
        bh=tb1yBoYnFaWG6mahNMfY72POj83PUfuPV2T0fEbS7EI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SsBk6ptk456duEqnAc2K2yrM4uGu1DHk0/jUojwW79I7W6NLqiTJZD7/0yzzeFrwC
         ON2aK2A9wxisiOSqnQg9P70VDEuHRMuqIEha+ZjBnTj7InD2s59uJt3wBzDDHq7ZK/
         UGNZAFoEaOx0QY5rAu0sIJr3LIWvIuNCFHWPjVsU=
Date:   Wed, 24 Jul 2019 11:37:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190724183710.GF213255@gmail.com>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190724013813.GB643@sol.localdomain>
 <63f12327-dd4b-5210-4de2-705af6bc4ba4@gmail.com>
 <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724.111225.2257475150626507655.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:12:25AM -0700, David Miller wrote:
> From: Eric Biggers <ebiggers@kernel.org>
> Date: Wed, 24 Jul 2019 09:30:14 -0700
> 
> > On Wed, Jul 24, 2019 at 08:39:05AM +0200, Eric Dumazet wrote:
> >> Some of the bugs have been fixed already, before syzbot found them.
> >> 
> >> Why force human to be gentle to bots and actually replying to them ?
> >> 
> >> I usually simply wait that syzbot is finding the bug does not repro anymore,
> >> but now if you send these emails, we will have even more pressure on us.
> >> 
> > 
> > First, based on experience, I'd guess about 30-45 of these are still valid.  17
> > were seen in mainline in the last week, but some others are valid too.  The ones
> > most likely to still be valid are at the beginning of the list.  So let's try
> > not use the presence of outdated bugs as an excuse not to fix current bugs.
> 
> So about half of the bugs we are to look at are already fixed and thus
> noise, even as estimated by you.
> 
> I agree with Eric, these "reminders" are bad for the people you
> actually want to work on fixing these bugs.

Well, the problem is that no one knows for sure which bugs are fixed and which
aren't.  To be certain, a human needs to review each bug.  A bot can only guess.

Note that the bugs in my reminders are already automatically prioritized by how
likely they are to still be valid, important, actionable.  So one simply needs
to start at the beginning of the list if they want to focus on those types of
bugs.  Isn't this helpful?

> 
> > Since the kernel community is basically in continuous bug bankruptcy and lots of
> 
> I don't like this hyperbole.  Please present facts and information we
> can actually use to improve the kernel development and bug fixing
> process.
> 

A huge number of valid open bugs are not being fixed, which is a fact.  We can
argue about what words to use to describe this situation, but it doesn't change
the situation itself.

What is your proposed solution?

- Eric
