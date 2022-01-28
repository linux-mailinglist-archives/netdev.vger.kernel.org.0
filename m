Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458DD49FC7C
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349522AbiA1PKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349504AbiA1PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A38BC06173B;
        Fri, 28 Jan 2022 07:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7494CE26B8;
        Fri, 28 Jan 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 597C9C340F7;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=XPp8QlBC8+NBkO5LdYVNcNqgl/cTHEgNVfKwDN1oOrc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HNdycBX9bx9Rf1C6OFG/l9O0RKrrt1H1VUufS4zWNbo0fkOZ4x+gAwKs4FI9lrahP
         JYFvlq8cZPeOJMxtDaAXR8W113kyN+jHCXmaMp8SBBTrINGRxxZEgFye7P8l+O8mSd
         GH9Kgjt/ZNoQE21/QxrIsY5IWle1vGP/AHwXUqOxIApyMUGxwevGkfn96fKwtoxkwn
         RkYSxakr23h8q/AP0RVM4uw07MhoNBr3hgC1sB5miRTSv/TNmIPoadP3WP8AelznEg
         Hz30YwjHNX8ZW/QvSkCXSkvI2jl5Jm3rNry+/bmejIzrhrW1OjQn8D1ii78RqX7Q/y
         IU6XxRGe5X1TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 423AFE6BB30;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net/fsl: xgmac_mdio: Fix spelling mistake "frequecy" ->
 "frequency"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261725.2420.15157207073443007637.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220128092531.7455-1-colin.i.king@gmail.com>
In-Reply-To: <20220128092531.7455-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 09:25:31 +0000 you wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net/fsl: xgmac_mdio: Fix spelling mistake "frequecy" -> "frequency"
    https://git.kernel.org/netdev/net-next/c/34a79c5dca4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


