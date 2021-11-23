Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED3045A2DB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbhKWMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhKWMnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 87BFA61053;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637671209;
        bh=jj67PJmdQhCocA8rvNSmFWcdiGJtjGRbQXIwZQIxHl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YFQj+XgSUkHqBtc15bf4LgZ6BXeqtNWjDeYq37ADOC8tYgD1OZLE5BNJHit4PElCA
         95eNWthtFiOOtYZY/T7MoK0tcg0MaYWyZxNPKe04wATix4UQ0QbRgDJk36i3KvSCri
         qTzwe3jnaauPqe24J3uCcXB1F2IPhRqMeCmaZjHRbz4FDVCMWwgGIwqtyJw+iZBs4e
         0HUSTA1pPQSgW5gHGqgI/t0aGaGW5w7DTqa4VjEVkpGjaxPY5PafPKKdwOKg/4ptJm
         nvA1p7BNqscB6/rt0qh6s2iHtxPPQEnnYGr4/0S8XfIFVtH5n0NkjxjLenZ28FGCpX
         HC7XFWKIpGv8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BB2260A4E;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: mvpp2: increase MTU limit when XDP enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767120950.19545.7638320761973850657.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:40:09 +0000
References: <20211122200834.29219-1-kabel@kernel.org>
In-Reply-To: <20211122200834.29219-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        sven.auhagen@voleatech.de, brouer@redhat.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 21:08:34 +0100 you wrote:
> Currently mvpp2_xdp_setup won't allow attaching XDP program if
>   mtu > ETH_DATA_LEN (1500).
> 
> The mvpp2_change_mtu on the other hand checks whether
>   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> 
> These two checks are semantically different.
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: mvpp2: increase MTU limit when XDP enabled
    https://git.kernel.org/netdev/net/c/7b1b62bc1e6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


