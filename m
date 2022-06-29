Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CBF55F568
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiF2EuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2EuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7EE17E24
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A432614F6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4845C3411E;
        Wed, 29 Jun 2022 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656478213;
        bh=u6B+4XjrHuIhqCGF1f+LNOE7uzTCHDnG3WpJ2xg+NtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bkQwuY1Nxu25op3gkaX6wUOGj/XTNR4ay9+vFtAuMupQkQTa+kZJexvp/aUOOCrYv
         Lb9rEOQTyWDpY7o7RIus6EhUxp9eSFYOdVaZiNaRh3g8MhMQ00jMxqEqLu41Su7veF
         wABLlD/qTVUKZP0tK8FNn4m6d8YYfcvkVtRkEgRsf8JefQGHfwCecLhe4sP9+OhU3Y
         d1T4qPCOtbbITLx+uc/HOobV90i2pEl9K+0Bny+dY6t4HvUkuV6W3x8WFXDWZBLw4h
         hI3dPGzgdu5S4BeakW5y19bjri7pVOnGIhPiAa6r9qnDdyz8t1c3c9M4ZbZkcZkQhA
         zCyrDfV7+44tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 995C9E49F61;
        Wed, 29 Jun 2022 04:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: phylink: cleanup pcs code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647821362.6492.1196261975874560231.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:50:13 +0000
References: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
In-Reply-To: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 27 Jun 2022 12:44:16 +0100 you wrote:
> Hi,
> 
> These two patches were part of the larger series for the mv88e6xxx
> phylink pcs conversion. As this is delayed, I've decided to send these
> two patches now.
> 
>  drivers/net/phy/phylink.c | 69 ++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 30 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: phylink: remove pcs_ops member
    https://git.kernel.org/netdev/net-next/c/4f1dd48f4031
  - [net-next,2/2] net: phylink: disable PCS polling over major configuration
    https://git.kernel.org/netdev/net-next/c/bfac8c490d60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


