Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87A759BFFB
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiHVNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiHVNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436633E29;
        Mon, 22 Aug 2022 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0931561160;
        Mon, 22 Aug 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 587AAC43142;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661173218;
        bh=ZQf+RtRzflIsW4ByUNtjm6Aenxs0mbiyzzAYeGeMBzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0icUhz1vSvexEOqJL06kF5UwY1i6l8AbDdIl1zwwX+8mTc3w0rxgL+bNDpQnTYyu
         VZUFY6KRWwW/BOaGx3Mb/V69aum+uBO6cTFAzh+JrLcD9sfrF0JbeiObTmNX3ua517
         U+Ku+IPk134LO78QwRlI19P8s8vW+l50/y2lRNZdJgiWSTBoEJO51CHWSJ79nwxy4z
         086Jbq6dy9SDmko47Px9EJPr9TLlH4LtgfXILYpa1urD1iLnBPd8/oVcmgmTTH5Dl9
         uZ0gwM1LXY3C8JMwxw/5IA9YzQV3AQ+uTA+hUEijXhphVgQ1hjwWdzp9TaP6AXQ7+N
         kALZzLHP4kXww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33D18E2A040;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND v4 0/4] net: Introduce QUSGMII phy mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117321820.20649.2102719943200043855.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 13:00:18 +0000
References: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, richardcochran@gmail.com,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 14:32:51 +0200 you wrote:
> Hello everyone,
> 
> Re-sending, since the previous v4 was sent while net-next was closed.
> 
> This is a resend of the V4 of a previous series [1] initially aimed at
> introducing inband extensions, with modes like QUSGMII. This mode allows
> passing info in the ethernet preamble between the MAC and the PHY, such as
> timestamps.
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND,v4,1/4] net: phy: Introduce QUSGMII PHY mode
    https://git.kernel.org/netdev/net-next/c/5e61fe157a27
  - [net-next,RESEND,v4,2/4] dt-bindings: net: ethernet-controller: add QUSGMII mode
    https://git.kernel.org/netdev/net-next/c/0932b12a7496
  - [net-next,RESEND,v4,3/4] net: phy: Add helper to derive the number of ports from a phy mode
    https://git.kernel.org/netdev/net-next/c/c04ade27cb7b
  - [net-next,RESEND,v4,4/4] net: lan966x: Add QUSGMII support for lan966x
    https://git.kernel.org/netdev/net-next/c/ac0167fb9961

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


