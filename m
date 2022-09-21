Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEE5BF1BC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiIUAKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIUAKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59723419A3;
        Tue, 20 Sep 2022 17:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8457062EAD;
        Wed, 21 Sep 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1393C433B5;
        Wed, 21 Sep 2022 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663719014;
        bh=USJfMo9G5LTVqiOPXZPGXYioWux37smQZpdvofRzyY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fwxbx78lWren4Z6BZ6Dm37ThtT/VbaHhmDKXdn+sp2KOh5m4sE+q1uA3xBGMgHGJU
         1BAPKcc40QDvHaXWA92VKBUlHRaUrNN0ud43snAeOv6AzPcg2iTDwextptYF8EQbkR
         dyLXF54/Cy2gy9ZVFsV2A9Tvi8KCPQoHrAfHF0/9oGUgWE2qE7Yk6KBxo5AIMxFr9f
         qfGcdWGM8Fc2vvPKi3phr8Pzvw8CBVbkWZDKAUQvQeUIEReeICXuDsEF4WqzHu2+pT
         MOh+zr1B+rOT0yowi9xXbdNXFANPXMJDjHSzi9fBwwXE1NmGwC68YcxzoiBt3p0Z5l
         OKYIVidJTakiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B05EAE5250A;
        Wed, 21 Sep 2022 00:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sh_eth: Fix PHY state warning splat during system resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371901471.22206.14776111693725439875.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 00:10:14 +0000
References: <c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be>
In-Reply-To: <c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be>
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

On Mon, 19 Sep 2022 16:48:28 +0200 you wrote:
> Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state"), a warning splat is printed during system
> resume with Wake-on-LAN disabled:
> 
> 	WARNING: CPU: 0 PID: 626 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xe4
> 
> As the Renesas SuperH Ethernet driver already calls phy_{stop,start}()
> in its suspend/resume callbacks, it is sufficient to just mark the MAC
> responsible for managing the power state of the PHY.
> 
> [...]

Here is the summary with links:
  - net: sh_eth: Fix PHY state warning splat during system resume
    https://git.kernel.org/netdev/net/c/6a1dbfefdae4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


