Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D034B189
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZVuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhCZVuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 17:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 26F6C61A10;
        Fri, 26 Mar 2021 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616795411;
        bh=bcdCzp4pAv3xlxjBrP8WxheeUABuPbFUKDaRjd+VNZk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uU0IYMdgWeX8b8S7aPy22jpI7C7iMJt0e5stC3UK005X2EJ+e4uVcVBlWeRBwnUWH
         Ajwk42C3qPwI0t0+XoS6FE8lCi2ZioWY2Gn069e8R9KMP+5kGzJJ2MCn2ATmRPZ/Wn
         9XOhq2H2Slp783zF89uUP/QntHdq8mQTk06QP/0pqWYuSdP08Rjgm7V5Bw46Y8YCRq
         MC8QY9SQEqEf2dQgLhFjMga5sddCGR3dCPAdNOHMQeVPyOHDsRV7pR9fX3DKaueIX8
         /ROdY0ijj6LT2D9tPb6of6RBkFcCA31UWs0FQanBfzk+ljAgYtSBzj8emv/uiaj2Cw
         FRRmSgS4dYwqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF07260970;
        Fri, 26 Mar 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] net: stmmac: enable multi-vector MSI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679541097.17455.17342387440492933878.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 21:50:10 +0000
References: <20210325173916.13203-1-weifeng.voon@intel.com>
In-Reply-To: <20210325173916.13203-1-weifeng.voon@intel.com>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joabreu@synopsys.com, kuba@kernel.org, peppe.cavallaro@st.com,
        andrew@lunn.ch, alexandre.torgue@st.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, boon.leong.ong@intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 01:39:11 +0800 you wrote:
> This patchset adds support for multi MSI interrupts in addition to
> current single common interrupt implementation. Each MSI interrupt is tied
> to a newly introduce interrupt service routine(ISR). Hence, each interrupt
> will only go through the corresponding ISR.
> 
> In order to increase the efficiency, enabling multi MSI interrupt will
> automatically select the interrupt mode configuration INTM=1. When INTM=1,
> the TX/RX transfer complete signal will only asserted on corresponding
> sbd_perch_tx_intr_o[] or sbd_perch_rx_intr_o[] without asserting signal
> on the common sbd_intr_o. Hence, for each TX/RX interrupts, only the
> corresponding ISR will be triggered.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] net: stmmac: introduce DMA interrupt status masking per traffic direction
    https://git.kernel.org/netdev/net-next/c/7e1c520c0d20
  - [v2,net-next,2/5] net: stmmac: make stmmac_interrupt() function more friendly to MSI
    https://git.kernel.org/netdev/net-next/c/29e6573c61aa
  - [v2,net-next,3/5] net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX
    https://git.kernel.org/netdev/net-next/c/8532f613bc78
  - [v2,net-next,4/5] stmmac: intel: add support for multi-vector msi and msi-x
    https://git.kernel.org/netdev/net-next/c/b42446b9b37b
  - [v2,net-next,5/5] net: stmmac: use interrupt mode INTM=1 for multi-MSI
    https://git.kernel.org/netdev/net-next/c/6ccf12ae111e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


