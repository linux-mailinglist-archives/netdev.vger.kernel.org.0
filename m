Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75E72E03F5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgLVBks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgLVBkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0100922B3B;
        Tue, 22 Dec 2020 01:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601207;
        bh=mFJ9uJwG/Ga4MBEeCXkFIM3OnCeCKygT8n1845OcY4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LVbQLHHUkbQqGhfVjObiEm68l1iDj02izZ8rQY7OmMZnQuixhMRvpmMULIDAMDoQg
         c/6JE+VxHM92WsKeSwbygp8/lwiFBKSGBqxnSizZmOWxfbqBJw3ypa3oCk1XDsXohj
         7HeAySIwTh9gFXmZN4V2vIhklxcmw0m7K//Cuugn2VE8hsK+uJh+zro6W/S8TtF/eh
         XiQTD8+KgI1XZg+C7+4XdcdLoQU+ERbBiOKtfDqz0eHICZTfw91sx1CoMKXNoaJX0R
         PBIyV3ck0/BnVfF4xc2SsGljlQG9I7t7MUAL3cTnkEJ/US+L7pbkfRM351/WQXEmGt
         dAYUUXUemyqUw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E7AC3603F8;
        Tue, 22 Dec 2020 01:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] ucc_geth fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160860120694.2677.17012683397474495715.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Dec 2020 01:40:06 +0000
References: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        qiang.zhao@nxp.com, leoyang.li@nxp.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Dec 2020 11:55:35 +0100 you wrote:
> This is three bug fixes that fell out of a series of cleanups of the
> ucc_geth driver. Please consider applying via the net tree.
> 
> v2: reorder and split off from larger series; add Andrew's R-b to
> patch 1; only move the free_netdev() call in patch 3.
> 
> Rasmus Villemoes (3):
>   ethernet: ucc_geth: set dev->max_mtu to 1518
>   ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
>   ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] ethernet: ucc_geth: set dev->max_mtu to 1518
    https://git.kernel.org/netdev/net/c/1385ae5c30f2
  - [net,v2,2/3] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
    https://git.kernel.org/netdev/net/c/887078de2a23
  - [net,v2,3/3] ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
    https://git.kernel.org/netdev/net/c/e925e0cd2a70

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


