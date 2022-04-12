Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C184FDE48
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346876AbiDLLaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355506AbiDLL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94884EDD7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCC760B60
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4B4DC385A6;
        Tue, 12 Apr 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649758213;
        bh=awEmwceAHMTLgt++0w0XhcTYw0uJdVpEoFT4/OGcWQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TSiTHX7SCa8uLekV+0ttDc29QQHz1LE7THUnhnOSsY5Y8R1DEJuS2Wb54rw4tjdrX
         GRyxc11+pUQ3N5Yjx21JWDmBrhmBUWh5DegGV4rJy9PXfZG8A5Cx9wZLmvc4T+eR1Y
         egfMvA5GoLCne/PGMdOGgKi6bogcEeWZM5JtlI87WRqhBej5brXhszYTwd6jUuEkg6
         fsLjflGG/G7yeLMzIXRuXqKII1MoNinRTX/PnV2HT7HgCAquTP/OypPJabb2QNt89n
         OsAUORhhfago/aIHsBMht9jBvtTaDENzl7zw9qLN8zr9zrW/A9xdtrrZqRbE/2meJY
         8kjawORzVeRtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 831F4E85D15;
        Tue, 12 Apr 2022 10:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] net: dsa: mt7530: updates for phylink changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164975821353.21132.17881540288519221118.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 10:10:13 +0000
References: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
In-Reply-To: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     Landen.Chao@mediatek.com, dqfext@gmail.com, sean.wang@mediatek.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kabel@kernel.org, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 10:45:32 +0100 you wrote:
> Hi,
> 
> This revised series is a partial conversion of the mt7530 DSA driver to
> the modern phylink infrastructure. This driver has some exceptional
> cases which prevent - at the moment - its full conversion (particularly
> with the Autoneg bit) to using phylink_generic_validate().
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] net: dsa: mt7530: 1G can also support 1000BASE-X link mode
    https://git.kernel.org/netdev/net-next/c/66f862563ed6
  - [net-next,v2,2/9] net: dsa: mt7530: populate supported_interfaces and mac_capabilities
    https://git.kernel.org/netdev/net-next/c/59c2215f3604
  - [net-next,v2,3/9] net: dsa: mt7530: remove interface checks
    https://git.kernel.org/netdev/net-next/c/26f6d8810282
  - [net-next,v2,4/9] net: dsa: mt7530: drop use of phylink_helper_basex_speed()
    https://git.kernel.org/netdev/net-next/c/fd301137e6b3
  - [net-next,v2,5/9] net: dsa: mt7530: only indicate linkmodes that can be supported
    https://git.kernel.org/netdev/net-next/c/7c04c8489115
  - [net-next,v2,6/9] net: dsa: mt7530: switch to use phylink_get_linkmodes()
    https://git.kernel.org/netdev/net-next/c/6789d6d76e81
  - [net-next,v2,7/9] net: dsa: mt7530: partially convert to phylink_pcs
    https://git.kernel.org/netdev/net-next/c/cbd1f243bc41
  - [net-next,v2,8/9] net: dsa: mt7530: move autoneg handling to PCS validation
    https://git.kernel.org/netdev/net-next/c/9d0df207c002
  - [net-next,v2,9/9] net: dsa: mt7530: mark as non-legacy
    https://git.kernel.org/netdev/net-next/c/7b972512ec0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


