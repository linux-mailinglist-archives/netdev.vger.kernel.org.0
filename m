Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEDB6EBF92
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjDWMu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjDWMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B110D1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B7860F10
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E17BC433EF;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682254219;
        bh=T+GA06e6flwgduvpn13J/0O0GEtf2pY/ZBdVWrIHq/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kRmpnmikIvdICyGs3KGPpI90yU+G80y+zsHNPUXxeHBqdVetN+NnLOcIYQaKUcN1K
         2CkOt5dm4e0gY0ItMtz1UyRWKFV7W2/WGtRl2vxDrtWRDC5l2OtWnBqKMXNU60hmsM
         0ZdlSHO0PqSdrtIGfzM8xsGxtxy/G8vREiwslUH+9ADVD5a5VvDsPQh67TuIkSpWDn
         8I8Vs8zgr0aH1Edlmvd1sBoOvbYYjNvPvEdQglvZxyoKeCSxIwPhYWGIHUKzzPPAe1
         DUITtmaAzijQ9nsdl1nOpH8qWDoK2jomJZzBNLwLIlFnDZJf17mFgfsJ5PLk0+EXvX
         912/UMFEwlFKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B68EE270E1;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225421943.16046.3105777500851116721.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:50:19 +0000
References: <ZEK8Hvl0Zl/0NntI@debian>
In-Reply-To: <ZEK8Hvl0Zl/0NntI@debian>
To:     =?utf-8?q?Ram=C3=B3n_Nordin_Rodriguez_=3Cramon=2Enordin=2Erodriguez=40ferroa?=@ci.codeaurora.org,
        =?utf-8?q?mp=2Ese=3E?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 18:38:54 +0200 you wrote:
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> ---
> Changes:
>     v2:
> - Removed mentioning of not supporting auto-negotiation from commit
>   message
> - Renamed file drivers/net/phy/lan867x.c ->
>   drivers/net/phy/microchip_t1s.c
> - Renamed Kconfig option to reflect implementation filename (from
>   LAN867X_PHY to MICROCHIP_T1S_PHY)
> - Moved entry in drivers/net/phy/KConfig to correct sort order
> - Moved entry in drivers/net/phy/Makefile to correct sort order
> - Moved variable declarations to conform to reverse christmas tree order
>   (in func lan867x_config_init)
> - Moved register write to disable chip interrupts to func lan867x_config_init, when omitting the irq disable all togheter I got null pointer dereference, see the call trace below:
> 
> [...]

Here is the summary with links:
  - [v5] drivers/net/phy: add driver for Microchip LAN867x 10BASE-T1S PHY
    https://git.kernel.org/netdev/net-next/c/4d2bd2581c3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


