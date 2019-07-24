Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80F73661
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfGXSM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:12:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfGXSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:12:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69037154082D4;
        Wed, 24 Jul 2019 11:12:28 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:12:25 -0700 (PDT)
Message-Id: <20190724.111225.2257475150626507655.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724163014.GC673@sol.localdomain>
References: <20190724013813.GB643@sol.localdomain>
        <63f12327-dd4b-5210-4de2-705af6bc4ba4@gmail.com>
        <20190724163014.GC673@sol.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:12:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Wed, 24 Jul 2019 09:30:14 -0700

> On Wed, Jul 24, 2019 at 08:39:05AM +0200, Eric Dumazet wrote:
>> Some of the bugs have been fixed already, before syzbot found them.
>> 
>> Why force human to be gentle to bots and actually replying to them ?
>> 
>> I usually simply wait that syzbot is finding the bug does not repro anymore,
>> but now if you send these emails, we will have even more pressure on us.
>> 
> 
> First, based on experience, I'd guess about 30-45 of these are still valid.  17
> were seen in mainline in the last week, but some others are valid too.  The ones
> most likely to still be valid are at the beginning of the list.  So let's try
> not use the presence of outdated bugs as an excuse not to fix current bugs.

So about half of the bugs we are to look at are already fixed and thus
noise, even as estimated by you.

I agree with Eric, these "reminders" are bad for the people you
actually want to work on fixing these bugs.

> Since the kernel community is basically in continuous bug bankruptcy and lots of

I don't like this hyperbole.  Please present facts and information we
can actually use to improve the kernel development and bug fixing
process.

Thank you.
