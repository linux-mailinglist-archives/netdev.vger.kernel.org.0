Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C83EA297
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhHLKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhHLKAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 06:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A907D6104F;
        Thu, 12 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762405;
        bh=DR/hQiw+y3vFR6QIu0rV3RqzDD/mR18Iany0xmZNi50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ixi2V41tbZUUX2NwvRMI/UYZX+6IQXlJnLDUB/VeIxI1fy/C5Z9OtuAHAnIlHQxI5
         ygxGN1gHrtfp4bXUU4KvWdyM+6RygYa+9CN4OidnPi/1OfqsUAt2VHnXIYxEPQPHC4
         vfM1EisI4rMVyeBK+/uDtJN7d3ThgBt4hECfQZihZr4Uahy8PunfAAOGUNBmL3UFrE
         /z1bu78w6T8WigoR8cxIknIv2kUeO9zplbAKFh7uFOhv8OICwtsLR+DQLcIKyS/wQ4
         +JMgFK7UdLMknjAW2+yn/Cuz+i/yo5oRlQNcN8r0bylq2j8fEuwL3QrHDzc4JkLnsC
         eFqtfMXJHZSHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B70060A69;
        Thu, 12 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: unregister the MDIO buses during
 teardown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876240563.6902.16147039112318552619.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 10:00:05 +0000
References: <20210811115945.2606372-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210811115945.2606372-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 11 Aug 2021 14:59:45 +0300 you wrote:
> The call to sja1105_mdiobus_unregister is present in the error path but
> absent from the main driver unbind path.
> 
> Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: dsa: sja1105: unregister the MDIO buses during teardown
    https://git.kernel.org/netdev/net/c/700fa08da43e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


