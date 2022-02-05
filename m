Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16754AA996
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351703AbiBEPKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiBEPKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0429C061348;
        Sat,  5 Feb 2022 07:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA73B8015A;
        Sat,  5 Feb 2022 15:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E61FAC340EC;
        Sat,  5 Feb 2022 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644073809;
        bh=O7riATjePCEa2aBAqE1LJllm1RUVPXLHQNq5/gc3znc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oIpKsBjrj1LYhxJt6Y7ibc7zlZJaag2rHM1KZZZsvfuO/zaQNT0dRRlFOvE1tNgE9
         ocsFx+/yD/P2HOcqzMAx3CjtvB5MaVR8DN3oiiBAuu2X9ayA5cz7jwAvj6V3o21R79
         ZSSc6AA4anlRl4GTbv+jCO07P03fBp3ziDO5U8aZrEp0KAlGulkOnqKxZuh9J8/ykk
         CViU0fDr+PrbUF00BfmDVXEfTjlZdQcl1XSSCYhK8UKte/gVsGdAxAbSu3mPP/MOc+
         ekiyuQGDtuAgkRnmnEkvEYYyGbJJNYBmRbI9NEce+MOC6WhjiehrtZsK3jTf+ZXtaQ
         MZeqw4/35Ujxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCD28E5869F;
        Sat,  5 Feb 2022 15:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: lan966x: add support for mcast snooping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407380983.16413.7086796356569573213.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:10:09 +0000
References: <20220204091452.403706-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220204091452.403706-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 4 Feb 2022 10:14:49 +0100 you wrote:
> Implement the switchdev callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
> to allow to enable/disable multicast snooping.
> 
> Horatiu Vultur (3):
>   net: lan966x: Update the PGID used by IPV6 data frames
>   net: lan966x: Implement the callback
>     SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
>   net: lan966x: Update mdb when enabling/disabling mcast_snooping
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: lan966x: Update the PGID used by IPV6 data frames
    https://git.kernel.org/netdev/net-next/c/1c213f05a3e1
  - [net-next,2/3] net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
    https://git.kernel.org/netdev/net-next/c/47aeea0d57e8
  - [net-next,3/3] net: lan966x: Update mdb when enabling/disabling mcast_snooping
    https://git.kernel.org/netdev/net-next/c/add2c844db33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


