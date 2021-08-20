Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B673F2D46
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240754AbhHTNk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232399AbhHTNkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A7B0D61130;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629466808;
        bh=dkURxhs45r4ar8b69aqFk4u0U6BaIE/1RQkf/7GMypA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FrmniJISDIq62NSJwnlhymVMylzEmeI4EkFxlVFkPLdUlUnB5qTkhTv4o6qsSfuWh
         Ivp1fux8O2mxlFyEHiaDE0MM6FwB69LRzYdhIUWTQQnVrtd1zsbJc9+N5FF2uW8XWg
         wl3cgOvhLWjuR6++Jv/QT19p4OKQJHaDW74sy2LnyyNzexkGaA6ruGiXPJkaEUtO0f
         9uWZ/bhNaUYHS2ADOo8tBszVUfAJYpPrQXN1DrrwHU3ALnBN3hyvtCfzPTLrKLJn8F
         NONefpgkmG0alyLQh79/c2qxA+wZzJ7m2XKMC+c6bfF78exJJStTgqXVC1nM5w955j
         xFsxqqBz/dUOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C39C60A95;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] Ocelot phylink fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946680863.23508.8493261893281323275.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:40:08 +0000
References: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 19:49:56 +0300 you wrote:
> This series addresses a regression reported by Horatiu which introduced
> by the ocelot conversion to phylink: there are broken device trees in
> the wild, and the driver fails to probe the entire switch when a port
> fails to probe, which it previously did not do.
> 
> Continue probing even when some ports fail to initialize properly.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: mscc: ocelot: be able to reuse a devlink_port after teardown
    https://git.kernel.org/netdev/net-next/c/b5e33a157158
  - [v2,net-next,2/2] net: mscc: ocelot: allow probing to continue with ports that fail to register
    https://git.kernel.org/netdev/net-next/c/5c8bb71dbdf8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


