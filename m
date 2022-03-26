Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AC4E7B53
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiCZALt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCZALs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:11:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606984CD73;
        Fri, 25 Mar 2022 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09A10B82ACA;
        Sat, 26 Mar 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA61AC340F3;
        Sat, 26 Mar 2022 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648253410;
        bh=dMifaIZteL6gcaEJpTDhGywINlKOISqgvnpZlGOy1qk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbkLWpVTZY9unWRHCYumCj3VTNsDubSA7uOIB3golkKAwegihudt87+34w9Qa0cHm
         +Ggj7CFRUNc9Er93eR8mzi58mAqrSIhoST5s8LqKdp/XJDzQUvRFRlrmyJW+n9rDgB
         r7zvMmb9wTCjLUvFUZl2bPmKcoiNr03Z78+HOYPIAQPV30FMTH/VcuzMSmhpO0ylk5
         sQgJ8yxmc+Ht1y68cit10Aa87/B3eJ7zrDbKwK/mLmY97qaNABO0IpqgrX6/3FOt5X
         lcX6EO2+yoRoN2A2sLQEqr3SgNvmP0+P6i6s86rf34zNTx5QBawx7vPRyL0I4BsKaR
         3CEDAuLi7Vysg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A02A6F03847;
        Sat, 26 Mar 2022 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: phy: broadcom: Fix brcm_fet_config_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164825341065.1855.11064112768732190605.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 00:10:10 +0000
References: <20220324232438.1156812-1-f.fainelli@gmail.com>
In-Reply-To: <20220324232438.1156812-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, mchan@broadcom.com,
        benli@broadcom.com, mcarlson@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 24 Mar 2022 16:24:38 -0700 you wrote:
> A Broadcom AC201 PHY (same entry as 5241) would be flagged by the
> Broadcom UniMAC MDIO controller as not completing the turn around
> properly since the PHY expects 65 MDC clock cycles to complete a write
> cycle, and the MDIO controller was only sending 64 MDC clock cycles as
> determined by looking at a scope shot.
> 
> This would make the subsequent read fail with the UniMAC MDIO controller
> command field having MDIO_READ_FAIL set and we would abort the
> brcm_fet_config_init() function and thus not probe the PHY at all.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: broadcom: Fix brcm_fet_config_init()
    https://git.kernel.org/netdev/net/c/bf8bfc4336f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


