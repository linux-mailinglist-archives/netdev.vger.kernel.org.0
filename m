Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFA6B3760
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCJHal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCJHaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7167DED680
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3F5B821D7
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7679C433AC;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=ICBJ/iwk7eUayR2mplWzupMbkXhWGzYOjOjrnZ3VpeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gxNNu2OG/UUsHUhYjiSOxeeyq6bioFvE1gjcyGUWwqOqjLwsXQD3fo6dGEIMWSU4M
         vdIrrShP4VRCyGv4Y7bKvlGi+PUexrmktfcu/FFj+fH4jfp1Tm+IszCz8dY9306lqC
         KexLWFNpC7FWu7LHcEn1GYVZJ3AtBCY/SBS6njFlSHvIiNfZafD5ZtDO4QP1rj8Npp
         iVu8YfzAyE/BdMzwDqPjvEBuJSeQlVLS1PeIfdhDm0LUC7QoZGZYVicgvItzYK8Q9y
         jAokOlG92ep6CV1xs9VY8wFfoV89TGLTQGgDbuk/4EsAkc74iWnn5ZO+m+uDxgt2T8
         pnyqlOBhto6yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B0B3E49F63;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: smsc: use phy_set_bits in
 smsc_phy_config_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341956.20837.5862262734850925913.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <b64d9f86-d029-b911-bbe9-6ca6889399d7@gmail.com>
In-Reply-To: <b64d9f86-d029-b911-bbe9-6ca6889399d7@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Mar 2023 21:19:55 +0100 you wrote:
> Simplify the code by using phy_set_bits().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: smsc: use phy_set_bits in smsc_phy_config_init
    https://git.kernel.org/netdev/net-next/c/513bdd947388

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


