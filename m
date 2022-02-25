Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEB74C3DDA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbiBYFaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiBYFap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:30:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC3F25D6CB;
        Thu, 24 Feb 2022 21:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A224EB82B1E;
        Fri, 25 Feb 2022 05:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C23DC340F0;
        Fri, 25 Feb 2022 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645767011;
        bh=RCaVpBs4umykVKi5xoTtVx5jUXlr8oeVJBAPO5UQat8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NZGR6u2xA36Rf36tZsAQ9CpIkoa94O4Bdo43Oq4a2CqaoyTS0GlsBWB4CbcnJpwCl
         eyLSUaAcSWTS6LEM2Vc9LeAlMsOAE4c3Ijc8xNCL6FFSU7Pt3X+Y3eSgLGEJOoddWT
         Y2Qf2RHXJA8qRSComEV3DyiVHjO2s1v6t4HxlR88Flm9BYqKiK7jsxZAaW7QQzGOWa
         W5M28iM3y+gxoXexD0+jBUFmiVwlMgSUFRsYrrhInGVGiOPyKMWcKiuNwkCfKDwu9C
         QoF+s+sajEgrqsPyBI8nJDRs1OC3/qz6FrZGU6lZvOrtDNZalmRL20TfAbKLcyxYGm
         LosLyV0khTqFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21067EAC09A;
        Fri, 25 Feb 2022 05:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: asix: remove code duplicates in
 asix_mdio_read/write and asix_mdio_read/write_nopm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576701113.8286.1656373152223495130.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 05:30:11 +0000
References: <20220223110633.3006551-1-o.rempel@pengutronix.de>
In-Reply-To: <20220223110633.3006551-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
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

On Wed, 23 Feb 2022 12:06:33 +0100 you wrote:
> This functions are mostly same except of one hard coded "in_pm" variable.
> So, rework them to reduce maintenance overhead.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/asix_common.c | 74 +++++++++--------------------------
>  1 file changed, 19 insertions(+), 55 deletions(-)

Here is the summary with links:
  - [net-next,v1,1/1] net: asix: remove code duplicates in asix_mdio_read/write and asix_mdio_read/write_nopm
    https://git.kernel.org/netdev/net-next/c/89183b6ea8dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


