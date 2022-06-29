Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71E05600D6
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiF2NAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiF2NAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE8D39802;
        Wed, 29 Jun 2022 06:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015D5B82467;
        Wed, 29 Jun 2022 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7C95C341C8;
        Wed, 29 Jun 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656507615;
        bh=BjjCJBidSRratdezAQtBiILIcrmfwCpGeEbZq1JVhdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KyH21ChHzIBzd83Wp1YnrHhIJ5yZKIoBelCRhli5W144pPzn90RN/nNVtjzcHjHaG
         DVhEK8EzlOGUZHMhBdo1Gdl6QbrqCZWbpGzl5mi7/MudrBaxDScy/njffaw/lJD2Vx
         IrFIhVJSboligl2ahfoRBTVvg05sHcm5PoYWNw89rcmV88vxVtUmYJeTN8diSZa8u9
         MDhmcLyu7AH3krRxh08u+yv2rJBQGBuGyIp4LXdwkbDa8jlFBWCwC9mUmKlJ1BS7B4
         TALD5bnaY8GJyPubQ29lipsQnwiISn3C12Xqb8HA0BRUGMKUVgZEUR8IPA830eQhdv
         tdEo5g520dc1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2216E49BB8;
        Wed, 29 Jun 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next 0/7] net: dsa: microchip: use ksz_chip_reg for
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650761572.14913.16101231079262583190.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 13:00:15 +0000
References: <20220628171329.25503-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220628171329.25503-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Jun 2022 22:43:22 +0530 you wrote:
> This patch series tries to use the same approach as struct ksz8 for
> register which has different address for different switch family. It
> moves the struct ksz8 from ksz8.h to struct ksz_chip_reg. Based on the
> switch detect, the corresponding mask, reg and shifts are assigned.
> 
> Arun Ramadoss (7):
>   net: dsa: microchip: move ksz8->regs to ksz_common
>   net: dsa: microchip: move ksz8->masks to ksz_common
>   net: dsa: microchip: move ksz8->shifts to ksz_common
>   net: dsa: microchip: remove the struct ksz8
>   net: dsa: microchip: change the size of reg from u8 to u16
>   net: dsa: microchip: add P_STP_CTRL to ksz_chip_reg
>   net: dsa: microchip: move remaining register offset to ksz_chip_reg
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: dsa: microchip: move ksz8->regs to ksz_common
    https://git.kernel.org/netdev/net-next/c/486f9ca715d7
  - [net-next,2/7] net: dsa: microchip: move ksz8->masks to ksz_common
    https://git.kernel.org/netdev/net-next/c/d23a5e18606c
  - [net-next,3/7] net: dsa: microchip: move ksz8->shifts to ksz_common
    https://git.kernel.org/netdev/net-next/c/34e48383636f
  - [net-next,4/7] net: dsa: microchip: remove the struct ksz8
    https://git.kernel.org/netdev/net-next/c/47d82864eee1
  - [net-next,5/7] net: dsa: microchip: change the size of reg from u8 to u16
    https://git.kernel.org/netdev/net-next/c/a02579df160e
  - [net-next,6/7] net: dsa: microchip: add P_STP_CTRL to ksz_chip_reg
    https://git.kernel.org/netdev/net-next/c/6877102f95f3
  - [net-next,7/7] net: dsa: microchip: move remaining register offset to ksz_chip_reg
    https://git.kernel.org/netdev/net-next/c/9d95329c65db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


