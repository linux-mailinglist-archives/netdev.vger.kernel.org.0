Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913E85BF1BF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiIUAKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD2A481C1;
        Tue, 20 Sep 2022 17:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 319FCB82DBD;
        Wed, 21 Sep 2022 00:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8F64C433D7;
        Wed, 21 Sep 2022 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663719014;
        bh=NZq2sMb0aJXtIxCqDmcKjgY2BJBxOGwdDMnkBZFx3v4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bqorjHCBmADfW7K2dfwkM8bILpe0rfVGJ4LlU49BXhdSr5t3mHzYzkkhUUKOgtMv4
         kcDE+5fz6tUtdbXV3ORmO8O8Zbd7a4XwgogrOEaufWl3egC9MQmSy+uqAVprJDbh0A
         C5DX5tpFZt4rgjXWoeslX0i46+AnGuWnv5kSzUfSDdalyJOBKwwsTOh5SkMAz/RTd9
         G/C6xyzfGfyjIhoZ3+nSgGWft0dHXABYS/a2RszZaOk6z9a6JQRRW/8X1WRsZNTfXQ
         vs9YloT+x9LVRP3ZFEtaorcZSkwEcdKiQH4RZ3qbyQXudCS/wLXM1MDV5H8KVI/v5s
         BZEYrT4odhclw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A26BEE21EE0;
        Wed, 21 Sep 2022 00:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ravb: Fix PHY state warning splat during system resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371901465.22206.7987377877016887147.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 00:10:14 +0000
References: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
In-Reply-To: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hkallweit1@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Sep 2022 16:48:00 +0200 you wrote:
> Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state"), a warning splat is printed during system
> resume with Wake-on-LAN disabled:
> 
>         WARNING: CPU: 0 PID: 1197 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xc8
> 
> As the Renesas Ethernet AVB driver already calls phy_{stop,start}() in
> its suspend/resume callbacks, it is sufficient to just mark the MAC
> responsible for managing the power state of the PHY.
> 
> [...]

Here is the summary with links:
  - net: ravb: Fix PHY state warning splat during system resume
    https://git.kernel.org/netdev/net/c/4924c0cdce75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


