Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9FF66A97F
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjANFua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjANFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8E73AA9;
        Fri, 13 Jan 2023 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E17B82312;
        Sat, 14 Jan 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99D12C433EF;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673675418;
        bh=ngfQjwFKmCSeocAW86AdE9in/ESlzA2f+NOfkGPnaOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PbzAb7FuLH7rstaaHzkqO/TKJ0jhzX5/WVGU1Atan9l2+aId0YIBwQBc6HEWGIdOx
         NpBUiimoP/3W4GeYmgQWkIyK0QxD26i1VH8jDscuPlEWm/rxaumM/fnWM8Us8rXkdc
         xVnwryq7I1nXtFLtPG4iU0vHUeQs6adLDniT54mEpUIdDbaTldpzW/tSZCCv49Latq
         ASQ9j+AGIg2kynwAdJes0zFQh1cxh1mZpE8rDdsFr7ssJaPfEAj30VnTs0y0CgEV7e
         g99L+fsWom9cv4n4jn7ebEEiBWKp8bDx58WvX+T4uizSBRsOOFIll46WgLTttVOLUn
         Um0jMC9DtZRtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75D05E21EE0;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: mdio: Continue separating C22 and C45
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367541847.15756.1816103460556617097.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:50:18 +0000
References: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
In-Reply-To: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, joel@jms.id.au,
        andrew@aj.id.au, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo@kernel.org, matthias.bgg@gmail.com,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        leoyang.li@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, andrew@lunn.ch
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 12 Jan 2023 16:15:07 +0100 you wrote:
> I've picked this older series from Andrew up and rebased it onto
> the latest net-next.
> 
> This is the second patch set in the series which separates the C22
> and C45 MDIO bus transactions at the API level to the MDIO bus drivers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: mdio: cavium: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/93641ecbaa1f
  - [net-next,02/10] net: mdio: i2c: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/87e3bee0f247
  - [net-next,03/10] net: mdio: mux-bcm-iproc: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/d544a25930a7
  - [net-next,04/10] net: mdio: aspeed: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/c3c497eb8b24
  - [net-next,05/10] net: mdio: ipq4019: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/c58e39942adf
  - [net-next,06/10] net: ethernet: mtk_eth_soc: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/900888374e73
  - [net-next,07/10] net: lan743x: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/3d90c03cb416
  - [net-next,08/10] net: stmmac: Separate C22 and C45 transactions for xgmac2
    https://git.kernel.org/netdev/net-next/c/5b0a447efff5
  - [net-next,09/10] net: stmmac: Separate C22 and C45 transactions for xgmac
    https://git.kernel.org/netdev/net-next/c/3c7826d0b106
  - [net-next,10/10] enetc: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/80e87442e69b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


