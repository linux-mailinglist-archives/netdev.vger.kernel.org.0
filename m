Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81F4CE2C4
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiCEFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiCEFVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:21:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F4120F61
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 21:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D34EB80B1A
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 05:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38C19C340EE;
        Sat,  5 Mar 2022 05:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646457612;
        bh=+TASiKADxHjFKy0cAGlR9FVBWi06G1UcgDaT1qJtd+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GJNQ9jmeuLR9U0fPWXOZs7S/0k6TYEn2DZsS2eFnGRpYgb7+SsnWCKgb7HmhGEJrH
         q+diqk/HYt5s5CeLCCd6zNSyx//xmsyr/OqAmaVc2Ai29QlvX9qxSHPu9dWfv/V+/S
         GJgxVZeOgcl/4INR16egXbdoYE8chxVOuD4AeRlJ8ligebDWyNg6CqZvIsJ1rxN7iR
         /+w3UYN3TsMZ1/Jb7qlDhOfqGEEjYxDgiWqYDljr9x/d+BmnBZWS4cDsEpEs2aYQr5
         qW0/Q+I+CXO1JrnpUEro1KL9eTJEE3M5iWbRXefK5/cyifchU4DnK1MZlRjfBPJXKD
         CUjzhQ0upYXMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A880F0383A;
        Sat,  5 Mar 2022 05:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: meson-gxl: fix interrupt handling in forced
 mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164645761210.14498.11372584157805822100.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 05:20:12 +0000
References: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
In-Reply-To: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, narmstrong@baylibre.com, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 3 Mar 2022 08:54:15 +0100 you wrote:
> This PHY doesn't support a link-up interrupt source. If aneg is enabled
> we use the "aneg complete" interrupt for this purpose, but if aneg is
> disabled link-up isn't signaled currently.
> According to a vendor driver there's an additional "energy detect"
> interrupt source that can be used to signal link-up if aneg is disabled.
> We can safely ignore this interrupt source if aneg is enabled.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: meson-gxl: fix interrupt handling in forced mode
    https://git.kernel.org/netdev/net/c/a502a8f04097

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


