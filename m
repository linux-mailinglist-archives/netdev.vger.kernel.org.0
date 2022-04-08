Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE64F9F45
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiDHVmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiDHVmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:42:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A94DE6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 14:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9574B62089
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 21:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E968AC385AC;
        Fri,  8 Apr 2022 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454013;
        bh=AMek6ftIXhHDFOWAG9wPsz0/c6ykBBIZeoTYVvBjjhY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JrLCpHWw0Bn9H5Ai0chvitEySnOinstdMMFgoJm8+HIF7DiH/IkDPrRuG60f42j2b
         AXK4xZOBzepV7aJfd9A0xBHtiRTUvIuY1Cegw7djAXfX6USRscJMJZqaxZOfTJSZeh
         BdakcOgqyJgFSbA9+QEyR0UNzF9IjE0CjrOEjKmFnX4D4elNddB5Nz+76HnZzq1A7O
         ENMwqvcR75zW3Qmw+vwVw2sSjW3khyAHzh0A9LhBFdvw89+NSDZoEf4rPTVdDDR9PR
         uryJzQTgjGrmqII+K04NJUjY3O0IXOL+puYICHhRSXZp92Y9ZNIfl3r44Jnyw+j8te
         gwrY/vzx/YFtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D66A2E8DD5E;
        Fri,  8 Apr 2022 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: phy: micrel: ksz9031/ksz9131: add cabletest support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945401287.15686.9752937509094914437.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:40:12 +0000
References: <20220407105534.85833-1-marex@denx.de>
In-Reply-To: <20220407105534.85833-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        hkallweit1@gmail.com, kuba@kernel.org, linux@rempel-privat.de,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 12:55:34 +0200 you wrote:
> Add cable test support for Micrel KSZ9x31 PHYs.
> 
> Tested on i.MX8M Mini with KSZ9131RNX in 100/Full mode with pairs shuffled
> before magnetics:
> (note: Cable test started/completed messages are omitted)
> 
>   mx8mm-ksz9131-a-d-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code Short within Pair
>   Pair B, fault length: 0.80m
>   Pair C code Short within Pair
>   Pair C, fault length: 0.80m
>   Pair D code OK
> 
> [...]

Here is the summary with links:
  - [v3] net: phy: micrel: ksz9031/ksz9131: add cabletest support
    https://git.kernel.org/netdev/net-next/c/58389c00d49c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


