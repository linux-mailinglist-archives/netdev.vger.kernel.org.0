Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A23D6BC55D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCPElM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjCPElF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0565113;
        Wed, 15 Mar 2023 21:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90BC461F27;
        Thu, 16 Mar 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6FE7C433A4;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941620;
        bh=g73Zq5LApoZcbWOvhAbnPD5PurRehBcx2vXfSYdTF5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=glaBHW3/NNHyXHf4hm0m1hhbAF+f0KUtv3iJ9ik4GbneHVfxexkm71l6ZvIsL5S+A
         sBaa2V5O+5DrqtRAO/JLgOpytwWLboyp8fETx17SHFP4cXWgCT1fvVh3Zxpu4xAsib
         dHLjLfQdtXQl3KEcHZkE6x/rlgSfarHgs6Iasp6Uf6WWNIe/3tZ0Sw59MrHmYJFMCD
         RIFRZbk86vRgITpsQdqVkDD7IsB0jV9+Wp0BRdkO8gGiTeYxU6wVcGj2/OkTO92m6t
         nzEAcDRAdXBwnAS3vk4E6yNUy3YQ+ve0Qi/2mPTHzndijjwoV0GMf35hk3mbpdFRN/
         I/azFZiaktEYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6604E524FB;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net-next] net: phy: update obsolete comment about
 PHY_STARTING
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894162074.2389.7102398678903231099.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 04:40:20 +0000
References: <20230314124856.44878-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230314124856.44878-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hkallweit1@gmail.com, andrew@lunn.ch, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 13:48:56 +0100 you wrote:
> Commit 899a3cbbf77a ("net: phy: remove states PHY_STARTING and
> PHY_PENDING") missed to update a comment in phy_probe. Remove
> superfluous "Description:" prefix while we are here.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: phy: update obsolete comment about PHY_STARTING
    https://git.kernel.org/netdev/net-next/c/83456576a420

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


