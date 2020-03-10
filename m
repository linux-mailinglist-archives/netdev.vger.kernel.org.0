Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FDB17ED8A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCJBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:01:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgCJBBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:01:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD1CE15A01687;
        Mon,  9 Mar 2020 18:01:53 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:01:53 -0700 (PDT)
Message-Id: <20200309.180153.196067393732510885.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mahesh@bandewar.net,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipvlan: add cond_resched_rcu() while processing
 muticast backlog
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309225702.63695-1-maheshb@google.com>
References: <20200309225702.63695-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:01:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Mon,  9 Mar 2020 15:57:02 -0700

> If there are substantial number of slaves created as simulated by
> Syzbot, the backlog processing could take much longer and result
> into the issue found in the Syzbot report.
> 
> INFO: rcu_sched detected stalls on CPUs/tasks:
>         (detected by 1, t=10502 jiffies, g=5049, c=5048, q=752)
 ...
> 
> Fixes: ba35f8588f47 (“ipvlan: Defer multicast / broadcast processing to a work-queue”)
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
