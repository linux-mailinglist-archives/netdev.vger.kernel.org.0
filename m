Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41631A976
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhBMBUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhBMBUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BF1CA64EA6;
        Sat, 13 Feb 2021 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613179209;
        bh=oNYc7M3BMkbfiaGU0JhXA5uNqthn+1gjQRUzoHS6Hts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRwaAlWaJHxKIOEty8NmWnOtnt5bPMGr3WwhHsQHSEf8gUP14/lyy2Kl0qwMsePFB
         XQ7PBCzVh+wGFJXSDG6yW5Zj8+6wi025y7MRumsosTZ3VaCakyg0jMvaTX5IgUYLbm
         XB1eeceC2je+zHrJzyhauPaL1I9/+rQJMXscBse2BybHggbbzG6vhpovFJ8CGXhF3u
         dFAXErSMYm6NgAaGMkOb0k+8diaix79a8W/rBFHm2z/7+GAQOMQOQqo0XAHhv9GYUV
         p2nuBWvqOaHyqKbJEc4ZBZ4C/CngIxetT0sWMkwSVh5PKdi/QpC8hh736NyPI3nF7s
         EBJdWxNz/AKCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B891060971;
        Sat, 13 Feb 2021 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/10] Cleanup in brport flags switchdev offload
 for DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317920975.20729.8209116338649427486.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:20:09 +0000
References: <20210212151600.3357121-1-olteanv@gmail.com>
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vkochan@marvell.com,
        tchornyi@marvell.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        ioana.ciornei@nxp.com, ivecera@redhat.com,
        linux-omap@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 17:15:50 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The initial goal of this series was to have better support for
> standalone ports mode on the DSA drivers like ocelot/felix and sja1105.
> This turned out to require some API adjustments in both directions:
> to the information presented to and by the switchdev notifier, and to
> the API presented to the switch drivers by the DSA layer.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/10] net: switchdev: propagate extack to port attributes
    https://git.kernel.org/netdev/net-next/c/4c08c586ff29
  - [v5,net-next,02/10] net: bridge: offload all port flags at once in br_setport
    https://git.kernel.org/netdev/net-next/c/304ae3bf1c1a
  - [v5,net-next,03/10] net: bridge: don't print in br_switchdev_set_port_flag
    https://git.kernel.org/netdev/net-next/c/078bbb851ea6
  - [v5,net-next,04/10] net: dsa: configure better brport flags when ports leave the bridge
    https://git.kernel.org/netdev/net-next/c/5e38c15856e9
  - [v5,net-next,05/10] net: switchdev: pass flags and mask to both {PRE_,}BRIDGE_FLAGS attributes
    https://git.kernel.org/netdev/net-next/c/e18f4c18ab5b
  - [v5,net-next,06/10] net: dsa: act as passthrough for bridge port flags
    https://git.kernel.org/netdev/net-next/c/a8b659e7ff75
  - [v5,net-next,07/10] net: dsa: felix: restore multicast flood to CPU when NPI tagger reinitializes
    https://git.kernel.org/netdev/net-next/c/6edb9e8d451e
  - [v5,net-next,08/10] net: mscc: ocelot: use separate flooding PGID for broadcast
    https://git.kernel.org/netdev/net-next/c/b360d94f1b86
  - [v5,net-next,09/10] net: mscc: ocelot: offload bridge port flags to device
    https://git.kernel.org/netdev/net-next/c/421741ea5672
  - [v5,net-next,10/10] net: dsa: sja1105: offload bridge port flags to device
    https://git.kernel.org/netdev/net-next/c/4d9423549501

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


