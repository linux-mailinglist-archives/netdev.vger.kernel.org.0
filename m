Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E34B3C2F
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 17:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiBMQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 11:00:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiBMQAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 11:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47D05A090;
        Sun, 13 Feb 2022 08:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB81B80B32;
        Sun, 13 Feb 2022 16:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC571C340F1;
        Sun, 13 Feb 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644768009;
        bh=NHfdKjeTuxcD4nBefS/7IExmAbxEENP7iDHNnB9FTQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TpPJNKsvcLBso5tF2fDlQqxCtBRSPNhjac9YtrY2FeRXcdrR9goPkt8bef246HJr4
         AA5RTiPEpzphcMKr3S0UBBy43eQfviBwK2et9+YtOmK3iWTQSMe8Yi4yy945tsPMeX
         TnKlyxWcNLo57JBcEDldTgLf1GgonUr/Va9M7tGYShP/svLux7+1yEFa5Y8Cn4HQpi
         6GATvPAF7Wqb6H38tUz60VH8mRmonqaMDR8IIBFtmRfb6CBKKxtgKoxgV4EgWRoq/L
         f6kt0J7t4Fb4ySqsdA7eVuY6ZBjfAuSzF3ou87LH/6+SrzHEYfghZAJWJnwEqVYcC/
         STpT5sktQsNkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C564DE5D07E;
        Sun, 13 Feb 2022 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lan966x: Fix when CONFIG_IPV6 is not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164476800980.537.18199680596590664378.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Feb 2022 16:00:09 +0000
References: <20220212200343.921107-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220212200343.921107-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, lkp@intel.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 12 Feb 2022 21:03:43 +0100 you wrote:
> When CONFIG_IPV6 is not set, then the linking of the lan966x driver
> fails with the following error:
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
> reference to `ipv6_mc_check_mld'
> 
> The fix consists in adding a check also for IS_ENABLED(CONFIG_IPV6)
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lan966x: Fix when CONFIG_IPV6 is not set
    https://git.kernel.org/netdev/net-next/c/867b1db874c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


