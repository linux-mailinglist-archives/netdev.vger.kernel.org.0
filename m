Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5854851C7
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiAELaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44342 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiAELaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696E4616AE;
        Wed,  5 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF001C36AEF;
        Wed,  5 Jan 2022 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641382211;
        bh=REKCjz01hO75inOVZ+2AV9pCVgvnie70qxe3fko0ELA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDlspxn5RjH7HeVHZYenJ8ZCiZzIYlbcYPGl08+4PzHjIfHBsN1tCog9sRTVKGkHP
         Mq+TJOvQ3DIf4hrMAR/iO9ru050x6qKOGIGifOW1NVql2CC4G6TNN5/1RL5Ehj1Ids
         NV6A5B0qLJUGaHSMfLYsDFHRs0NZ2clKaz5VAErVSP4O5i0YaOmxZ+IJl7XFmtEVEc
         1pkxtsf93z8Z9wldo/TbzX/PTAAZe2Ss2sDxMEkEzBeF7LPc4/507jiXZlz4NNkIiJ
         yKWAUKnVsdeuj6i28yyp2UQ5sKtoi/sNIb6bOZHdXI+3nZQcwaW6GkiWC1kYZqN0Hx
         wIjzaUZgo3HcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A669BF79401;
        Wed,  5 Jan 2022 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: lan966x: Extend switchdev with mdb
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164138221167.4307.15879040373419264750.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 11:30:11 +0000
References: <20220104153338.425250-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220104153338.425250-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 4 Jan 2022 16:33:35 +0100 you wrote:
> This patch series extends lan966x with mdb support by implementing
> the switchdev callbacks: SWITCHDEV_OBJ_ID_PORT_MDB and
> SWITCHDEV_OBJ_ID_HOST_MDB.
> It adds support for both ipv4/ipv6 entries and l2 entries.
> 
> v2->v3:
> - rename PGID_FIRST and PGID_LAST to PGID_GP_START and PGID_GP_END
> - don't forget and relearn an entry for the CPU if there are more
>   references to the cpu.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: lan966x: Add function lan966x_mac_ip_learn()
    https://git.kernel.org/netdev/net-next/c/fc0c3fe7486f
  - [net-next,v3,2/3] net: lan966x: Add PGID_GP_START and PGID_GP_END
    https://git.kernel.org/netdev/net-next/c/11b0a27772f5
  - [net-next,v3,3/3] net: lan966x: Extend switchdev with mdb support
    https://git.kernel.org/netdev/net-next/c/7aacb894b1ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


