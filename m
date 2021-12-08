Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1FE46DECA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhLHXDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbhLHXDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:03:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09987C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 15:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53EAECE2405
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82B06C341C3;
        Wed,  8 Dec 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639004411;
        bh=MtwIC3uGfHXXmq4DnSwoy2jQWfRGNi4VNCWaLcCGZx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YIjPLcIjR7r9ZV0W5QWwGAFgGxRqqcet8zUPc7LbOTNSatBJVLHZCMfUdfXrW/AXD
         CIr1KXwrTPAcF1HiF6CPQei3B0LLT3pWhaxhPc+WB2uP/tgSWPgt1wJ9Nd3NUEFWqM
         xwH3Db7giraSHEaBo1W4Zr3Wsq+ZLY9r7j7k3MqNHASsF98p205w1NVNL2UfOaS3pp
         CnYJ87G8Gjt+oKqZCs5QgcoCrCw8cQ9NF7rl16ytG8adirFlFkudlU0xborGYXZKEj
         c+rZWM3KmvCjQOPhAo1Zls1mJ4AltWkCVKfzZDSmwcQu8g5ZpKaCeToK6L8FyzDZ4I
         P2uLTKiWsZ8NQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FED560966;
        Wed,  8 Dec 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/12] Rework DSA bridge TX forwarding offload API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163900441145.10579.9768228984013599543.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 23:00:11 +0000
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, tobias@waldekranz.com, dqfext@gmail.com,
        alsi@bang-olufsen.dk, kurt@linutronix.de, hauke@hauke-m.de,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, linus.walleij@linaro.org,
        george.mccollister@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 18:57:46 +0200 you wrote:
> This change set is preparation work for DSA support of bridge FDB
> isolation. It replaces struct net_device *dp->bridge_dev with a struct
> dsa_bridge *dp->bridge that contains some extra information about that
> bridge, like a unique number kept by DSA.
> 
> Up until now we computed that number only with the bridge TX forwarding
> offload feature, but it will be needed for other features too, like for
> isolation of FDB entries belonging to different bridges. Hardware
> implementations vary, but one common pattern seems to be the presence of
> a FID field which can be associated with that bridge number kept by DSA.
> The idea was outlined here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210818120150.892647-16-vladimir.oltean@nxp.com/
> (the difference being that with this new proposal, drivers would not
> need to call dsa_bridge_num_find, instead the bridge_num would be part
> of the struct dsa_bridge :: num passed as argument).
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/12] net: dsa: make dp->bridge_num one-based
    https://git.kernel.org/netdev/net-next/c/3f9bb0301d50
  - [v3,net-next,02/12] net: dsa: assign a bridge number even without TX forwarding offload
    https://git.kernel.org/netdev/net-next/c/947c8746e2c3
  - [v3,net-next,03/12] net: dsa: mt7530: iterate using dsa_switch_for_each_user_port in bridging ops
    https://git.kernel.org/netdev/net-next/c/872bb81dfbc3
  - [v3,net-next,04/12] net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_port in mv88e6xxx_port_check_hw_vlan
    https://git.kernel.org/netdev/net-next/c/0493fa7927af
  - [v3,net-next,05/12] net: dsa: mv88e6xxx: compute port vlan membership based on dp->bridge_dev comparison
    https://git.kernel.org/netdev/net-next/c/65144067d360
  - [v3,net-next,06/12] net: dsa: hide dp->bridge_dev and dp->bridge_num in the core behind helpers
    https://git.kernel.org/netdev/net-next/c/36cbf39b5690
  - [v3,net-next,07/12] net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers behind helpers
    https://git.kernel.org/netdev/net-next/c/41fb0cf1bced
  - [v3,net-next,08/12] net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
    https://git.kernel.org/netdev/net-next/c/936db8a2dba2
  - [v3,net-next,09/12] net: dsa: export bridging offload helpers to drivers
    https://git.kernel.org/netdev/net-next/c/6a43cba30340
  - [v3,net-next,10/12] net: dsa: keep the bridge_dev and bridge_num as part of the same structure
    https://git.kernel.org/netdev/net-next/c/d3eed0e57d5d
  - [v3,net-next,11/12] net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
    https://git.kernel.org/netdev/net-next/c/b079922ba2ac
  - [v3,net-next,12/12] net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
    https://git.kernel.org/netdev/net-next/c/857fdd74fb38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


