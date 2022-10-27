Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB28760F9EC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiJ0OAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiJ0OAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDFA3B73F;
        Thu, 27 Oct 2022 07:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A2BB824BC;
        Thu, 27 Oct 2022 14:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2A3CC433D6;
        Thu, 27 Oct 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666879215;
        bh=m9k5foEkYTXUvgaAvo/wWIrZ8Y9uKAaltx4As18dVZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lkwd44BDZjSNLoEPhjKknsnSX/vBR5QwP8+oCIS93D1nV6b19/swepL3KPWfxrRt+
         iGWPcAFG+gqJ49WpilEev7XKERigM7LAzKGoSfPOo4ZW3dz9C1P0J6RXhxIMRp0vMn
         2qKs02xLKbamAf63E/e6u3EIu4vpn9+GhK0x/uvqMHDzMIPUBH881gFItvBk5IJCzI
         ZTmJ2UIJigCmBtBd815aZzR5DXCq8uLTf9TU+dfoVVkCAxOzUPnqnveDbPLSkoBBoR
         KTyGDhKqOD1dY/UIvhDO7H3JaJPGffprGbK3QXykzf/1Hs4Yd0gdichpRhwZevWeyT
         zw/Mmh8/7x5AA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D2D7E270D8;
        Thu, 27 Oct 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmsysport: Indicate MAC is in charge of PHY PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166687921556.3700.8570173273582346359.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 14:00:15 +0000
References: <20221025234201.2549360-1-f.fainelli@gmail.com>
In-Reply-To: <20221025234201.2549360-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 16:42:01 -0700 you wrote:
> Avoid the PHY library call unnecessarily into the suspend/resume
> functions by setting phydev->mac_managed_pm to true. The SYSTEMPORT
> driver essentially does exactly what mdio_bus_phy_resume() does by
> calling phy_resume().
> 
> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmsysport: Indicate MAC is in charge of PHY PM
    https://git.kernel.org/netdev/net/c/9f172134dde7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


