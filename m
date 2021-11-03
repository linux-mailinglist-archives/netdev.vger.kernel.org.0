Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D4B443A9B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhKCAwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKCAwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD7D461053;
        Wed,  3 Nov 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635900607;
        bh=pXanHivoSA8pDTg1iXcxBAp0o1QlewgFg7cjw7Gf+DY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ayN71bU+bPsE/t+exgdaEkbk+rTw4szcTD0mPf2tEx/LJALA+ZkuCwPztSARC+h4/
         TaSYRNjCfVBQi7vsQtL4kpRmsbNWHkOj0OCriHAp+X+NORZ2mHi5HEtrrboNmaGnyS
         RV88MscdtCkVwZZULZeKaOG306UufpQ2a7+rfTSU859hta111676cIRage7n/XNFuB
         S3E4vjQcEeYbhiV0pu5HIZ/0VxOKk6gfnu45SD2n75EdrLOqQXr4IifOku8MnSIxP+
         qmpTcCW2WmFtowGFc70q33BMI/B+FwOxxn9kjdHeFYeKT+A/p7MafTLM0fCsU+vSec
         clBMFgEYxzyAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A471760AA2;
        Wed,  3 Nov 2021 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: phy: microchip_t1: add lan87xx_config_rgmii_delay for
 lan87xx phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590060766.14144.12452755554911235374.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 00:50:07 +0000
References: <20211101162119.29275-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211101162119.29275-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nisar.sayed@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 1 Nov 2021 12:21:19 -0400 you wrote:
> Add a function to initialize phy rgmii delay according to phydev->interface.
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/phy/microchip_t1.c | 44 +++++++++++++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: phy: microchip_t1: add lan87xx_config_rgmii_delay for lan87xx phy
    https://git.kernel.org/netdev/net/c/26499499cae6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


