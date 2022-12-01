Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3C63E98B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiLAGAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLAGAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E2FA6B6D;
        Wed, 30 Nov 2022 22:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 321FFB81E19;
        Thu,  1 Dec 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7C52C433D7;
        Thu,  1 Dec 2022 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669874417;
        bh=uytOn92fgRz1/yGMTtcIU323KHZv/3Td+0NDw4fcpc0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BwuiJKgA3eFrwfCJwvybUcilp875jFSTZwMMbr+NlLY9rvvb/kvXq1cvL5InG2CbH
         /RYICVvC1dt1BKCk4vEf9fEo9IeYtrdLvwwUi6rGDJGkIenmupMR58iK8eUg+r3hVp
         rut0wJ/98aeLQJAY13YVxeOI2ybRXwzNl5MoQ23lWn3AZgZyzgBQOu28wtmRyMY4xj
         AwO8VuNY7uJRLrzoxh7AuoAFw3aJzpATd0jD82BxkEzNNJ+DqAWPNw38EaEuGJeSxA
         2zXHB0TtVsSBs/OIR3qFMUlmMy9BlMUMxDkkKoCq1t9QXyWBYTIFLKQOClvicbhZ4K
         5m8he8rJNZKkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD381E270C8;
        Thu,  1 Dec 2022 06:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix RGMII configuration at
 SPEED_10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987441683.13980.10249319419409671289.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 06:00:16 +0000
References: <20221129050639.111142-1-s-vadapalli@ti.com>
In-Reply-To: <20221129050639.111142-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, pabeni@redhat.com,
        rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vigneshr@ti.com, spatton@ti.com
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

On Tue, 29 Nov 2022 10:36:39 +0530 you wrote:
> The am65-cpsw driver supports configuring all RGMII variants at interface
> speed of 10 Mbps. However, in the process of shifting to the PHYLINK
> framework, the support for all variants of RGMII except the
> PHY_INTERFACE_MODE_RGMII variant was accidentally removed.
> 
> Fix this by using phy_interface_mode_is_rgmii() to check for all variants
> of RGMII mode.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10
    https://git.kernel.org/netdev/net/c/6c681f899e03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


