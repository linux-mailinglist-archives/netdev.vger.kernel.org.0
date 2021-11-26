Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C470F45F5A4
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhKZUKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbhKZUIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:08:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9767EC06139C
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 11:50:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D84062342
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:50:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 7CFBE601FA;
        Fri, 26 Nov 2021 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637956209;
        bh=PKw6AQQfKWsvKbcasZeFSh5L8mHtPlkdHSzKeIPgHY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DNUH1XMD59Q+D+FsxQuFsQiG9PLxDfOB4n2HWGHvb9eKH4EE4FBm7LMm/yOuHNwyg
         9DR71meyW+xakkf2268vXiXUpFpMki8rGCM/OlAMIZ0ECSZsePduQJjGL7yxN8BwuB
         Z/cYigfRcLH1/nogw3agEdGnuV4mzrMF1PsA/31XFU+lmnYB9Zs02DIjZFU//XZwNH
         wHD/ZlXQ9fM0rVhrvUq5e6HWrenPrUV2qavwWW2xC+h2M3JPcO26PEQV28DtbfI8mx
         0H6c+OCuTl4XNl96n42lXqbCQKyhud6FRm9tw9KuMZitCFl019M0vCI1akuAKXiLzj
         5llD0ijRk4Drg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6F4DD60A6C;
        Fri, 26 Nov 2021 19:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/5] Fix broken PTP over IP on Ocelot switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795620945.23477.13137268244859856342.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:50:09 +0000
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, po.liu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, atenart@kernel.org,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, rui.sousa@nxp.com,
        richardcochran@gmail.com, allan.nielsen@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 19:28:40 +0200 you wrote:
> Changes in v2: added patch 5, added Richard's ack for the whole series
> sans patch 5 which is new.
> 
> Po Liu reported recently that timestamping PTP over IPv4 is broken using
> the felix driver on NXP LS1028A. This has been known for a while, of
> course, since it has always been broken. The reason is because IP PTP
> packets are currently treated as unknown IP multicast, which is not
> flooded to the CPU port in the ocelot driver design, so packets don't
> reach the ptp4l program.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/5] net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
    https://git.kernel.org/netdev/net/c/8a075464d1e9
  - [v2,net,2/5] net: mscc: ocelot: create a function that replaces an existing VCAP filter
    https://git.kernel.org/netdev/net/c/95706be13b9f
  - [v2,net,3/5] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
    https://git.kernel.org/netdev/net/c/ec15baec3272
  - [v2,net,4/5] net: mscc: ocelot: set up traps for PTP packets
    https://git.kernel.org/netdev/net/c/96ca08c05838
  - [v2,net,5/5] net: mscc: ocelot: correctly report the timestamping RX filters in ethtool
    https://git.kernel.org/netdev/net/c/c49a35eedfef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


