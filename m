Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FB067F66A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjA1IkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjA1IkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB781E1DF;
        Sat, 28 Jan 2023 00:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 499EDB8123A;
        Sat, 28 Jan 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE4C0C433A4;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895217;
        bh=TA1ofjOcLPjiwF2U0i3uTmB6DZjxCQ5X23rvpGmXttE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MJ8LEpi4B/gA062uf0LjjNKSHNPK5m36BrCgBlHMn+Su1QZ6b1ZMJC8fWtIZV0RQy
         xHthSoI8P8tTDW4dYzRwt1Vu+RGqzEuv4UkgS3YLcXIWS4hzBm3IiXyd6IkxNaHnok
         XGCekWUBPZFXuXimuqZq634HQCVi/BbBzZiX3XcqdDRz3FCTIfHj6MXbM90UR8ql+N
         vFQOIf3s8Or6C71nGC/ygtmzvS/TB6U0cvGDqArZbmk1DXYMUR+uIvJpt3Ftxj97/r
         LS0kOfOhBObDE3IBrNEsg273EuX5Y+uMHhpB7JRzbu6zS8IzIcL6hI9FA47mgY+SF3
         7JcachdPTgatw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99B6DF83ED2;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: dp83822: Fix null pointer access on
 DP83825/DP83826 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489521762.20245.17614376915364522830.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:17 +0000
References: <Y9FzniUhUtbaGKU7@pc6682>
In-Reply-To: <Y9FzniUhUtbaGKU7@pc6682>
To:     Andre Kalb <svc.sw.rte.linux@sma.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, felix.riemann@sma.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 19:23:26 +0100 you wrote:
> From: Andre Kalb <andre.kalb@sma.de>
> 
> The probe() function is only used for the DP83822 PHY, leaving the
> private data pointer uninitialized for the smaller DP83825/26 models.
> While all uses of the private data structure are hidden in 82822 specific
> callbacks, configuring the interrupt is shared across all models.
> This causes a NULL pointer dereference on the smaller PHYs as it accesses
> the private data unchecked. Verifying the pointer avoids that.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices
    https://git.kernel.org/netdev/net/c/422ae7d9c722

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


