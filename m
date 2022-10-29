Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1C61204A
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJ2FAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJ2FAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7FA5DF35
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 22:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B099860B32
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 05:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 115BBC433C1;
        Sat, 29 Oct 2022 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019620;
        bh=YgTaMHcT6qxuBEtL4RXvhCR7fZKLClpgXz88Amhb8CM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SjY1liqTea0rnxiqWfbm+YMCRIZ3rm+C5Ssug2Fdw6q3roGUy7SPcRrMwWXTQEojd
         KfOtn12je5+rk8OnykmmPEXsyj7vAqfrV1D0KnKnsuA03drzS1hgIC7Syd05D3FymO
         o5EkcsoQk6yrO/lK/zZwVYKCWHua4Bxl3Ms2+FFAudQtnd1xL+rTsxXlKT0+qDz9pe
         sU9vYL+tzci0bkOltpL1R6NlIJ3hNO+zAtPcLjoAUY1LAsVIq1hoopUeW47HfXpyuC
         5FLFXKeJGo6ZG+8R2v5WdUXFU1USxBu3V88UYC+8IkIl54nD5372ToeTgEM3wDsINI
         7v01ap/Vdj0nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F346DC4166D;
        Sat, 29 Oct 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: mtk_eth_soc: improve PCS implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701961999.17481.10898142814821409044.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 05:00:19 +0000
References: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
In-Reply-To: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, frank-w@public-files.de,
        edumazet@google.com, nbd@nbd.name, john@phrozen.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        sean.wang@mediatek.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 14:10:11 +0100 you wrote:
> Hi,
> 
> As a result of invesigations from Frank Wunderlich, we know a lot more
> about the Mediatek "SGMII" PCS block, and can implement the PCS support
> correctly. This series achieves that, and Frank has tested the final
> result and reports that it works for him. The series could do with
> further testing by others, but I suspect that is unlikely to happen
> until it is merged based on past performances with this driver.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: phylink: add phylink_get_link_timer_ns() helper
    https://git.kernel.org/netdev/net-next/c/9c5a170677c3
  - [net-next,02/11] net: mtk_eth_soc: add definitions for PCS
    https://git.kernel.org/netdev/net-next/c/b6a709cb51f7
  - [net-next,03/11] net: mtk_eth_soc: eliminate unnecessary error handling
    https://git.kernel.org/netdev/net-next/c/5cf7797526ee
  - [net-next,04/11] net: mtk_eth_soc: add pcs_get_state() implementation
    https://git.kernel.org/netdev/net-next/c/c000dca09800
  - [net-next,05/11] net: mtk_eth_soc: convert mtk_sgmii to use regmap_update_bits()
    https://git.kernel.org/netdev/net-next/c/0d2351dc2768
  - [net-next,06/11] net: mtk_eth_soc: add out of band forcing of speed and duplex in pcs_link_up
    https://git.kernel.org/netdev/net-next/c/12198c3a410f
  - [net-next,07/11] net: mtk_eth_soc: move PHY power up
    https://git.kernel.org/netdev/net-next/c/6f38fffe2179
  - [net-next,08/11] net: mtk_eth_soc: move interface speed selection
    https://git.kernel.org/netdev/net-next/c/f752c0df13df
  - [net-next,09/11] net: mtk_eth_soc: add advertisement programming
    https://git.kernel.org/netdev/net-next/c/c125c66ea71b
  - [net-next,10/11] net: mtk_eth_soc: move and correct link timer programming
    https://git.kernel.org/netdev/net-next/c/3027d89f8770
  - [net-next,11/11] net: mtk_eth_soc: add support for in-band 802.3z negotiation
    https://git.kernel.org/netdev/net-next/c/81b0f12a2a8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


