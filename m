Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D2438DDFD
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhEWXVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 19:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhEWXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 19:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25D8D611AC;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621812010;
        bh=x5p/dM+y6WgNl1759vL9D093T512k+MSC0ZFKsh+6nU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nABZgPWelN43ssp3Ph+wYQSVdTLQ9rtVtCEjdF+Qe+UW8yDlERIVBfU8ezlvuRzRR
         iqRSLGejpcbNiCc3tLdRRCYmmjR7n5ugBNjhTq6LDF/+3mHN7KO5FPmMOAJLPrCLpa
         5evWDLBN/J0ZGnc5o0Rg2zUY2Mf001rwPZRe0PsU3pgwnG6C8pDsERwARNwlY/aajJ
         tOspcBJmojGW9LsbWlN+72yLenfvjHeZ16jKoEmExA6FSuPQip6sjLwEPeIV9Ohs/q
         UqIYiRnSWuTEaiZ7ecSwZE9cJFQ7ipTPokPk/gsMxQUsWkd4ea1iA1hjgIdMzL/AQK
         7YntGHM23XrNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AB0260A71;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: Fix packet statistics support
 for MT7628/88
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181201010.2631.11245974765163303600.git-patchwork-notify@kernel.org>
Date:   Sun, 23 May 2021 23:20:10 +0000
References: <20210522075630.2414801-1-sr@denx.de>
In-Reply-To: <20210522075630.2414801-1-sr@denx.de>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        ilya.lipnitskiy@gmail.com, code@reto-schneider.ch,
        reto.schneider@husqvarnagroup.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 22 May 2021 09:56:30 +0200 you wrote:
> The MT7628/88 SoC(s) have other (limited) packet counter registers than
> currently supported in the mtk_eth_soc driver. This patch adds support
> for reading these registers, so that the packet statistics are correctly
> updated.
> 
> Additionally the defines for the non-MT7628 variant packet counter
> registers are added and used in this patch instead of using hard coded
> values.
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88
    https://git.kernel.org/netdev/net/c/ad79fd2c42f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


