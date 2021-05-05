Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69480373E79
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhEEP0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:26:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44274 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEEP0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:26:44 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6D6216412D;
        Wed,  5 May 2021 17:25:03 +0200 (CEST)
Date:   Wed, 5 May 2021 17:25:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nfnetlink: add a missing rcu_read_unlock()
Message-ID: <20210505152544.GA18093@salvia>
References: <20210505073324.1985884-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210505073324.1985884-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:33:24AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Reported by syzbot :
> BUG: sleeping function called from invalid context at include/linux/sched/mm.h:201
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 26899, name: syz-executor.5
> 1 lock held by syz-executor.5/26899:
>  #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_get_subsys net/netfilter/nfnetlink.c:148 [inline]
>  #0: ffffffff8bf797a0 (rcu_read_lock){....}-{1:2}, at: nfnetlink_rcv_msg+0x1da/0x1300 net/netfilter/nfnetlink.c:226
[...]

Applied, thanks.
