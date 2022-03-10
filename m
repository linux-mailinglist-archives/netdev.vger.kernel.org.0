Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B164D5517
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbiCJXLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiCJXLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:11:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F409199E25
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 02766CE268E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FF0DC340E9;
        Thu, 10 Mar 2022 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646953810;
        bh=1qM945DEoHBJCZkfAmfsJ7HSNwT1lx07N9oZtbr+NAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EBFKKoCv4uXexdTmV1a/Tg3Bhspwdbrm8Ni+2QVyJ4v7FcNwbII4mWtOa7apTGpra
         CcTpS2RDWO4BqvAuvTS0dFYHGWeMSvvmJBfmEC0XJhO+x1z95BxTsu2KsmXi8C17FA
         GSkj6cto3WYO60SYdwfFTEKOjfq4kfqnB66Gr9GEVJTIMZDgKCJc2gxMEgaXq/2H+r
         zcTzt5WG0h+pifxaRyivxJCdX/SzpyUYoF0C2vvV7X5AuJWpeF1jSibqCDWaR0xpdL
         KPqa6B02qZArN1l7qPewB+HJpsahM6FMTqeVOof6zgKSCXGoLPhPKN75iD/PVUr+dz
         FHhUSclOxypTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42A32E5D087;
        Thu, 10 Mar 2022 23:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: meson-gxl: improve link-up behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695381026.10760.7389598651371976837.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 23:10:10 +0000
References: <e3473452-a1f9-efcf-5fdd-02b6f44c3fcd@gmail.com>
In-Reply-To: <e3473452-a1f9-efcf-5fdd-02b6f44c3fcd@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, narmstrong@baylibre.com, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
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

On Wed, 9 Mar 2022 22:04:47 +0100 you wrote:
> Sometimes the link comes up but no data flows. This patch fixes
> this behavior. It's not clear what's the root cause of the issue.
> 
> According to the tests one other link-up issue remains.
> In very rare cases the link isn't even reported as up.
> 
> Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
> Tested-by: Erico Nunes <nunes.erico@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: meson-gxl: improve link-up behavior
    https://git.kernel.org/netdev/net/c/2c87c6f9fbdd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


