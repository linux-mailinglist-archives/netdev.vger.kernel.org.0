Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337BA467954
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381442AbhLCOXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381433AbhLCOXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747BCC061A2E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 06:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FCE962B84
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6628FC5674A;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541210;
        bh=NSS9hd0JDt8VEBDkmiyzMlPHzpS1EGaRBaUt+24CrTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7eTCm533aP5F2WdoTyc5MGwzCffaMo7hVvk4rbjsooxT/VxAARfzwgKjGaz+vic4
         vAEA/lyfjkZ805rrD25QowrPNnGM5d2lUpoSXh861aeSvXjhE4TEkCBgL379ed8st+
         2Ks4rBTv4KyJXT4HijkNOqgHkSHjUunhfDD5jBBX0JlZRpkhqRqV4/p1wUhZBilSI3
         dxn0aKpsxech4Z5Vqxg1uPFuC/SLhRsMOzjCmD9rNkoUMipwBWlT8btTtny4T3mb2T
         stptiFhGCS75idwRvGpv9i55NMVNEb8ICEO+PwOG9E5dDJGmv7NdJZ2kleoHkUMZno
         oEKIiDW8rzaxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5468C60A88;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: make tx_rebalance_counter an atomic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854121034.27426.15658166106050576001.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:20:10 +0000
References: <20211203022718.1036284-1-eric.dumazet@gmail.com>
In-Reply-To: <20211203022718.1036284-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 18:27:18 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> KCSAN reported a data-race [1] around tx_rebalance_counter
> which can be accessed from different contexts, without
> the protection of a lock/mutex.
> 
> [1]
> BUG: KCSAN: data-race in bond_alb_init_slave / bond_alb_monitor
> 
> [...]

Here is the summary with links:
  - [net] bonding: make tx_rebalance_counter an atomic
    https://git.kernel.org/netdev/net/c/dac8e00fb640

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


