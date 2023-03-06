Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C36AD075
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjCFVbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCFVbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:31:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F78686DE7
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0F160C7A
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA4A6C433A0;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678138219;
        bh=EtBdZ+quf5HvnnB8iyxHXr0NOYoYrc3miaR/GZU2/mQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCFCSrEfxu63XP+nJCyB9hGUNDlkAGlN65VpynRhju4kYjk28pu1G56+zv1ypZkYd
         rthHRdDmR41IZLd4kKIus5mdLvOCRNyXe1iaiy7NA0zSj13DEZNengIWLPLKvk6Gja
         uEiChy42rV1fdtQDtdLoGwTgGgwydY4NqXuHANo1IgTFRvfSaShVXpjSpBZR8XRZFZ
         mPPiSp3WA5hjs6vW+xxebNijByAe5f820DluS+b4MD4AOLC8eOVPjLF01r4D+mTmKu
         wWMjQQV7FbwqAf7F9P9cE84igT3eCoCJkaDfWhpp8kLliwpM7yxTB75JK6esKS10+Y
         J3sY6OdEMUv2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7BE3E524EF;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: smsc: fix link up detection in forced irq mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167813821881.7576.8913349048723369522.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 21:30:18 +0000
References: <5dca131f-e47b-22a9-3f9a-ec754fa532bc@gmail.com>
In-Reply-To: <5dca131f-e47b-22a9-3f9a-ec754fa532bc@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        m.felsch@pengutronix.de, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 4 Mar 2023 11:52:44 +0100 you wrote:
> Currently link up can't be detected in forced mode if polling
> isn't used. Only link up interrupt source we have is aneg
> complete which isn't applicable in forced mode. Therefore we
> have to use energy-on as link up indicator.
> 
> Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: smsc: fix link up detection in forced irq mode
    https://git.kernel.org/netdev/net/c/58aac3a2ef41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


