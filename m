Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D6B426DA9
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbhJHPmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243044AbhJHPmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 11:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2AF6F6101A;
        Fri,  8 Oct 2021 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633707608;
        bh=oy4preGw7XfApUbZDOMs3U0wYeNgcpFMRUEsZTZESQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fjep3hopdnbdDawObH0E7DLdxDCCpnbnmQlOnOIDCyT1jY3RMih/4vDDgUuM+zbta
         0iU36+4yCZMf9bzI+dJeXjMilGVsoRJC7Yq7tKBwHKs584WWe23+GOm90qH5pJqhJZ
         hLQqXOcPpsxDZCar8nikqRDYPfjeVzrXj5q/j/BORH9fL2nVwvCpvWnCi/1QNkrp2g
         jLXneBM1D1IoKuWFPayA4YK6TdFA559Aal+08Fv4Nb5X/al/y7QEl3ztl7kYH7y7kK
         VQzpyYNwtwesxq8kO8XpLZ/NUzNq73q+vtAQdDzUmgMNR7XiO6Yl1k8kYMVI4HYOe7
         fpuOQOcTx9wJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B3D560A44;
        Fri,  8 Oct 2021 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] net: stmmac: fix regression on SPEAr3xx SOC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370760810.7751.16013434452322511469.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 15:40:08 +0000
References: <20211008103440.3929006-1-herve.codina@bootlin.com>
In-Reply-To: <20211008103440.3929006-1-herve.codina@bootlin.com>
To:     Herve Codina <herve.codina@bootlin.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        vireshk@kernel.org, shiraz.linux.kernel@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 12:34:36 +0200 you wrote:
> The ethernet driver used on old SPEAr3xx soc was previously supported on old
> kernel. Some regressions were introduced during the different updates leading
> to a broken driver for this soc.
> 
> This series fixes these regressions and brings back ethernet on SPEAr3xx.
> Tested on a SPEAr320 board.
> 
> [...]

Here is the summary with links:
  - [1/4] net: stmmac: fix get_hw_feature() on old hardware
    https://git.kernel.org/netdev/net/c/075da584bae2
  - [2/4] dt-bindings: net: snps,dwmac: add dwmac 3.40a IP version
    https://git.kernel.org/netdev/net/c/3781b6ad2ee1
  - [3/4] net: stmmac: add support for dwmac 3.40a
    https://git.kernel.org/netdev/net/c/9cb1d19f47fa
  - [4/4] ARM: dts: spear3xx: Fix gmac node
    https://git.kernel.org/netdev/net/c/6636fec29cdf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


