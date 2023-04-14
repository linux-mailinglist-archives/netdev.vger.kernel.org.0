Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869006E1B99
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDNFUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDNFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41304EEA;
        Thu, 13 Apr 2023 22:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61D316152B;
        Fri, 14 Apr 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 914CFC4339B;
        Fri, 14 Apr 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681449620;
        bh=y4z1RrrUz5zR0E/MaCu9mP+QZG439YPqJaY54tXJ8lU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SeyobJWd7VJLAyhztFeoEbPm6OaJNRyO3BanD5kQoqLvIEjc3Cx/Lp0zU9lk0uITp
         ZW6s7yo4LFSHIWkSyN0Q6biv9Q5KjSx+fKS49cNgdczzFVbQDsL7gQ9jed2PMNkhIv
         QhxBeQ0XZCtsRMJIz87J3k/0WzWGlWIWow06OHz79jMR3al9F0Dg8bdfgzdEd2AAds
         MpCcj65GrX53V0H8AX1PXh8y3WnqhKSclihQ9enaqyjjkZ2R5etHktpCEFEs5p+1Qt
         4ykvseHun/AjNUYYajJjlVvfzlUzfVTQyDKszZTwMbj423z2G32snLwb4qdqWA7C7I
         y8MTdISWGalkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74BDDE52441;
        Fri, 14 Apr 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] Ocelot/Felix driver cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168144962047.25322.17442907166607940034.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 05:20:20 +0000
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        colin.foster@in-advantage.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 15:47:29 +0300 you wrote:
> The cleanup mostly handles the statistics code path - some issues
> regarding understandability became apparent after the series
> "Fix trainwreck with Ocelot switch statistics counters":
> https://lore.kernel.org/netdev/20230321010325.897817-1-vladimir.oltean@nxp.com/
> 
> There is also one patch which cleans up a misleading comment
> in the DSA felix_setup().
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors
    https://git.kernel.org/netdev/net-next/c/9ecd05794b8d
  - [net-next,2/8] net: mscc: ocelot: refactor enum ocelot_reg decoding to helper
    https://git.kernel.org/netdev/net-next/c/40cd07cb4261
  - [net-next,3/8] net: mscc: ocelot: debugging print for statistics regions
    https://git.kernel.org/netdev/net-next/c/07de32655bb4
  - [net-next,4/8] net: mscc: ocelot: remove blank line at the end of ocelot_stats.c
    https://git.kernel.org/netdev/net-next/c/93f0f93bbdb9
  - [net-next,5/8] net: dsa: felix: remove confusing/incorrect comment from felix_setup()
    https://git.kernel.org/netdev/net-next/c/a9afc3e41c61
  - [net-next,6/8] net: mscc: ocelot: strengthen type of "u32 reg" and "u32 base" in ocelot_stats.c
    https://git.kernel.org/netdev/net-next/c/eae0b9d15ba6
  - [net-next,7/8] net: mscc: ocelot: strengthen type of "int i" in ocelot_stats.c
    https://git.kernel.org/netdev/net-next/c/6663c01eca1a
  - [net-next,8/8] net: mscc: ocelot: fix ineffective WARN_ON() in ocelot_stats.c
    https://git.kernel.org/netdev/net-next/c/a291399e6354

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


