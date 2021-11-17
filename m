Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191FB454980
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhKQPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238759AbhKQPDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 10:03:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 411E261B7D;
        Wed, 17 Nov 2021 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637161214;
        bh=/SkZ/MaXtH4D1HA2GsALsMQuAhCuGrs5q1k2bXwV2Jo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M5deF0LEN/PBuiuF7jM1y2jVC1Ss5Vcrs5toShLef4zPwmOx7PReZp+AHA1tWB2S+
         tCo8b/onP6t1Pa5ZLGKJymSPXiofoKl9ranG8t3qXE73QZgbrJ0ttkTLr9YEv8XuHQ
         t0ZeM3KKECvsFE0PRzedfJFLlYeBy0rEhUJyanZGLCRvg2Kr+NuXTnWx6u+auF1pvf
         XOHT/9RYGLe5w7pIflAFNhIqT5s+Rrr9b07TW5N542x4/s67PTk6t4/kUjlLWHhylp
         GDAWJBe2DUDgfPMPZNTnUIZUGWRqCAdmF6y16EjziaNqEazOS6lVcjQg6J39s/i2nD
         dXPIyGYtJefPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3BA0060A4E;
        Wed, 17 Nov 2021 15:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: make dev_watchdog() less intrusive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716121423.17032.6421406360276025875.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 15:00:14 +0000
References: <20211117032924.1740327-1-eric.dumazet@gmail.com>
In-Reply-To: <20211117032924.1740327-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 19:29:20 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> dev_watchdog() is used on many NIC to periodically monitor TX queues
> to detect hangs.
> 
> Problem is : It stops all queues, then check them, then 'unfreeze' them.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: use an atomic_long_t for queue->trans_timeout
    https://git.kernel.org/netdev/net-next/c/8160fb43d55d
  - [net-next,2/4] net: annotate accesses to queue->trans_start
    https://git.kernel.org/netdev/net-next/c/5337824f4dc4
  - [net-next,3/4] net: do not inline netif_tx_lock()/netif_tx_unlock()
    https://git.kernel.org/netdev/net-next/c/dab8fe320726
  - [net-next,4/4] net: no longer stop all TX queues in dev_watchdog()
    https://git.kernel.org/netdev/net-next/c/bec251bc8b6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


