Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80171314518
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBIAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhBIAus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 19:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 058F164E9C;
        Tue,  9 Feb 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612831807;
        bh=M4JvpIOeBLmk0O/aUhIaXU2I/lEjDKewFQhnmsn8vYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RbFt5eXRevJdlTFw/yTP/5pshC6Gzj9ILLzMp60gVl0hFDdZ+x6126oMDP6j87yt2
         DYCXtnXjDK9FoJimDUkxw+ZmjMZkYpbhYwtpH1gX3FMHYTGBVb0cMgFFls3Mx1JKLR
         h+mCP6ujdwIMjVwITUHslqlVieElTT6JWGUqvgKcG8mnrf8XJbuiKy98M6mDaIp+NO
         du8IkstUIn0UKUdE+ji7yLwOtcsW5bwY/cnvgPjkWHFRxNzhYk9tksuyLdtx5hu7w4
         dieCaQZ33prbfOAW6wLeFxqq4uk81kDxropV/9pEiz9GxRyRgw5AhpQc3N6lo9STfM
         5tMrcFoDmjxAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E15E7609D6;
        Tue,  9 Feb 2021 00:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bridge: mrp: Fix br_mrp_port_switchdev_set_state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161283180691.7845.8705102282874367511.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 00:50:06 +0000
References: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
        kuba@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        rasmus.villemoes@prevas.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 6 Feb 2021 22:47:32 +0100 you wrote:
> Based on the discussion here[1], there was a problem with the function
> br_mrp_port_switchdev_set_state. The problem was that it was called
> both with BR_STATE* and BR_MRP_PORT_STATE* types. This patch series
> fixes this issue and removes SWITCHDEV_ATTR_ID_MRP_PORT_STAT because
> is not used anymore.
> 
> [1] https://www.spinics.net/lists/netdev/msg714816.html
> 
> [...]

Here is the summary with links:
  - [net,1/2] bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
    https://git.kernel.org/netdev/net/c/b2bdba1cbc84
  - [net,2/2] switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT
    https://git.kernel.org/netdev/net/c/059d2a100498

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


