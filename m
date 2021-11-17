Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C224545B2
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhKQLdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235024AbhKQLdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EB73161BD4;
        Wed, 17 Nov 2021 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637148612;
        bh=+4UkogvX7MWmUXG4MP1pSECUepXmv13B1vebNAG9YZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DiKLiCO36qAL6EFVufUUUheEuvA6frB8b0WmWEcuHSvNtAXA1wpRNRaMM6uSMwQn3
         2jm+v1VHHHKZogxM6VuwS1uqddQdUE/JVNX2vhw4wVl4FqTxgD2j+bFWNJx3gQ4WRy
         er101R/Tft4V5797OSjUbCeHurkgnHuXpkLaWx1Ry38c5J2+fxDzT/oYOH9nBQitJB
         nDuOgO/ZyCsb9FSopMZUVrlPSo8RCHF++2Vqd30oTuj+fVAsvPLP9q2M5uqYB8zMjT
         3MvcxzhWiIZqO6Pkl0oxh+ue3f+InCnXJ+ghGY1EsPOzl1qg9LRj+wXlfvhLxhn0RS
         tf5SPgpHmQrEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE92F609D3;
        Wed, 17 Nov 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ocelot_net: phylink validate
 implementation updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714861190.14428.7153356692022354036.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:30:11 +0000
References: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
In-Reply-To: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 10:08:58 +0000 you wrote:
> Hi,
> 
> This series converts ocelot_net to fill in the supported_interfaces
> member of phylink_config, cleans up the validate() implementation,
> and then converts to phylink_generic_validate().
> 
>  drivers/net/ethernet/mscc/ocelot_net.c | 41 +++++-----------------------------
>  1 file changed, 6 insertions(+), 35 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: ocelot_net: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/8ea8c5b492d4
  - [net-next,2/3] net: ocelot_net: remove interface checks in macb_validate()
    https://git.kernel.org/netdev/net-next/c/a6f5248bc0a3
  - [net-next,3/3] net: ocelot_net: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/7258aa5094db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


