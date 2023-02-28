Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E566A58BF
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 13:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjB1MAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 07:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjB1MAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 07:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4244E2D17B;
        Tue, 28 Feb 2023 04:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F55A61052;
        Tue, 28 Feb 2023 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAD40C4339B;
        Tue, 28 Feb 2023 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677585618;
        bh=TybXlXsEufGFAnnew4E4g1LpOUYh/t//K0Edna/zuN0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YXNQY1sqHjZwZTiRJZBAy5R4kVpCulVkstnmha0VJIk9K4uIIGpF5bofLIDNYav1c
         ofgnGDq2llhVhEfq7P3smo5YpiQP+hJVF4CsSz/O3M7NosZAZqPZlQWtXdZ1H0gDjr
         brUZlr9holeUCOGs/eIU7DBLxBlMolofy+g3fGtWaIi5q2+8LczNNMXBvtP57naG2z
         ZgJzQfiJy9q3SAX6PJr4xH9EpjNIGqwc3EdkchkcHS0uhGg2pT7qFyLNsEDcK6Wq2x
         qStxcc5piyL3eq6rMHN/xQbo0bg5oweEktUS4gOMUhBYNoQLuq3r+/gpLp8QbqImEK
         eDZp4dCDw1epg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD244C691DE;
        Tue, 28 Feb 2023 12:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: unlock on error in phy_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167758561876.17796.13786935429522256800.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 12:00:18 +0000
References: <Y/x/6kHCjnQHqOpF@kili>
In-Reply-To: <Y/x/6kHCjnQHqOpF@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     linux@rempel-privat.de, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Feb 2023 13:03:22 +0300 you wrote:
> If genphy_c45_read_eee_adv() fails then we need to do a reset and unlock
> the &phydev->lock mutex before returning.
> 
> Fixes: 3eeca4e199ce ("net: phy: do not force EEE support")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/phy/phy_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: phy: unlock on error in phy_probe()
    https://git.kernel.org/netdev/net/c/8f9850dd8d23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


