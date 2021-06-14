Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E993A6FB8
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbhFNUCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhFNUCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA8D16134F;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700805;
        bh=NIL6FfVydqrHqY5U+xnw0XMWti5Sw6fy702fap4tuh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzCK0COPe+PpdC4R5qkrJeazSk9aBH12/fLBbE7dIOCir7CQRd3de2aEEjnqj7Fnl
         PmbP9dZV0Ik4GRIFk/k5n+M+48pF4Rk95w3oRoiTMtOVUGdWv5Lo5lM+ZIp8WNPLdk
         MsVqgYEWb/ROZ+swUjwOJDVtCFw5ZxQKOad1cmwJJuy8fpXWy3iQxVRsqdYJPZfsK/
         4Fl9GG6pYFQF3+W2O5ZDCYGsA/Hxh5q0nKkemz/pRk4xvCycOuo4m3yXDWJ3HdoV3l
         zbxsCnnSmuTiWx7TVmhQo9BUtslF08s++/JqcRC8itGnErBh+L/EbQrdyvmNJCJsvZ
         wzhfWP3ij7EZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DAD5609D8;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/8] provide cable test support for the ksz886x
 switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370080564.15507.12458489307428965124.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:00:05 +0000
References: <20210614043125.11658-1-o.rempel@pengutronix.de>
In-Reply-To: <20210614043125.11658-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        m.grzeschik@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 06:31:17 +0200 you wrote:
> changes v5:
> - drop resume() patch
> - add Reviewed-by tags.
> - rework dsa_slave_phy_connect() patch
> 
> changes v4:
> - use fallthrough;
> - use EOPNOTSUPP instead of ENOTSUPP
> - drop flags variable in dsa_slave_phy_connect patch
> - extend description for the "net: phy: micrel: apply resume errat"
>   patch
> - fix "use consistent alignments" patch
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/8] net: phy: micrel: move phy reg offsets to common header
    https://git.kernel.org/netdev/net-next/c/ec4b94f9b37b
  - [net-next,v5,2/8] net: dsa: microchip: ksz8795: add phylink support
    https://git.kernel.org/netdev/net-next/c/2c709e0bdad4
  - [net-next,v5,3/8] net: phy: micrel: use consistent alignments
    https://git.kernel.org/netdev/net-next/c/0033f890f95b
  - [net-next,v5,4/8] net: phy/dsa micrel/ksz886x add MDI-X support
    https://git.kernel.org/netdev/net-next/c/52939393bd68
  - [net-next,v5,5/8] net: phy: micrel: ksz8081 add MDI-X support
    https://git.kernel.org/netdev/net-next/c/f873f112553b
  - [net-next,v5,6/8] net: dsa: microchip: ksz8795: add LINK_MD register support
    https://git.kernel.org/netdev/net-next/c/36838050c453
  - [net-next,v5,7/8] net: dsa: dsa_slave_phy_connect(): extend phy's flags with port specific phy flags
    https://git.kernel.org/netdev/net-next/c/c916e8e1ea72
  - [net-next,v5,8/8] net: phy: micrel: ksz886x/ksz8081: add cabletest support
    https://git.kernel.org/netdev/net-next/c/49011e0c1555

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


