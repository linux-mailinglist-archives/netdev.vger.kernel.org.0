Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6EB506756
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350251AbiDSJC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 05:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350249AbiDSJC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 05:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86561CB00
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 02:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E49AB811DC
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BACBC385AA;
        Tue, 19 Apr 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650358812;
        bh=GivyubItyB3WUjxrXF5Mt2AOnY7OA8LEwcOGfyavroA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O2f6MHGdw+IOlSi1Pp7Ik68UyQjjr3n1krBtOyJigZBqyb6ed0JUXDeZnWmYGnkTL
         wbM9ueLTvC7lhQKgLd/d7bxj7Mi8v15Sw2yYNSx5fEeSrWp5zyrSB++6BgUE+WMVSV
         OqsiCIUadEMqQeyXmRLiu3a/NcV7fNJhJgD9hSVsNpCn8vyGsy37+HUYchAXcyYtBJ
         V60GQqpsK03RSkS8bI4j+x4QnTE0PBIK1cQNwY1cwFO/aaQYA/nbIXEkGhKYiYdtKt
         NwTPnz8P03SfWUdBL4lBlkhJ6Iuu5q2GYPiYIqolMgiv6xNHORjFfXOrpkRhE9jS9j
         TbcvZcflbXNRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E208EF0383D;
        Tue, 19 Apr 2022 09:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix broken IP multicast flooding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165035881192.28343.15386836192709023151.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Apr 2022 09:00:11 +0000
References: <20220415151950.219660-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220415151950.219660-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 15 Apr 2022 18:19:50 +0300 you wrote:
> When the user runs:
> bridge link set dev $br_port mcast_flood on
> 
> this command should affect not only L2 multicast, but also IPv4 and IPv6
> multicast.
> 
> In the Ocelot switch, unknown multicast gets flooded according to
> different PGIDs according to its type, and PGID_MC only handles L2
> multicast. Therefore, by leaving PGID_MCIPV4 and PGID_MCIPV6 at their
> default value of 0, unknown IP multicast traffic is never flooded.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix broken IP multicast flooding
    https://git.kernel.org/netdev/net/c/4cf35a2b627a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


