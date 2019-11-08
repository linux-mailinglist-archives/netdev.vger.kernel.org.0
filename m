Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FAAF616C
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfKIU3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:29:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfKIU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 898621474DF34;
        Sat,  9 Nov 2019 12:29:35 -0800 (PST)
Date:   Fri, 08 Nov 2019 12:22:17 -0800 (PST)
Message-Id: <20191108.122217.435145615535120226.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, pabeni@redhat.com, dcaratti@redhat.com
Subject: Re: [PATCH net-next] net/sched: annotate lockless accesses to
 qdisc->empty
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108164523.211656-1-edumazet@google.com>
References: <20191108164523.211656-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  8 Nov 2019 08:45:23 -0800

> KCSAN reported the following race [1]
> 
> BUG: KCSAN: data-race in __dev_queue_xmit / net_tx_action
 ...
> Fixes: d518d2ed8640 ("net/sched: fix race between deactivation and dequeue for NOLOCK qdisc")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Series applied, thanks.
