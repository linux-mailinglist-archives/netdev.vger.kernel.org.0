Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A040E4C55FE
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiBZNAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 08:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiBZNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 08:00:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58640266D99
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 05:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B5ACB80757
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 13:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F505C340F4;
        Sat, 26 Feb 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645880412;
        bh=4728MBDU0Nk3qYBidPpP8inmdGSI44PXxdlKIz273tw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fHyWGEEWyown9LdQ3EDIdYsgOLkGUxJXekGUY/fPbvzVKQw9rfdDPg7Itkhu3fYwW
         d9D5T1azBs1Tu7EkzGSevXzu6gERmxPmFFSeXEK7MIg5nguT847zOp4+hQcKv0HmpQ
         Ck1HI31bR3yqOr7mQFJnvVLEWlamnL71vMZDq1MA6RLYClO+IX9LH0by7FsL1mQwhw
         JV/gaVIjQxv6XW3KHLW2gqm5cGNvemqg3QA9/49bD70tPZe6WRu6yar/ZSrRIQkY5F
         T26dQu94eH04R99cyPO1qTcv+ZKhx35ZtROTmVG+lNIexxcb1GAi7WJEINumQdtIXr
         MndjSCc6zlQJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89B9FE6D3DE;
        Sat, 26 Feb 2022 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: dsa: ocelot: phylink updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164588041256.8718.13645463941585617063.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Feb 2022 13:00:12 +0000
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
In-Reply-To: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, kabel@kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 25 Feb 2022 16:19:10 +0000 you wrote:
> Hi,
> 
> This series updates the Ocelot DSA driver for some of the recent
> phylink changes. Specifically, we fill in the supported_interfaces
> fields, convert to mac_select_pcs and mark the driver as non-legacy.
> We do not convert to phylink_generic_validate() as Ocelot has
> special support for its rate adapting PCS which makes the generic
> validate method unsuitable for this driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: dsa: ocelot: populate supported_interfaces
    https://git.kernel.org/netdev/net-next/c/79fda660bdbb
  - [net-next,2/4] net: dsa: ocelot: remove interface checks
    https://git.kernel.org/netdev/net-next/c/e57a15401e82
  - [net-next,3/4] net: dsa: ocelot: convert to mac_select_pcs()
    https://git.kernel.org/netdev/net-next/c/864ba485ac52
  - [net-next,4/4] net: dsa: ocelot: mark as non-legacy
    https://git.kernel.org/netdev/net-next/c/f6f04c02047c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


