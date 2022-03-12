Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F424D6E9A
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 13:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiCLMLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 07:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiCLMLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 07:11:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EC610C1;
        Sat, 12 Mar 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23BD360ED9;
        Sat, 12 Mar 2022 12:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73C65C340EE;
        Sat, 12 Mar 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647087012;
        bh=od+O6iBCXPg7m95XTkKOVRXfTF7XVSzEbp2nKdwRS9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mHJOQhvUYWiPC1jLkgUrw6xzK1CPDFVFui3OmzlZRj07Zss4SVW6IMrhh5DrN2Ujx
         lCFCSThhrulGpbFnXc+P4DMwr8ExpB6obkCwN/bOMI9HWgsTd/JLjBBTW2uXylLudl
         XFgTjNlaTPJh10qTiZD2eqOlFuaqxI8KHi3y5RjZ1ogB6A9uZfbqHYe7P0wRWaqjI2
         SPvf0hEKsnm2dfglrfeeKep9l98n421/yjJJd1q3JhmesEbyedni914khw8qJB1l+7
         wCPX6y84J3COK4DuDkzZRL+wXYQ/XMgsgXePBEzP0q4CDeCCDL9T3Px6a9q9gbS2J3
         pYdxXNzqzHEDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FE03F0383F;
        Sat, 12 Mar 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/4] net: usb: asix: unify ax88772_resume code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164708701232.11169.2704062360712589828.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 12:10:12 +0000
References: <20220311085014.1210963-1-o.rempel@pengutronix.de>
In-Reply-To: <20220311085014.1210963-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 09:50:11 +0100 you wrote:
> The only difference is the reset code, so remove not needed duplicates.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/asix.h         |  1 +
>  drivers/net/usb/asix_devices.c | 32 ++++++++------------------------
>  2 files changed, 9 insertions(+), 24 deletions(-)

Here is the summary with links:
  - [net-next,v2,1/4] net: usb: asix: unify ax88772_resume code
    https://git.kernel.org/netdev/net-next/c/d57da85dc4e3
  - [net-next,v2,2/4] net: usb: asix: store chipid to avoid reading it on reset
    https://git.kernel.org/netdev/net-next/c/5436fb3fd4c1
  - [net-next,v2,3/4] net: usb: asix: make use of mdiobus_get_phy and phy_connect_direct
    https://git.kernel.org/netdev/net-next/c/d5f3c81c569f
  - [net-next,v2,4/4] net: usb: asix: suspend embedded PHY if external is used
    https://git.kernel.org/netdev/net-next/c/4d17d43de9d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


