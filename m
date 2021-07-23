Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951B23D3CC9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhGWPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235691AbhGWPJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1F5760EE2;
        Fri, 23 Jul 2021 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627055405;
        bh=+K3ROxkv2Wdhl+4C12AmUCoCtE1n0FYZaWBOSEgVLoQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=So8b3PFkoJKPh6LD1CVplGqsSECVNu8GymqlBgiHp6zdZLROCDBtlIIPCEFjYUkAX
         vL7pP7VXhx0jw6nzNobtxtL1bbYJTouvabcosDas+tHVFs619Vg4PI67MuAEVgHHSD
         cOw8yiluVzJNtWXzY251eliVUFAWY6qLRgBLamwXTIuVB/wX3aheDZEvBUYU09WXhy
         N8e2LFZvUuNwaZZG+Fu56uoEVfq4U0rHdVfBOnGuHR9do44a1p60AeOSxU2oAM0Yf7
         89Uyzce6/RBMb/h7FTEj+Ur5dgotC9/Us1ZtoaTkXRQaarvWI76SlNuWa7iihjzdtd
         VmwHWzPPGVnlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D69C260972;
        Fri, 23 Jul 2021 15:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/5] Allow TX forwarding for the software bridge
 data path to be offloaded to capable devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705540587.23511.775470565736247308.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:50:05 +0000
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, tobias@waldekranz.com,
        roopa@nvidia.com, nikolay@nvidia.com, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, grygorii.strashko@ti.com,
        kabel@blackhole.sk, dqfext@gmail.com, vkochan@marvell.com,
        tchornyi@marvell.com, ioana.ciornei@nxp.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 18:55:37 +0300 you wrote:
> On RX, switchdev drivers have the ability to mark packets for the
> software bridge as "already forwarded in hardware" via
> skb->offload_fwd_mark. This instructs the nbp_switchdev_allowed_egress()
> function to perform software forwarding of that packet only to the bridge
> ports that are not in the same hardware domain as the source packet.
> 
> This series expands the concept for TX, in the sense that we can trust
> the accelerator to:
> (a) look up its FDB (which is more or less in sync with the software
>     bridge FDB) for selecting the destination ports for a packet
> (b) replicate the frame in hardware in case it's a multicast/broadcast,
>     instead of the software bridge having to clone it and send the
>     clones to each net device one at a time. This reduces the bandwidth
>     needed between the CPU and the accelerator, as well as the CPU time
>     spent.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/5] net: bridge: switchdev: allow the TX data plane forwarding to be offloaded
    https://git.kernel.org/netdev/net-next/c/472111920f1c
  - [v5,net-next,2/5] net: dsa: track the number of switches in a tree
    https://git.kernel.org/netdev/net-next/c/5b22d3669f2f
  - [v5,net-next,3/5] net: dsa: add support for bridge TX forwarding offload
    https://git.kernel.org/netdev/net-next/c/123abc06e74f
  - [v5,net-next,4/5] net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
    https://git.kernel.org/netdev/net-next/c/ce5df6894a57
  - [v5,net-next,5/5] net: dsa: tag_dsa: offload the bridge forwarding process
    https://git.kernel.org/netdev/net-next/c/d82f8ab0d874

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


