Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3531C31D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBOUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhBOUkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AE5FD64DF0;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613421608;
        bh=r0Bssz77VRtE92gCubJVgi3EHlziWM4zd35LghEuTjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P1cpBlaTBnOziGkGRmLGbihH61cV/LYsHXmQJTWJRbbkTxdfbQLK4K4QiiJXQV0lv
         t+wOEI8CW+xH4IxS6B/QvwDiea0G4R+fhKEKbWctK86rOVt9tg1R5PO894G4f88tkE
         z4ld3PIbvWvpgn+tijQx9A3ehugxNkhcPdRxvAyMUq5ULX8raj0+hrqpUY8HmwDBOr
         IYvSCEBtQbvRVlr+qVHsR4F3s0/x+PUO9tOnZo2pNftTx3dn8nGoscjwsa+wvfxwbO
         Ibwuka3CbpjM9XBsvcvzZabKkWlfN653uU6qvp4Opi5OkTLPQMCrcffJAwyz5tKG5q
         97krP0AE3BSuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A028A60977;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Propagate extack for switchdev VLANs from DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342160865.4070.3346635751399377653.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:40:08 +0000
References: <20210213204319.1226170-1-olteanv@gmail.com>
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kurt@linutronix.de, woojung.huh@microchip.com,
        linus.walleij@linaro.org, hauke@hauke-m.de, jiri@resnulli.us,
        ivecera@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        dqfext@gmail.com, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Feb 2021 22:43:14 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series moves the restriction messages printed by the DSA core, and
> by some individual device drivers, into the netlink extended ack
> structure, to be communicated to user space where possible, or still
> printed to the kernel log from the bridge layer.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: bridge: remove __br_vlan_filter_toggle
    https://git.kernel.org/netdev/net-next/c/7a572964e0c4
  - [net-next,2/5] net: bridge: propagate extack through store_bridge_parm
    https://git.kernel.org/netdev/net-next/c/9e781401cbfc
  - [net-next,3/5] net: bridge: propagate extack through switchdev_port_attr_set
    https://git.kernel.org/netdev/net-next/c/dcbdf1350e33
  - [net-next,4/5] net: dsa: propagate extack to .port_vlan_add
    https://git.kernel.org/netdev/net-next/c/31046a5fd92c
  - [net-next,5/5] net: dsa: propagate extack to .port_vlan_filtering
    https://git.kernel.org/netdev/net-next/c/89153ed6ebc1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


