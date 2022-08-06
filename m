Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8171958B35A
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbiHFCKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiHFCKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F941101;
        Fri,  5 Aug 2022 19:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30274615C2;
        Sat,  6 Aug 2022 02:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79503C433D6;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751813;
        bh=V7SbDz03WbpY++eBN3j6G+hD2kxSeQT65+Mh4kxdYEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lRQPo4gESn97KjuLOwd1YMqZeo0M/17FqDzR9Kh3qmLSc8o20JFogUStSDBzIY94w
         ye75L1zchIeMR1oZbdsu124+lNFcojAiFbN7sL8CmmgP/NP3lULtsjB5DJMR8cqz6b
         Eg/FSKWP3z/GdtXMFZJ89sYNJmSinNDoGN0SGUzl5tTigGttX2T16fXxisA/un/ZPl
         DGsvlq6cbtNy+Dc9gSNuZtEGPlTqtDn6Cc8LMeDuxnwTQipMtENYtpEOG5vYRl3I6J
         Qu7f0I3SDwR7XOXqGahId4zF6ykNY1v+QuAL/CHfYtAWAvtkHt5AGff29UFN+spxYP
         P3/FYevkYg9og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E394C43144;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Indicate MAC is in charge of PHY PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975181338.26957.3943795875200964552.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:10:13 +0000
References: <20220804173605.1266574-1-f.fainelli@gmail.com>
In-Reply-To: <20220804173605.1266574-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  4 Aug 2022 10:36:04 -0700 you wrote:
> Avoid the PHY library call unnecessarily into the suspend/resume functions by
> setting phydev->mac_managed_pm to true. The GENET driver essentially does
> exactly what mdio_bus_phy_resume() does by calling phy_init_hw() plus
> phy_resume().
> 
> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Indicate MAC is in charge of PHY PM
    https://git.kernel.org/netdev/net/c/bc3410f25021

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


