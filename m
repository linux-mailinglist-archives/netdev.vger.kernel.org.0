Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA60B3181
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfIOSzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:55:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfIOSzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:55:11 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3796E153ECDA5;
        Sun, 15 Sep 2019 11:55:10 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:55:08 +0100 (WEST)
Message-Id: <20190915.195508.57263100187589453.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        torvalds@linux-foundation.org, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net v2] net_sched: let qdisc_put() accept NULL pointer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912172230.9635-1-xiyou.wangcong@gmail.com>
References: <20190912172230.9635-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:55:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 12 Sep 2019 10:22:30 -0700

> When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
> pointer which leads to a crash in sfb_destroy(). Similar for
> sch_dsmark.
> 
> Instead of fixing each separately, Linus suggested to just accept
> NULL pointer in qdisc_put(), which would make callers easier.
> 
> (For sch_dsmark, the bug probably exists long before commit
> 6529eaba33f0.)
> 
> Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
> Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
