Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E355EB19E
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiIZTud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIZTu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C610C1CFCB;
        Mon, 26 Sep 2022 12:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF0E4B80E8C;
        Mon, 26 Sep 2022 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8598AC43140;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221817;
        bh=AwcR63XesDJXxmuYJ7DUwQ4r7WkNFfQBpqjqnZWbvp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9pZOzTGitTO4Oz8x447q0LakU0b8rwP2HKBzu/6Q6Zwum0SG0hnle2JOFaADx8d4
         u15AW85jY1TT/xd8tCq0xYx5YS3LDM2B8qW6OIaSmVsRfDjMtBjvgmuUCMOQ8l9E0Q
         DCr8I2EuKzshcBqEZP6QBW0IBcXPleDHe0hZG2FNmSBXcCMKgBE+kFCd3GvssPplfn
         pClFddvypIVTm2SVcVgZQrJz0ZQPHCBKB2/iIc3RD0GlJt6oeGAXzkB2CLC9o5LXts
         q4mUR0HAhiEDNTF6nxBgiCRrJjc+ioRWQxpKgb89bKuLHehJ1na06AKbYolVzuT2rU
         G5C2UshPlWcxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64106E21EC4;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v4 0/6] net: dsa: microchip: ksz9477: enable
 interrupt for internal phy link detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422181740.25918.3413622159326879450.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:50:17 +0000
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220922071028.18012-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, prasanna.vengateshan@microchip.com,
        hkallweit1@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 12:40:22 +0530 you wrote:
> This patch series implements the common interrupt handling for ksz9477 based
> switches and lan937x. The ksz9477 and lan937x has similar interrupt registers
> except ksz9477 has 4 port based interrupts whereas lan937x has 6 interrupts.
> The patch moves the phy interrupt hanler implemented in lan937x_main.c to
> ksz_common.c, along with the mdio_register functionality.
> 
> v3 -> v4
> - Rebased the code to latest net-next
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] net: dsa: microchip: determine number of port irq based on switch type
    https://git.kernel.org/netdev/net-next/c/978f1f72460c
  - [net-next,v4,2/6] net: dsa: microchip: enable phy interrupts only if interrupt enabled in dts
    https://git.kernel.org/netdev/net-next/c/abc1cb8cbd73
  - [net-next,v4,3/6] net: dsa: microchip: lan937x: return zero if mdio node not present
    https://git.kernel.org/netdev/net-next/c/68ccceaef0b4
  - [net-next,v4,4/6] net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common
    https://git.kernel.org/netdev/net-next/c/ff319a644829
  - [net-next,v4,5/6] net: dsa: microchip: use common irq routines for girq and pirq
    https://git.kernel.org/netdev/net-next/c/e1add7dd6183
  - [net-next,v4,6/6] net: phy: micrel: enable interrupt for ksz9477 phy
    https://git.kernel.org/netdev/net-next/c/db45c76bada3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


