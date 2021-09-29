Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F272641BCE1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243830AbhI2Cls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243780AbhI2Clr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 22:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 27F5B613D3;
        Wed, 29 Sep 2021 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632883207;
        bh=vyttKiTRpKiX+c1XWZLhMtl7fap84Wf2IEzo1r43MGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ah8LGWEsaiqhTtz13YwTuqRXRfqTD/d61E6BXz6zragAPY1r1irVBoWlzrUI4+qP9
         yoBylg85gAQB3euKaNL7034am+PfBiZul3DG2FZ/r+rVVlvr+DbXOeYsOYOByT0hjZ
         ueLL6r/nM2HgbG6I6rUVyHl4v1YSMusSOD0brdyMp+p+9+jt+OVMaRRKrcjaHRPjQd
         z321w3I/VNz2oT7fuKX055TxSBgTvgqOOn3IQvc4BfwVMoDWecRiqP3HyfIE3luXBp
         u3rYvv5AYWmA1qytNhBh7qWHyCBqcznfr+f1bJOIojy2B1OEoiNq53SQNzQc8u4Nds
         a0F1+/YzajZJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AD7E60A7E;
        Wed, 29 Sep 2021 02:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mdio-ipq4019: Fix the error for an optional regs
 resource
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163288320710.8381.14601947591964820575.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 02:40:07 +0000
References: <20210928134849.2092-1-caihuoqing@baidu.com>
In-Reply-To: <20210928134849.2092-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     andrew@lunn.ch, horatiu.vultur@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 21:48:49 +0800 you wrote:
> The second resource is optional which is only provided on the chipset
> IPQ5018. But the blamed commit ignores that and if the resource is
> not there it just fails.
> 
> the resource is used like this,
> 	if (priv->eth_ldo_rdy) {
> 		val = readl(priv->eth_ldo_rdy);
> 		val |= BIT(0);
> 		writel(val, priv->eth_ldo_rdy);
> 		fsleep(IPQ_PHY_SET_DELAY_US);
> 	}
> 
> [...]

Here is the summary with links:
  - [v2] net: mdio-ipq4019: Fix the error for an optional regs resource
    https://git.kernel.org/netdev/net/c/9e28cfead2f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


