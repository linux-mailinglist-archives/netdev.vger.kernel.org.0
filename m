Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D211859F9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgCOEEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:04:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgCOEED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:04:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1737A15B7531B;
        Sat, 14 Mar 2020 21:04:03 -0700 (PDT)
Date:   Sat, 14 Mar 2020 21:04:02 -0700 (PDT)
Message-Id: <20200314.210402.573725635566592048.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mrv@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 0/6] RED: Introduce an ECN tail-dropping
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 21:04:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Wed, 11 Mar 2020 19:33:50 +0200

> When the RED qdisc is currently configured to enable ECN, the RED algorithm
> is used to decide whether a certain SKB should be marked. If that SKB is
> not ECN-capable, it is early-dropped.
> 
> It is also possible to keep all traffic in the queue, and just mark the
> ECN-capable subset of it, as appropriate under the RED algorithm. Some
> switches support this mode, and some installations make use of it.
> There is currently no way to put the RED qdiscs to this mode.
> 
> Therefore this patchset adds a new RED flag, TC_RED_TAILDROP. When the
> qdisc is configured with this flag, non-ECT traffic is enqueued (and
> tail-dropped when the queue size is exhausted) instead of being
> early-dropped.
 ...

Series applied, thank you.
