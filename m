Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090B81A1994
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHBdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:33:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDHBdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:33:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 437B21210A3E3;
        Tue,  7 Apr 2020 18:33:12 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:33:11 -0700 (PDT)
Message-Id: <20200407.183311.1429584861130475659.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     ozsh@mellanox.com, roid@mellanox.com, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, kuba@kernel.org
Subject: Re: [PATCH net] net: sched: Fix setting last executed chain on skb
 extension
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1586187416-22454-1-git-send-email-paulb@mellanox.com>
References: <1586187416-22454-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:33:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Mon,  6 Apr 2020 18:36:56 +0300

> After driver sets the missed chain on the tc skb extension it is
> consumed (deleted) by tc_classify_ingress and tc jumps to that chain.
> If tc now misses on this chain (either no match, or no goto action),
> then last executed chain remains 0, and the skb extension is not re-added,
> and the next datapath (ovs) will start from 0.
> 
> Fix that by setting last executed chain to the chain read from the skb
> extension, so if there is a miss, we set it back.
> 
> Fixes: af699626ee26 ("net: sched: Support specifying a starting chain via tc skb ext")
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Applied, thank you.
