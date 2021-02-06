Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5F312062
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBFXAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFXAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 584BA64E34;
        Sat,  6 Feb 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612652410;
        bh=THOn34qSYL+UQxhcjkkzPj59aDd6Ql306i6NMwbBmF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=clNg0AIRv5V6XQD+RRC/cUwIc5ph6LdwYEXn9RlgfSKekdISEHhaccpUYfP+NWIRs
         7mgU8AcMoORoW3aS/Hn11Y+wefyipUK1850fpv5pyIlowGgNL4gNy0Bx0q0rNawvPK
         ka+vkj8BwtoBafE8Bl/j8OEkBDwU7i5Z+G/1uRYT5Kkej9kcmjZTvE8U8JuVhBCT14
         taO6CdP8EYHw+5MDI0jK/GdN11CCMDPDl+JETVAkHOixOXvJVPDQuTo/WUvWLOLBm4
         PrGVwxQHL7fgOV23AIHfWFJf/EmKqUB16Axs2GxCX/hZPzcsGP2Fw7nOyMKkPIAUeP
         IDc/Oj3rJQDTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42CF6609F7;
        Sat,  6 Feb 2021 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND v3 net-next 00/12] LAG offload for Ocelot DSA switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265241026.16209.1084376142027765956.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 23:00:10 +0000
References: <20210205220221.255646-1-olteanv@gmail.com>
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat,  6 Feb 2021 00:02:09 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series reworks the ocelot switchdev driver such that it could
> share the same implementation for LAG offload as the felix DSA driver.
> 
> Testing has been done in the following topology:
> 
> [...]

Here is the summary with links:
  - [RESEND,v3,net-next,01/12] net: mscc: ocelot: rename ocelot_netdevice_port_event to ocelot_netdevice_changeupper
    https://git.kernel.org/netdev/net-next/c/662981bbda29
  - [RESEND,v3,net-next,02/12] net: mscc: ocelot: use a switch-case statement in ocelot_netdevice_event
    https://git.kernel.org/netdev/net-next/c/41e66fa28fef
  - [RESEND,v3,net-next,03/12] net: mscc: ocelot: don't refuse bonding interfaces we can't offload
    https://git.kernel.org/netdev/net-next/c/583cbbe3eed9
  - [RESEND,v3,net-next,04/12] net: mscc: ocelot: use ipv6 in the aggregation code
    https://git.kernel.org/netdev/net-next/c/f79c20c81723
  - [RESEND,v3,net-next,05/12] net: mscc: ocelot: set up the bonding mask in a way that avoids a net_device
    https://git.kernel.org/netdev/net-next/c/b80af659699d
  - [RESEND,v3,net-next,06/12] net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
    https://git.kernel.org/netdev/net-next/c/2e9f4afadc70
  - [RESEND,v3,net-next,07/12] net: mscc: ocelot: set up logical port IDs centrally
    https://git.kernel.org/netdev/net-next/c/2527f2e88fba
  - [RESEND,v3,net-next,08/12] net: mscc: ocelot: drop the use of the "lags" array
    https://git.kernel.org/netdev/net-next/c/528d3f190c98
  - [RESEND,v3,net-next,09/12] net: mscc: ocelot: rename aggr_count to num_ports_in_lag
    https://git.kernel.org/netdev/net-next/c/21357b614d3f
  - [RESEND,v3,net-next,10/12] net: mscc: ocelot: rebalance LAGs on link up/down events
    https://git.kernel.org/netdev/net-next/c/23ca3b727ee6
  - [RESEND,v3,net-next,11/12] net: dsa: make assisted_learning_on_cpu_port bypass offloaded LAG interfaces
    https://git.kernel.org/netdev/net-next/c/a324d3d48fb3
  - [RESEND,v3,net-next,12/12] net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
    https://git.kernel.org/netdev/net-next/c/8fe6832e96ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


