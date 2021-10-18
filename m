Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A1431BE3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhJRNft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232934AbhJRNeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E8B0613A8;
        Mon, 18 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634563810;
        bh=Aa1DT3/aO+8pNsk40S8yWCfB7ApcUbciD7ozhLoSznU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZPDNXyT98gYQeND+CXNBfYJrRGNirs46wLP8dfF5B4g0z+5+u34sAFytY2Jta1wAp
         Zpwq0lYbucd/y+NCrTqgt/p6Ug92kSo94BFEGVUf2S0CxgVQx4EHTDmrxMlx4ovhAn
         n4OhjxxvQeKhcTmXXSWO8EtpLqddGB66FfaCiuOTyI8jcN50muUfkeCeBCHrAZS7RT
         shHxWh6bfVZOyOCxs8HDWSqR/TisfV+XQ8G4kjh2uTgZ7FkVZxWOqqv9IsOUfaX4xA
         2gLB4YkvLQnu79f9OWO3cFsPmi545g1BAK8W8j2RaOQ6Wfkw3onzUkjJbm+iHIatcY
         uAseVrBjhJZag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 432D060971;
        Mon, 18 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/7] net: dsa: add support for RTL8365MB-VC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456381026.15402.11468820446338383690.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 13:30:10 +0000
References: <20211018093804.3115191-1-alvin@pqrs.dk>
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, arinc.unal@arinc9.com, alsi@bang-olufsen.dk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 11:37:55 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This series adds support for Realtek's RTL8365MB-VC, a 4+1 port
> 10/100/1000M Ethernet switch. The driver - rtl8365mb - was developed by
> Michael Ramussen and myself.
> 
> This version of the driver is relatively slim, implementing only the
> standalone port functionality and no offload capabilities. It is based
> on a previous RFC series [1] from August, and the main difference is the
> removal of some spurious VLAN operations. Otherwise I have simply
> addressed most of the feedback. Please see the respective patches for
> more detail.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/7] ether: add EtherType for proprietary Realtek protocols
    https://git.kernel.org/netdev/net-next/c/7bbbbfaa7a1b
  - [v4,net-next,2/7] net: dsa: allow reporting of standard ethtool stats for slave devices
    https://git.kernel.org/netdev/net-next/c/487d3855b641
  - [v4,net-next,3/7] net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
    https://git.kernel.org/netdev/net-next/c/9cb8edda2157
  - [v4,net-next,4/7] dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
    https://git.kernel.org/netdev/net-next/c/2e405875f39f
  - [v4,net-next,5/7] net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
    https://git.kernel.org/netdev/net-next/c/1521d5adfc2b
  - [v4,net-next,6/7] net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
    https://git.kernel.org/netdev/net-next/c/4af2950c50c8
  - [v4,net-next,7/7] net: phy: realtek: add support for RTL8365MB-VC internal PHYs
    https://git.kernel.org/netdev/net-next/c/2ca2969aae1e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


