Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680053DA6AA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhG2OkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237230AbhG2OkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 10:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1987161055;
        Thu, 29 Jul 2021 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627569606;
        bh=aC0JMTL9RHZ/Pydhd87s5oAXlM1lrgJA2RJDnrk8DDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f+3KgiNi65rrLxL4++N8GfXG9/GIiFDXDkRhJBG9mWcjb34uA54ICHU/FW6p6MIWg
         Y0Idq5+pYNrghY5gEVJPUGtvOHMg20lz1jCNDf0rss23LRoOOPa0BhLS1/n7i/3JSw
         Ob6kJivXypk9xWsQvtjeGcbAUYV3xciMYeYOVesoTRgd3egwa6CSFJle/z+r6ndk74
         QtrJBHsBTx+6JVnkVsH/Bf6SxwBBxxGtT8BzDe1GTzaDxED4yRSs5UpgrmflTJirI+
         0BvBFL0DmrSdiwOpIrWgALbyalrfuI4I21lORqw1FJsJzE5jHkeDGc1N7RPA2JqIYR
         CFQSK1emxd5GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B9FC60A7B;
        Thu, 29 Jul 2021 14:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] NXP SJA1105 VLAN regressions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162756960604.20711.10826106832524718838.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 14:40:06 +0000
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 00:54:26 +0300 you wrote:
> These are 3 patches to fix issues seen with some more varied testing
> done after the changes in the "Traffic termination for sja1105 ports
> under VLAN-aware bridge" series were made:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210726165536.1338471-1-vladimir.oltean@nxp.com/
> 
> Issue 1: traffic no longer works on a port after leaving a VLAN-aware bridge
> Issue 2: untagged traffic not dropped if pvid is absent from a VLAN-aware port
> Issue 3: PTP and STP broken on ports under a VLAN-aware bridge
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: sja1105: reset the port pvid when leaving a VLAN-aware bridge
    https://git.kernel.org/netdev/net-next/c/cde8078e83e3
  - [net-next,2/3] net: dsa: sja1105: make sure untagged packets are dropped on ingress ports with no pvid
    https://git.kernel.org/netdev/net-next/c/bef0746cf4cc
  - [net-next,3/3] net: dsa: tag_sja1105: fix control packets on SJA1110 being received on an imprecise port
    https://git.kernel.org/netdev/net-next/c/04a1758348a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


