Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325B23A07EF
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhFHXmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235554AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0104E61375;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=gmlE+JZ9J5AR9yqjxmn/4DVZPPZmM0oZ53Y8Mn1pMYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=apGcRViiiPRrsqPTc2A12eoy/04xG+4tNVYXcipUsn7YjaIlXUjKhil9dTdZh5NHw
         u3DoGUax9NiUpABK9AxC4OmAvWYE4Yz01S945w4dkjPfuaO7UfKFrHX05JApBmwLN6
         dQ4tNt8GqH3DQ6d8Ey2j45vewztciOz/L0j/4zw1Z4YRhuK4K2GkHiqT73o9RBpihN
         OkXK/eyekj206wZ/MtjxZgcSR+itfTBPyl5LJ0kd5I9qSwGaprec5mYNiTlQAPYvK3
         otprkkAByTPisWAh9SsYNOkekRuVHp6Jse2LuUcXady+PIrDJH20y0T8uTHQJLPhLk
         OSUXfflf3NcQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBE11609E3;
        Tue,  8 Jun 2021 23:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: felix: set TX flow control according to
 the phylink_mac_link_up resolution
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560596.24693.11715284868769075021.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:05 +0000
References: <20210608111651.4084572-1-olteanv@gmail.com>
In-Reply-To: <20210608111651.4084572-1-olteanv@gmail.com>
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

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 14:16:51 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Instead of relying on the static initialization done by ocelot_init_port()
> which enables flow control unconditionally, set SYS_PAUSE_CFG_PAUSE_ENA
> according to the parameters negotiated by the PHY.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution
    https://git.kernel.org/netdev/net-next/c/de274be32cb2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


