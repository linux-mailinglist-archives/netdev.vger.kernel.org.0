Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87CE38CEF6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhEUUWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhEUUVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8819613E1;
        Fri, 21 May 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621628409;
        bh=q8v2SjC3my03Bn4XP59cLTAR2o6rdTrDWF2PrwcGrKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kXvR2oKSkuheSNSAcB/oNrDY1RICU5MLdA8PBnoQK1ZeJqQ3HFwfR8KHbs1dmSAXj
         xWU1UY00IsNM+uE1nlYPxtrWoYr9FpMiD032FBOoviNZi+ov//8OyWXb92Eo/dNi6l
         swc/j46ekURwdVySWn4iVtiiJFjJ3pw8IsFHZHjbw9xpU21ZlbQQhxODN5PnFZ9KKy
         c9s0to8sCVJGNTQwdmZki027HNV0dgkqLUBGVyEbI1Gt79TfsTO5v/s7/WCt6uKWnA
         mjDI4NFo0tsM/Mf+GD2l4d8Nw+au5ejbZRCzAjSUyv/NZMHNIDaYMWLYj6Qnx+PnkZ
         MVUdgvn664E5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AADE36096D;
        Fri, 21 May 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: Fix DIM support for MT7628/88
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162840969.7187.7128878018584185254.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:20:09 +0000
References: <20210520084319.1358911-1-sr@denx.de>
In-Reply-To: <20210520084319.1358911-1-sr@denx.de>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        ilya.lipnitskiy@gmail.com, code@reto-schneider.ch,
        reto.schneider@husqvarnagroup.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 20 May 2021 10:43:18 +0200 you wrote:
> When updating to latest mainline for some testing on the GARDENA smart
> gateway based on the MT7628, I noticed that ethernet does not work any
> more. Commit e9229ffd550b ("net: ethernet: mtk_eth_soc: implement
> dynamic interrupt moderation") introduced this problem, as it missed the
> RX_DIM & TX_DIM configuration for this SoC variant. This patch fixes
> this by calling mtk_dim_rx() & mtk_dim_tx() in this case as well.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: Fix DIM support for MT7628/88
    https://git.kernel.org/netdev/net/c/430bfe057612

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


