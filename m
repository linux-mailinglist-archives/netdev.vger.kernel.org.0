Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597CA5A796A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiHaIub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiHaIu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517E9A2D87;
        Wed, 31 Aug 2022 01:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC795B81EE1;
        Wed, 31 Aug 2022 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 655BEC433D7;
        Wed, 31 Aug 2022 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661935819;
        bh=ersuwtsoF+gz4Khk4twXBa8eC4M5FuTrZrU7bbV5xN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dx8SpLvE6OE4COgMxNM10PLOKB6/AsE4LigkheDT4bwqAegrbQvJFlzNb5UM0JpW1
         Vr8WjxDvENv4VYwaJbPGIE/s4jZeJqx+wYRtSd+QjuWf+Pw8IsHOXx18CDF2xdQsBy
         ULMhgowT25aDH/dubDBVH4ZZxswFQuUj4JJoKYZc7ucXS9UsVJN9EZBZtO56cwwv6y
         4OyFIskfbQ/ZjnO9PNLbnHyrG3o+VFqMG4fqXtvHZ65w7UMvTa5oOC1DtANAjRfCgx
         BpBzYntayKluAMAl8pFQis+NdDTKHs5X2OSRzCTyo01meXIgHlnkLpbffcIZxuJVvL
         UsXGDJ+mm85NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42950E924DA;
        Wed, 31 Aug 2022 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/17] net: dsa: microchip: add error handling and
 register access validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166193581926.12108.13290186074515106257.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 08:50:19 +0000
References: <20220826105634.3855578-1-o.rempel@pengutronix.de>
In-Reply-To: <20220826105634.3855578-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Fri, 26 Aug 2022 12:56:17 +0200 you wrote:
> changes v4:
> - add Reviewed-by: Vladimir Oltean <olteanv@gmail.com> to all patches
> - fix checkpatch warnings.
> 
> changes v3:
> - fix build error in the middle of the patch stack.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/17] net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip
    https://git.kernel.org/netdev/net-next/c/b44908095612
  - [net-next,v4,02/17] net: dsa: microchip: do per-port Gbit detection instead of per-chip
    https://git.kernel.org/netdev/net-next/c/505bf3205aaa
  - [net-next,v4,03/17] net: dsa: microchip: don't announce extended register support on non Gbit chips
    https://git.kernel.org/netdev/net-next/c/d7539fc2b41a
  - [net-next,v4,04/17] net: dsa: microchip: allow to pass return values for PHY read/write accesses
    https://git.kernel.org/netdev/net-next/c/8f4204567923
  - [net-next,v4,05/17] net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite functions
    https://git.kernel.org/netdev/net-next/c/d38bc3b4b8a6
  - [net-next,v4,06/17] net: dsa: microchip: ksz9477: add error handling to ksz9477_r/w_phy
    https://git.kernel.org/netdev/net-next/c/9da975e1bbef
  - [net-next,v4,07/17] net: dsa: microchip: ksz8795: add error handling to ksz8_r/w_phy
    https://git.kernel.org/netdev/net-next/c/9590fc4a2af5
  - [net-next,v4,08/17] net: dsa: microchip: KSZ9893: do not write to not supported Output Clock Control Register
    https://git.kernel.org/netdev/net-next/c/b5708dc6539d
  - [net-next,v4,09/17] net: dsa: microchip: add support for regmap_access_tables
    https://git.kernel.org/netdev/net-next/c/ec6ba50c65c1
  - [net-next,v4,10/17] net: dsa: microchip: add regmap_range for KSZ8563 chip
    https://git.kernel.org/netdev/net-next/c/41131bac9a9a
  - [net-next,v4,11/17] net: dsa: microchip: ksz9477: remove MII_CTRL1000 check from ksz9477_w_phy()
    https://git.kernel.org/netdev/net-next/c/5bd3ecd121e3
  - [net-next,v4,12/17] net: dsa: microchip: add regmap_range for KSZ9477 chip
    https://git.kernel.org/netdev/net-next/c/74e792b5f2dd
  - [net-next,v4,13/17] net: dsa: microchip: ksz9477: use internal_phy instead of phy_port_cnt
    https://git.kernel.org/netdev/net-next/c/0a7fbd514edf
  - [net-next,v4,14/17] net: dsa: microchip: remove unused port phy variable
    https://git.kernel.org/netdev/net-next/c/6aaa8e7d2002
  - [net-next,v4,15/17] net: dsa: microchip: ksz9477: remove unused "on" variable
    https://git.kernel.org/netdev/net-next/c/7d39143449ea
  - [net-next,v4,16/17] net: dsa: microchip: remove unused sgmii variable
    https://git.kernel.org/netdev/net-next/c/e7f695210140
  - [net-next,v4,17/17] net: dsa: microchip: remove IS_9893 flag
    https://git.kernel.org/netdev/net-next/c/32cbac21b9f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


