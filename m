Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FFB4615F0
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377740AbhK2NPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:15:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56424 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377866AbhK2NN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:13:29 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D117614DD;
        Mon, 29 Nov 2021 13:10:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id C21136056B;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191410;
        bh=4/FUQ6sCWVSNy11waCAPGRKn8mjBgIrzw3mCdbUT5xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BfGh8VpMRjSOrNn6zY6auyzt/HG88yJinS2PqTX/h4A4ii1eMKCNllDCzkSJMWOTx
         FHnO4auyxv0WI03KSmuYljdWuoI/+5gT8q3etZIGXvmL8gdhY6dZFHHsHCN4CxcuB7
         BtnsJLlAeskS3Bl3zrrIxR+K+mO6DG0PurpcDJPOYECO32bFlOlhv7iunivoMD7ULJ
         +wlfCQwMqnpZXof7XTWuwDlZkY9b74CVgRstkUVlQvs+zVNEe5CPC1LhIz2DB40RTo
         J9QhFhMxA6yCwNr+V6xmhVl9zraXQsdEwqVAeDBaJ9g1wPQKQA2V+7fDpfsTL3L8T9
         v6+tLD1F9a+xw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BBA3A60A4D;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/6] net: lan966x: Add lan966x switch driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819141076.10588.6077476574401792061.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:10 +0000
References: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, andrew@lunn.ch, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 13:43:53 +0100 you wrote:
> This patch series add support for Microchip lan966x driver
> 
> The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
> two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
> it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
> 2 Quad-SGMII/Quad-USGMII interfaces.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/6] dt-bindings: net: lan966x: Add lan966x-switch bindings
    https://git.kernel.org/netdev/net-next/c/642fcf53a9ac
  - [net-next,v5,2/6] net: lan966x: add the basic lan966x driver
    https://git.kernel.org/netdev/net-next/c/db8bcaad5393
  - [net-next,v5,3/6] net: lan966x: add port module support
    https://git.kernel.org/netdev/net-next/c/d28d6d2e37d1
  - [net-next,v5,4/6] net: lan966x: add mactable support
    https://git.kernel.org/netdev/net-next/c/e18aba8941b4
  - [net-next,v5,5/6] net: lan966x: add ethtool configuration and statistics
    https://git.kernel.org/netdev/net-next/c/12c2d0a5b8e2
  - [net-next,v5,6/6] net: lan966x: Update MAINTAINERS to include lan966x driver
    https://git.kernel.org/netdev/net-next/c/813f38bf3b89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


