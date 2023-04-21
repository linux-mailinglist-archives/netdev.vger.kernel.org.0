Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D243E6EA190
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjDUCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjDUCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0CE3C34;
        Thu, 20 Apr 2023 19:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 970A2647BB;
        Fri, 21 Apr 2023 02:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E87BBC4339B;
        Fri, 21 Apr 2023 02:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682043620;
        bh=JA81Mm074MiULwVSpeXVNBbE+9b4mCmFNAJNTDHJN9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dW0DRZSZa9yvitKhcuvlV6RwfF9ZNN8j6rbGiga/fbj4+skYNHvKPCG2rVDMYVpGL
         JafzUs/4YVMvE87NhI1SObc+arOWCP65uWSvIRz8BBMy8jkQLakReATecUXCh5/73P
         eyuExAJ+4aavW2L7Acv7Ux9EaToVMVKRQJzfnigibHgEdgidwWTVEIxlmtCOnRMiab
         ADkJydS8f0TMsM9TElpghc5R8JBIKYt1ToV1vd3nEAW7XYHvM85eD2OehuNC6uVVZP
         zmfGdhNiWDIGx/s+uOJsHWMXkKi7GXegJtcx3K8q56GnEDAONjcJ3LSt3qAYOssYaz
         xzC98vYjntFQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA5A3E270E1;
        Fri, 21 Apr 2023 02:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: fix circular LEDS_CLASS dependencies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204361982.5507.17481778283181053280.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:20:19 +0000
References: <20230420084624.3005701-1-arnd@kernel.org>
In-Reply-To: <20230420084624.3005701-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        f.fainelli@gmail.com, ansuelsmth@gmail.com, arnd@arndb.de,
        linux@armlinux.org.uk, Frank.Sae@motor-comm.com,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 10:45:51 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The CONFIG_PHYLIB symbol is selected by a number of device drivers that
> need PHY support, but it now has a dependency on CONFIG_LEDS_CLASS,
> which may not be enabled, causing build failures.
> 
> Avoid the risk of missing and circular dependencies by guarding the
> phylib LED support itself in another Kconfig symbol that can only be
> enabled if the dependency is met.
> 
> [...]

Here is the summary with links:
  - net: phy: fix circular LEDS_CLASS dependencies
    https://git.kernel.org/netdev/net-next/c/4bb7aac70b5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


