Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357916C2870
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCUDAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCUDAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:00:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798D2F7BF;
        Mon, 20 Mar 2023 20:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18406CE17A9;
        Tue, 21 Mar 2023 03:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7627CC4339B;
        Tue, 21 Mar 2023 03:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679367620;
        bh=tG3nR/BNTPFfBhbWT130BlqQjCEkjCYaupmLUe7Z3KI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmZSXPC0b0Pe5MUZDeqoGnap4EwddUaBK0H6Bruu+VpCVi/QApHbCre8vsOmXOGb5
         YNEeUd++DZ73hql8rXVqB7S10mBPjV8e602/6OykY8OIRMKljxfiNRSopfMyRuQioj
         /cdle9VRRBnt3nCCqSfN/qf0X5owMUw9EnsOAYgmL4yIthCBKfTyz28UQSUQYn/D/R
         HHEuFU49olOKVeGq09Z0WJmcq2kIzh1dCw7hc/HJqJgsFQplAaNq6620K64FN6KkDf
         Ob5sG1eMkW/EgOf175qSBNWj3Jrz5JeTDQUES2UWAuXII6RS/1HvVz7+Cn7PjC8ecI
         dJgKkpmP546RQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 545C9E68C18;
        Tue, 21 Mar 2023 03:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v14 0/9] net: ethernet: mtk_eth_soc: various
 enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167936762033.19471.10695862996613870183.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 03:00:20 +0000
References: <cover.1679230025.git.daniel@makrotopia.org>
In-Reply-To: <cover.1679230025.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, lorenzo@kernel.org,
        Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
        dqfext@gmail.com, Landen.Chao@mediatek.com, sean.wang@mediatek.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vladimir.oltean@nxp.com, bjorn@mork.no,
        frank-w@public-files.de, lynxis@fe80.eu
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Mar 2023 12:56:07 +0000 you wrote:
> This series brings a variety of fixes and enhancements for mtk_eth_soc,
> adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
> code between mtk_eth_soc and mt7530.
> 
> The whole series has been tested on MT7622+MT7531 (BPi-R64),
> MT7623+MT7530 (BPi-R2), MT7981+GPY211 (GL.iNet GL-MT3000) and
> MT7986+MT7531 (BPi-R3). On the BananaPi R3 a variete of SFP modules
> have been tested, all of them (some SGMII with PHY, others 2500Base-X
> or 1000Base-X without PHY) are working well now, however, some of them
> need manually disabling of autonegotiation for the link to come up.
> 
> [...]

Here is the summary with links:
  - [net-next,v14,1/9] net: ethernet: mtk_eth_soc: add support for MT7981 SoC
    https://git.kernel.org/netdev/net-next/c/f5d43ddd334b
  - [net-next,v14,2/9] dt-bindings: net: mediatek,net: add mt7981-eth binding
    https://git.kernel.org/netdev/net-next/c/e3ac1c270466
  - [net-next,v14,3/9] dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
    https://git.kernel.org/netdev/net-next/c/d4f08a703565
  - [net-next,v14,4/9] dt-bindings: net: pcs: mediatek,sgmiisys: add MT7981 SoC
    https://git.kernel.org/netdev/net-next/c/4f7eb19c4f44
  - [net-next,v14,5/9] net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
    https://git.kernel.org/netdev/net-next/c/c0a440031d43
  - [net-next,v14,6/9] net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
    https://git.kernel.org/netdev/net-next/c/3fbe4d8c0e53
  - [net-next,v14,7/9] net: pcs: add driver for MediaTek SGMII PCS
    https://git.kernel.org/netdev/net-next/c/4765a9722e09
  - [net-next,v14,8/9] net: ethernet: mtk_eth_soc: switch to external PCS driver
    https://git.kernel.org/netdev/net-next/c/2a3ec7ae3133
  - [net-next,v14,9/9] net: dsa: mt7530: use external PCS driver
    https://git.kernel.org/netdev/net-next/c/5b89aeae6e00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


