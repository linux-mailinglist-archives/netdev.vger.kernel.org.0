Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BADB434C43
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJTNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229897AbhJTNmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 210F2610A2;
        Wed, 20 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737207;
        bh=v/Yz/RhgXKv6Z0VUCgcxaAFGuFt+Hi0Djcd53thZoSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z0wTzacpVgFilUT1LqbMKntJAGVcDDNGw9x7mWBJbeO9MftO3gv8Pt++6X2WZ5xJs
         87y14KxwjQqiOaeGaJMv+etUbdpgMKQXkVb/ywDMRTy2lJmApQXQWCtcx7PkIRKNIT
         zl9SHvOQ3PHGhB3RJzSquuTGoIPpbGHszwL34DiBAboKu4yr19K6bjmLrZXcDCbW/Y
         rA1xLj33ZwaXgtXvvIh41t5eSNPdh1+ZJ+zJrt9FpCHx3LJD8DNn0NNIKypUO/cjX4
         oBNEjaGBr3qa5sjFFm8lZz8IkGsGbJ8mBB/4pxhpL/N13A9DM7rwty1cj6NjuWvhSW
         SIyfiHK24/6YQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FCBA60A24;
        Wed, 20 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] phy: micrel: ksz8041nl: do not use power down
 mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473720705.8032.5657511877917396635.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:40:07 +0000
References: <20211019191647.346361-1-francesco.dolcini@toradex.com>
In-Reply-To: <20211019191647.346361-1-francesco.dolcini@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, nicolas.ferre@microchip.com,
        bbrezillon@kernel.org, patrice.vilchez@atmel.com, stefan@agner.ch,
        f.fainelli@gmail.com, christophe.leroy@csgroup.eu,
        sergei.shtylyov@gmail.com, marcel.ziswiler@toradex.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 21:16:47 +0200 you wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> Some Micrel KSZ8041NL PHY chips exhibit continuous RX errors after using
> the power down mode bit (0.11). If the PHY is taken out of power down
> mode in a certain temperature range, the PHY enters a weird state which
> leads to continuously reporting RX errors. In that state, the MAC is not
> able to receive or send any Ethernet frames and the activity LED is
> constantly blinking. Since Linux is using the suspend callback when the
> interface is taken down, ending up in that state can easily happen
> during a normal startup.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] phy: micrel: ksz8041nl: do not use power down mode
    https://git.kernel.org/netdev/net-next/c/2641b62d2fab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


