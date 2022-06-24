Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8584F558F67
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiFXEAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiFXEAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AFF527D9;
        Thu, 23 Jun 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26DC7620D2;
        Fri, 24 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58A1FC341D2;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656043214;
        bh=4YTrdJzehs5qVF2w7dXFKmyB+SWb7gFgphvO7oVx2yo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QirUhX4UQauqsUqUgMiEoNS21EZUGrcyN9Opu/govcbc3cmagAn2r3ZmPdhZ/QRCg
         y/RdDg0RBi2VXS4c9eCQ9Iz62oQ0IX7memvwEEX2tsMAN/PnEvbMvA7Fw2wayxoXDT
         mohf9DZAniWh0CMM/dPbSO5U4OXOpWcRdyl+tCu6r08Yth/VZy/I6u7miE7UpbbMk8
         74zNyZn/ONHCnn2xkXdKeEFnEizwaYEdx1fhgVFSQQl39+cvx5eNRkPZWJRjaE0mXt
         FAfec12EUxdPBW36NBGwJAGEf2qprbjb2ZN/ZUm7LTil2ohIH1wYCxO4cNft6JHQH2
         jk8eQMMyyuFFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35F16E8DBDA;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: use new hwmon_sanitize_name()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604321421.27108.12508009555959484914.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:00:14 +0000
References: <20220622123543.3463209-1-michael@walle.cc>
In-Reply-To: <20220622123543.3463209-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@roeck-us.net
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 14:35:41 +0200 you wrote:
> These are the remaining patches of my former series [1] which were hold
> back because it would have required a stable branch between the subsystems.
> 
> [1] https://lore.kernel.org/r/20220405092452.4033674-1-michael@walle.cc/
> 
> Michael Walle (2):
>   net: sfp: use hwmon_sanitize_name()
>   net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sfp: use hwmon_sanitize_name()
    https://git.kernel.org/netdev/net-next/c/3f118c449c8e
  - [net-next,2/2] net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()
    https://git.kernel.org/netdev/net-next/c/363b65459b78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


