Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C125B31984E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBLCUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhBLCUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E175164E58;
        Fri, 12 Feb 2021 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613096407;
        bh=GLwgvOklUXd8yPRHO9qf8fcjVeJDuHeRv44glotC5Lo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AGI6lN0ZsFRcnFnWGsip6WkYCmf8buJR2JUwjk1t0tSc9NO6RCuSHTBC6v7wjNl8E
         XTD+s6rcKVWlOml6PoaYBbFfGmmNSQtV+03fChtUsM1vFKn801AkHJ9qxw0ighUFsA
         j4BJaRqlX0YVeCyYI2UU4/rGPYnNk25feRGcFbg0eZNbOuAD21667qWqompA69I37V
         /h01mDudwp+FmpB1+op0bo73g2hLm3JYQ1Ccu22qikset3+FKkyPPgdIlLcQJVJPrG
         hyPou53xj5k5Ye6hMfaAjRbIYy7alTJt8y19zpmIdvIR081kOdW+igkhh9ZanNn2R6
         y0jH8oF3YpA/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD25A60951;
        Fri, 12 Feb 2021 02:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] enetc: auto select PHYLIB and MDIO_DEVRES
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309640790.12988.9567147824111785521.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:20:07 +0000
References: <20210211175411.3115021-1-ztong0001@gmail.com>
In-Reply-To: <20210211175411.3115021-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 12:54:11 -0500 you wrote:
> FSL_ENETC_MDIO use symbols from PHYLIB (MDIO_BUS) and MDIO_DEVRES,
> however there are no dependency specified in Kconfig
> 
> ERROR: modpost: "__mdiobus_register" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> ERROR: modpost: "mdiobus_unregister" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> ERROR: modpost: "devm_mdiobus_alloc_size" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> 
> [...]

Here is the summary with links:
  - [v2] enetc: auto select PHYLIB and MDIO_DEVRES
    https://git.kernel.org/netdev/net/c/e185ea30df1f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


