Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE19D740A9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbfGXVJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387568AbfGXVJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:09:53 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0516B2054F;
        Wed, 24 Jul 2019 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564002593;
        bh=u0DKWk7HCAdM9K+LNvrAozVOXRXioQba7PWbcuRuGbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISL8X1YreDGnnHZlrqkUMDyeJY403ARQ1AlYq7VdKyHA9wQjBSiWDz2/YwfXZtJCa
         ilTgdagZ+MTWkAEk/fLxBl9qVuHOprsZW+TM4v+2+kqsg0X10vC3QRsyXQ33g9R+BY
         5W3JjjbZ7osVcC727uC4MT57GcWTbzyFLXLRQ9ao=
Date:   Wed, 24 Jul 2019 14:09:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190724210950.GH213255@gmail.com>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724.130928.1854327585456756387.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 01:09:28PM -0700, David Miller wrote:
> From: Eric Biggers <ebiggers@kernel.org>
> Date: Wed, 24 Jul 2019 11:37:12 -0700
> 
> > We can argue about what words to use to describe this situation, but
> > it doesn't change the situation itself.
> 
> And we should argue about those words because it matters to humans and
> effects how they feel, and humans ultimately fix these bugs.
> 
> So please stop with the hyperbole.
> 
> Thank you.

Okay, there are 151 bugs that syzbot saw on the mainline Linux kernel in the
last 7 days (90.1% with reproducers).  Of those, 59 were reported over 3 months
ago (89.8% with reproducers).  Of those, 12 were reported over a year ago (83.3%
with reproducers).

No opinion on whether those are small/medium/large numbers, in case it would
hurt someone's feelings.

These numbers do *not* include bugs that are still valid but weren't seen on
mainline in last 7 days, e.g.:

- Bugs that are seen only rarely, so by chance weren't seen in last 7 days.
- Bugs only in linux-next and/or subsystem branches.
- Bugs that were seen in mainline more than 7 days ago, and then only on
  linux-next or subsystem branch in last 7 days.
- Bugs that stopped being seen due to a change in syzkaller.
- Bugs that stopped being seen due to a change in kernel config.
- Bugs that stopped being seen due to other environment changes such as kernel
  command line parameters.
- Bugs that stopped being seen due to a kernel change that hid the bug but
  didn't actually fix it, i.e. still reachable in other ways.

Eric
