Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D854F4FE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381639AbiFQKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381629AbiFQKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B406A00A;
        Fri, 17 Jun 2022 03:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BD2BB82962;
        Fri, 17 Jun 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE9C3C341C6;
        Fri, 17 Jun 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655460614;
        bh=52/+SN6B+LFLyhgNHFfrjORprDXjBmbr0acNX3B3atA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DPznx/ogu/fxQ9dBt1h2G0/NTLaABcU3+4J1HY7VsFpLRdTXyJfIXBh+SpvF8HEqh
         zCRdei24qxitcSEgYhCJAtEVWRiJzvSU8L9AnocQ3WJssDhShiTjxjT9TaSB/ZXFfs
         CrX9jw5fnmyrO6ltRKAYvlTWcmJuWtVc2mlWduCUbFu38YZuHekmC09KEiUwJEoQtB
         fgAGoE1aYt2lADkraQAp1J5ZXb8JaRZ4tRVo1Y5iqfQ8f6qMclnu8qS7nPZKQl/7vJ
         0GfwUL+Kt7PVeTZMMJSNxi/2xqHidEaroXZHHRTIzWFdPEg3uVTfIr8BXtKk/3jb2f
         xygf9hBDER/fA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 925EEE56ADF;
        Fri, 17 Jun 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/5] pcs-xpcs,
 stmmac: add 1000BASE-X AN for network switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546061459.1839.10863742646357502516.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:10:14 +0000
References: <20220615083908.1651975-1-boon.leong.ong@intel.com>
In-Reply-To: <20220615083908.1651975-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     alexandre.torgue@foss.st.com, Jose.Abreu@synopsys.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        emilio.riva@ericsson.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 15 Jun 2022 16:39:03 +0800 you wrote:
> Thanks for v4 review feedback in [1] and [2]. I have changed the v5
> implementation as follow.
> 
> v5 changes:
> 1/5 - No change from v4.
> 2/5 - No change from v4.
> 3/5 - [Fix] make xpcs_modify_changed() static and use
>       mdiodev_modify_changed() for cleaner code as suggested by
>       Russell King.
> 4/5 - [Fix] Use fwnode_get_phy_mode() as recommended by Andrew Lunn.
> 5/5 - [Fix] Make fwnode = of_fwnode_handle(priv->plat->phylink_node)
>       order after priv = netdev_priv(dev).
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] net: make xpcs_do_config to accept advertising for pcs-xpcs and sja1105
    https://git.kernel.org/netdev/net-next/c/fa9c562f9735
  - [net-next,v5,2/5] stmmac: intel: prepare to support 1000BASE-X phy interface setting
    https://git.kernel.org/netdev/net-next/c/c82386310d95
  - [net-next,v5,3/5] net: pcs: xpcs: add CL37 1000BASE-X AN support
    https://git.kernel.org/netdev/net-next/c/b47aec885bcd
  - [net-next,v5,4/5] stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support
    https://git.kernel.org/netdev/net-next/c/72edaf39fc65
  - [net-next,v5,5/5] net: stmmac: make mdio register skips PHY scanning for fixed-link
    https://git.kernel.org/netdev/net-next/c/ab21cf920928

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


