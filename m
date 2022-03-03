Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C8B4CB6B7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiCCGLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiCCGLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:11:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2021662C5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85718B823EF
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29043C36AE2;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287813;
        bh=yyEr43OueyE+PuuSjZlbQa6mDogz9h8RG1i7dmXEpAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sqwGRlPKnyjmzkdMH4RIenqCmG422VKZoKMwKNDyOAQ4RmCBSRIPdO3ddxS9+jSru
         kf6RANKB29uRDmWukibcOnvCuAL3BiqXk4Ew/cyFYACAc8Mmnv8kwEHFJ63QquHN77
         k/eFhPIGPP6imB79jTtqqTVoXFJEB9xrHP9BfU2eASGihLj6DUYcoJ4LHlqVfCjZk8
         4PvR4pyYozYqwbPoaZckxxSWPklvSvj+4eN7+y5NYpnK/Tq2CO+HIGA1URkvw+9VMG
         BgvGr5C6V68KVEoZUirEFXNo01cyIpoJmEIqSyf1I0CEUdt7asRZBG/cZH/h8HlPNt
         IH3kJGxhQGP6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C669EAC09F;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sfp: use %pe for printing errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628781304.31171.11934600623235549304.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:10:13 +0000
References: <E1nOyEN-00BuuE-OB@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nOyEN-00BuuE-OB@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 01 Mar 2022 08:51:39 +0000 you wrote:
> Convert sfp to use %pe for printing error codes, which can print them
> as errno symbols rather than numbers.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/sfp.c | 48 +++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 18 deletions(-)

Here is the summary with links:
  - [net-next] net: sfp: use %pe for printing errors
    https://git.kernel.org/netdev/net-next/c/9ae1ef4b1634

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


