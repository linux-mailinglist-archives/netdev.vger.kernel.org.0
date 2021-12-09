Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562E846EF50
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhLIREF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241902AbhLIRDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:03:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC004C0698C8
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 09:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA718B825C8
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 17:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F513C341CA;
        Thu,  9 Dec 2021 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639069209;
        bh=QS4x8RTykBZ2TUgvw0Eomqvdv07cHkT9zgSdqvcu6Z0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhn5JDOD7m/Yxar9JIicHHgj7BqIv96aFrX+L9DOWLR+7kWpLL9KQrh28agjdl30F
         1kSAxnShei3Y22FGN+KFQt76dIJCH9Imckb+2jqO3WsWTEKsnXCu94dcAi26ArQntd
         7MNFFddxl6PvrdK3Bin/iJSBjD2l0Qd/S05d23+TV8EW1r0Z+gR9zUnxy3o7ND/0wl
         WSbizDSsCjA03L52Lx68utkFE62B7MoBjo0fIymA6AUW8VoUBjAVu8zr3iovvbBeUO
         c+7bfSslpWSBQqWmUNCpHGC0t3UtddMX0tiwuHnvt1C6C0Uf9QujI/MK4rqrqh25Se
         zbdMk1HXsmokw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68E9860A2F;
        Thu,  9 Dec 2021 17:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA
 ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906920942.7990.14662211501678992293.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 17:00:09 +0000
References: <E1mvFhP-00F8Zb-Ul@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mvFhP-00F8Zb-Ul@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 09 Dec 2021 09:26:47 +0000 you wrote:
> Martyn Welch reports that his CPU port is unable to link where it has
> been necessary to use one of the switch ports with an internal PHY for
> the CPU port. The reason behind this is the port control register is
> left forcing the link down, preventing traffic flow.
> 
> This occurs because during initialisation, phylink expects the link to
> be down, and DSA forces the link down by synthesising a call to the
> DSA drivers phylink_mac_link_down() method, but we don't touch the
> forced-link state when we later reconfigure the port.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports
    https://git.kernel.org/netdev/net/c/04ec4e6250e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


