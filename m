Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA342106E
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhJDNoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238684AbhJDNmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 09:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 179FB61B4C;
        Mon,  4 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633353608;
        bh=wctr9OQopyU4Q7p4yxTcl6SNAzDnul3JUsoyAkxyIwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qGrXL3zlO0aldCm0azF1Hx/1Wr8vMOGpw4hOryl0cbMVih9l6EN0OhlBtqcp2D2ki
         ZL7t8DGgHTEyIMuEdkJcOvDzhZkRwmTFn0GwD3LlmxcyiF6zcM+DPbGczWW/WS07Uv
         r3cWh3KNT3SosolQ4HvFVH7CSU3rqh3riZpEt2wB+ak7DZUXhrzJZGBQtTBWP3Tltm
         KOMs2NDT+76WUR+eWRnHSebLji4Zq6Kf/SqrLmw+auNGWi3VgI3YnFbmrkpJFLH9uz
         biSRvtXqnT1hRqrd58sZovwTTn/7fNf5FkiyKm/j/qBYcsjAzRb3kKlEon4ZoW/brS
         +2abt3/vpu9cA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07FF360A02;
        Mon,  4 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add phylink helper for 10G modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163335360802.25690.9874248968746719051.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 13:20:08 +0000
References: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
In-Reply-To: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, ioana.ciornei@nxp.com, kuba@kernel.org,
        mw@semihalf.com, netdev@vger.kernel.org,
        nicolas.ferre@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 4 Oct 2021 12:02:36 +0100 you wrote:
> Hi,
> 
> During the last cycle, there was discussion about adding a helper
> to set the 10G link modes for phylink, which resulted in these two
> patches introduce such a helper.
> 
>  drivers/net/ethernet/cadence/macb_main.c         |  7 +------
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  7 +------
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  7 +------
>  drivers/net/phy/phylink.c                        | 11 +++++++++++
>  include/linux/phylink.h                          |  1 +
>  5 files changed, 15 insertions(+), 18 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: phylink: add phylink_set_10g_modes() helper
    https://git.kernel.org/netdev/net-next/c/a2c27a61b433
  - [net-next,2/2] net: ethernet: use phylink_set_10g_modes()
    https://git.kernel.org/netdev/net-next/c/14ad41c74f6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


