Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A021859CA
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCODne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:43:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCODnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:43:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 366B915B75130;
        Sat, 14 Mar 2020 20:43:33 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:43:32 -0700 (PDT)
Message-Id: <20200314.204332.34522326258762384.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com,
        syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: keep alloc_hash updated after hash
 allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312054228.29688-2-xiyou.wangcong@gmail.com>
References: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
        <20200312054228.29688-2-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:43:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 11 Mar 2020 22:42:28 -0700

> In commit 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
> I moved cp->hash calculation before the first
> tcindex_alloc_perfect_hash(), but cp->alloc_hash is left untouched.
> This difference could lead to another out of bound access.
> 
> cp->alloc_hash should always be the size allocated, we should
> update it after this tcindex_alloc_perfect_hash().
> 
> Reported-and-tested-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
> Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Also applied and queued up for -stable, thanks.
