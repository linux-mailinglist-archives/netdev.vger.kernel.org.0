Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E61582268
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiG0IuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiG0IuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB53FB02;
        Wed, 27 Jul 2022 01:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 445B461700;
        Wed, 27 Jul 2022 08:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FA58C433D7;
        Wed, 27 Jul 2022 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658911814;
        bh=9JWubULy2o5aQ0yJzC/crkGrFFocSzrXJfV5jsG8sEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E0uumWP7ZdwwMgerf4FivXfFwhR+Oft/B5N8rz+APQmXp2xJhpj8Al93Z/OPdDC3R
         fkfP1z9AThpAOo6n+D6gT/J1ssbyJgp9hroaHVvjUoGMwb/Gg8xVkJ8hr4sPqvMB90
         PVDnb9941jTBBZ6v+x9D5nVZXtVxtcZ8gzAikqF487Njn4oetC17aP6g3yOjM0Qeus
         snKuawj8wyFf+qDQEZDxxRTEc3JQjJH8acR5enSn6FDqITVM5M8uegTcYXKpfuRWe+
         CY61g1juUf+MBu9VDiPjr8wqCMZe3oLxw0Ahn4dBIcidPcHzHzxAugLzyVmzsEPk9C
         ELzlq06v9Xxlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68A92C43143;
        Wed, 27 Jul 2022 08:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for phylink
 mac config and link up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165891181442.26661.18313628308676884768.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 08:50:14 +0000
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Jul 2022 14:58:14 +0530 you wrote:
> This patch series add support common phylink mac config and link up for the ksz
> series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
> mac config and link up. It configures the mac interface in the port setup hook.
> ksz8830 series switch does not mac link configuration. For lan937x switches, in
> the part support patch series has support only for MII and RMII configuration.
> Some group of switches have some register address and bit fields common and
> others are different. So, this patch aims to have common phylink implementation
> which configures the register based on the chip id.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] net: dsa: microchip: add common gigabit set and get function
    https://git.kernel.org/netdev/net-next/c/46f80fa8981b
  - [net-next,v2,2/9] net: dsa: microchip: add common ksz port xmii speed selection function
    https://git.kernel.org/netdev/net-next/c/aa5b8b73d4bd
  - [net-next,v2,3/9] net: dsa: microchip: add common duplex and flow control function
    https://git.kernel.org/netdev/net-next/c/8560664fd32a
  - [net-next,v2,4/9] net: dsa: microchip: add support for common phylink mac link up
    https://git.kernel.org/netdev/net-next/c/da8cd08520f3
  - [net-next,v2,5/9] net: dsa: microchip: lan937x: add support for configuing xMII register
    https://git.kernel.org/netdev/net-next/c/dc1c596edba5
  - [net-next,v2,6/9] net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
    https://git.kernel.org/netdev/net-next/c/b19ac41faa3f
  - [net-next,v2,7/9] net: dsa: microchip: ksz9477: use common xmii function
    https://git.kernel.org/netdev/net-next/c/0ab7f6bf1675
  - [net-next,v2,8/9] net: dsa: microchip: ksz8795: use common xmii function
    https://git.kernel.org/netdev/net-next/c/c476bede4b0f
  - [net-next,v2,9/9] net: dsa: microchip: add support for phylink mac config
    https://git.kernel.org/netdev/net-next/c/f3d890f5f90e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


