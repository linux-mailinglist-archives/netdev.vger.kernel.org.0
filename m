Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E8D3948B0
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhE1Wbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhE1Wbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2061613DD;
        Fri, 28 May 2021 22:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622241003;
        bh=6SbFveCqKG6S9JdpS8CuUefo1y87g52zpnK1afseF54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O3wjBmitPHofC9cPYjUSXBORgEnepcSj2k34MkcgvA2tIrFor3t7H542WnqgSxhfW
         W/t0upqT2eK1SxQg9FNEv+ZJFWxrxzgRfy8poA9awCgZU9MzH3GptgLqivI5gRik+7
         RFACUSt4y0UkiyxuPvu78i1g23bxzBbqvmymsMKs5Op01rjwRfq//Oo+bF/cNeFI8w
         vsf8WtXvudXhNPO8fnTVz/NNzmYKAo53wPTgV8IS6ytt5dEw7/iUnDf6TAhuddMWS+
         eRorQqGceVOyevJn6YSvMPW5+0uJhDrXlrntknbz/AIlBsxT+70LaTWPRV5cBKizxz
         lBbuMATl9Z+rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E8B060A6C;
        Fri, 28 May 2021 22:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: the XPCS obscures a potential "PHY not
 found" error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162224100364.24905.4782447721109832236.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 22:30:03 +0000
References: <20210527155959.3270478-1-olteanv@gmail.com>
In-Reply-To: <20210527155959.3270478-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        andrew@lunn.ch, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 18:59:59 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> stmmac_mdio_register() has logic to search for PHYs on the MDIO bus and
> assign them IRQ lines, as well as to set priv->plat->phy_addr.
> 
> If no PHY is found, the "found" variable remains set to 0 and the
> function errors out.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: the XPCS obscures a potential "PHY not found" error
    https://git.kernel.org/netdev/net-next/c/4751d2aa321f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


