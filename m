Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C543610E46
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiJ1KUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJ1KUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257EE543D4;
        Fri, 28 Oct 2022 03:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED91DB8292F;
        Fri, 28 Oct 2022 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DABCC433D7;
        Fri, 28 Oct 2022 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666952417;
        bh=OYm9zLdGD8q62vWhGx9/cAa9hxjXMs+1vgWaph6hOpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJHTQVNj+JOa4P9imykkojbhnf5Zcsz6Lnbk1vceGP7xdaP6Z3aj30JeMAN2WVO5R
         s3BaZERd8JOud5D0CZFwFQM93BvYC+HXxmuPPPfyVbmuNwCqMCgtO1B8K13L3Vwp1b
         pvDvbKcds6kL30oQ3i4wjj+lMpwnH1FqO8y6qt+ZobjcSiKeSTgPkXmvIOq35MNQmZ
         EjLZlaYYPx73JX6ksDw56mjzGfYgZQe6c3w+ISUjgCV02wvT3WQwBbw4an7QOkilGk
         u1FBxPPvBlSJfWW/lN7l7du4I7667NVWVsNT9DQGwuja3Rfai+yBr3725MAa6n+kf2
         y+9AF1wq08EXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72B67C4314C;
        Fri, 28 Oct 2022 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V1 0/2] net: phy: mxl-gpy: Add MDI-X 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695241746.31704.11349157920416012770.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 10:20:17 +0000
References: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lxu@maxlinear.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, Ian.Saturley@microchip.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Oct 2022 11:29:16 +0530 you wrote:
> This patch series add the MDI-X feature to GPY211 PHYs and
> Also Change return type to gpy_update_interface() function
> 
> Raju Lakkaraju (2):
>   net: phy: mxl-gpy: Change gpy_update_interface() function return type
>   net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips
> 
> [...]

Here is the summary with links:
  - [net-next,V1,1/2] net: phy: mxl-gpy: Change gpy_update_interface() function return type
    https://git.kernel.org/netdev/net-next/c/7a495dde27eb
  - [net-next,V1,2/2] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips
    https://git.kernel.org/netdev/net-next/c/fd8825cd8c6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


