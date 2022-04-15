Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B75027D0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352007AbiDOKDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352066AbiDOKCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E329AAAB56;
        Fri, 15 Apr 2022 03:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ECD062201;
        Fri, 15 Apr 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7A57C385A8;
        Fri, 15 Apr 2022 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650016811;
        bh=CDk4q1xKExpAlT2WGfJQ10vodrCVHgZYkhwHkVy3ZxQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f5f7kGOs47lFudJo9RQl7n2MMbuJkvYlyR8x7wqwqaVquelAJztJBmazMwv0tcQ1X
         nNpv51VkzFiM32QoYJoRyeInfTDJgZGgbhhyS5nKv0ZsHOGHhVs1p9iyyulBETqekv
         B7ffeJVQKXeU7V3MIAWtnUIPG0TjoLI5b7HLTKRhcL0OIuKdFE8x80bGHvjNwmYJOu
         iWvpQQql72A/C9PeCwUrRTL9FjB8F+8XBDKtvqt25Pj1FTJYKodY9b/d4Ej+GQU1Ig
         m3g1zKu6zN28BVRQrydlw3OZHO0S0Se4uGJBZEYvPrhBNWjZ+r1GBiK/C+5gkq4voh
         nKFFo6hIpemmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC5ABEAC096;
        Fri, 15 Apr 2022 10:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001681176.2816.12195717687887060765.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:00:11 +0000
References: <20220413071409.13530-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220413071409.13530-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        prasanna.vengateshan@microchip.com, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux@armlinux.org.uk,
        hkallweit1@gmail.com, andrew@lunn.ch
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 12:44:09 +0530 you wrote:
> Added the phy_poll_cable_test flag for the lan937x phy driver.
> Tested using command -  ethtool --cable-test <dev>
> 
> Fixes: 680baca546f2 ("net: phy: added the LAN937x phy support")
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag
    https://git.kernel.org/netdev/net/c/6f06aa6b2fd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


