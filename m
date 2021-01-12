Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493672F25F2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbhALCAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhALCAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 21:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 069F7239CF;
        Tue, 12 Jan 2021 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610416809;
        bh=LrgX1ZCbyuuq7kQhKdxsUPQpCaUk3QGE4/HTzRzvuzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TfbwjhgY2jQEXUy1ogv5kiC0thNUvV4e1u52AjogPlL2kndcXSWzondkf3sAGbdwi
         +4Q4xVyCtLeo6p0hvxGXqYxVHX2lcJkja3afgiF53gxoCHpGflxpvVC9uvrcG8YrxM
         XLNkdu/bCEDhOAzNqM/XslMd4/SIz8Zp5vIw4IQd+4JO/Dci12tTc0TN1Oy1NNBG5X
         FOcpaxxNpNs6voSR8qY/vRR4ypAl/2TN9yibhxcD9dDiv8bHPnqEgOhJPBAu8yLnPu
         ogs71qo6uwfNkac+M38PCmAGerGpXbdi9Of8y5iCaKtQ2NuvD+VP0oEr4E4McU0RLn
         VAimK4XzwG40g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id F2DC06026B;
        Tue, 12 Jan 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041680898.7943.13175555467776041590.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 02:00:08 +0000
References: <1610289059-14962-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1610289059-14962-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org, liron@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 10 Jan 2021 16:30:59 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Patch didn't fix any issue, just improve parse flow
> and align ipv4 parse flow with ipv6 parse flow.
> 
> Currently ipv4 kenguru parser first check IP protocol(TCP/UDP)
> and then destination IP address.
> Patch introduce reverse ipv4 parse, first destination IP address parsed
> and only then IP protocol.
> This would allow extend capability for packet L4 parsing and align ipv4
> parsing flow with ipv6.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: prs: improve ipv4 parse flow
    https://git.kernel.org/netdev/net-next/c/c73a45965dd5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


