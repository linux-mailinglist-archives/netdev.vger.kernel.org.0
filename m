Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1E4D54DA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbiCJWvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiCJWvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:51:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD2E6D97;
        Thu, 10 Mar 2022 14:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F47CB82913;
        Thu, 10 Mar 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7AC8C340EC;
        Thu, 10 Mar 2022 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646952610;
        bh=hEm9yfQbDimDC1MMyXWA8HzJ6yu/QgWsVJ6hrNS/ceI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DJyMD9nVNHn16uoNn6sUYJY6JODqcE/MAJfLAGfnC+NU0lu3EPcKGSAEXr8XFnBjx
         ZwNijdMaJbctWUQh1MJiI0hjKy0PqVKUEjz7wQB2YOshdBRA9W4u1Y9Wb6JJWOGSzp
         clgl72l16ZAvD8zlbc8qGJzBH7d2SYLOZyUf9FoyTFtjjmIz2xpVipAlK3NXBerL+o
         PmW6upO8+SBzcFGU1Wd+0UanAITVPzvcFbOPlb0jZWIz3Gw1OK/0ap/bnmZBNYimmS
         ScpY8DDA6NnLJoZpkyPK1Cho+4CE36lFZLDlUD0oQm+oE+TG+pmA16R9t0Rjm34sl6
         NkLgxxOwYqOFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2421F0383F;
        Thu, 10 Mar 2022 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: correct spelling error of media in documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695261078.1555.10126107118950589833.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:50:10 +0000
References: <20220309062544.3073-1-colin.foster@in-advantage.com>
In-Reply-To: <20220309062544.3073-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk, hkallweit1@gmail.com,
        andrew@lunn.ch
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 22:25:44 -0800 you wrote:
> The header file incorrectly referenced "median-independant interface"
> instead of media. Correct this typo.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Fixes: 4069a572d423 ("net: phy: Document core PHY structures")
> ---
>  include/linux/phy.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: phy: correct spelling error of media in documentation
    https://git.kernel.org/netdev/net/c/26183cfe478c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


