Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB085AA6C9
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiIBEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiIBEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:10:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0095632066
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 21:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87E5ECE2950
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5ED8C433B5;
        Fri,  2 Sep 2022 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091814;
        bh=X6Sh1GLGzcjf5HWKApYGwzk9soYOj7EmNjdAbMqcZPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p4w5aRnBPArvF0i9Fm9aCMxhFms+bGwwIpLDaCO2TardEyK0pQQEjKHr6ixmHwLZM
         hSiwXq8SbwJVEGT2SAXUwdyS4Yzz8b+UhUn32cWdHmT02jud0Lc+44pcyfQiXW5wTb
         bK2LcW+1ZzRbkB7SgG6xsTL4lNV7cTKWlofdK8kuK/nHWpL60dnzJp6qlYZkMBZB5C
         a/g1dt5M4s3lbTB4qWAnOYPBft9dshGEeUgXHV9ScjitRYbYKhUbwJ85X337/ek/3x
         xzaeSFamgkaFmntJCYCtwKYxNJfAT8YAkJFyxlB4+bMeIkN9DybROQ4Av3ibA9lUXz
         bSDCA81gfD8MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 977CEE924D6;
        Fri,  2 Sep 2022 04:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: phy: meson-gxl: improve link-up behavior"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166209181460.19149.17976066584717562078.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 04:10:14 +0000
References: <8deeeddc-6b71-129b-1918-495a12dc11e3@gmail.com>
In-Reply-To: <8deeeddc-6b71-129b-1918-495a12dc11e3@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, andrew@lunn.ch, linux@armlinux.org.uk,
        narmstrong@baylibre.com, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 21:20:49 +0200 you wrote:
> This reverts commit 2c87c6f9fbddc5b84d67b2fa3f432fcac6d99d93.
> Meanwhile it turned out that the following commit is the proper
> workaround for the issue that 2c87c6f9fbdd tries to address.
> a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
> It's nor clear why the to be reverted commit helped for one user,
> for others it didn't make a difference.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: phy: meson-gxl: improve link-up behavior"
    https://git.kernel.org/netdev/net/c/7fdc77665f3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


