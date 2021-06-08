Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC23A07E5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhFHXmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234692AbhFHXl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4CE2961185;
        Tue,  8 Jun 2021 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195604;
        bh=MfjY+4mOVdt6VE5TPbl5TyoBmS1OqK9boAp59L3xbOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpT3VbXGls2Wi3ON7ze35Z7KfRRm3PLtevL4buHNtuqW9EJKkwRTwWGfM+jZwMCrJ
         EOZJKH7poMuzA0U3WK6ylud0W9VwB7nHq30Dv7AbXN+lLAZJV7AL3CDju+8qOIUAB6
         EFHjYcMQd7fQ9Heo2zVaFdt7mKXNMTvE/tv31i+duQmrpChthHi288MmjGb+X/I1yL
         LhShlhUHZ0oCnikEGxmOHcD3QLh7RLNJ89dIK6jk+MaZ7Wa9CeTegMu7IMyq6x+yBQ
         2N6pj6o6WmDU2e+C5mqgmkq14Up4IcyKvwUe4FOUHUL/Gjgw+1EsvDm3uOENX+w8Az
         VBqjuAPXLxGKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3ACA760CD1;
        Tue,  8 Jun 2021 23:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: re-enable TX flow control in
 ocelot_port_flush()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560423.24693.7169178263106663031.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:04 +0000
References: <20210608111535.4084131-1-olteanv@gmail.com>
In-Reply-To: <20210608111535.4084131-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        michael@walle.cc, hkallweit1@gmail.com, linux@armlinux.org.uk,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  8 Jun 2021 14:15:35 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Because flow control is set up statically in ocelot_init_port(), and not
> in phylink_mac_link_up(), what happens is that after the blamed commit,
> the flow control remains disabled after the port flushing procedure.
> 
> Fixes: eb4733d7cffc ("net: dsa: felix: implement port flushing on .phylink_mac_link_down")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: re-enable TX flow control in ocelot_port_flush()
    https://git.kernel.org/netdev/net/c/1650bdb1c516

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


