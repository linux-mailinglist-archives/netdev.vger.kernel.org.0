Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765AF604693
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbiJSNPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiJSNPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D46E1D377A;
        Wed, 19 Oct 2022 06:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CD5F6188A;
        Wed, 19 Oct 2022 13:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A61A8C433D7;
        Wed, 19 Oct 2022 13:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666184424;
        bh=sYs7tDX+/LNkMgLYx2SFrU5ZqAAiUe1u6NpBIZxmgrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=poOYIUimxoKAmJAgsBUrhpiP/NzlVYYeRGDTPK8ggZsj9LRNGNiCuJlYFPvxO8/fC
         Mg6hsYEg+iXKWZwmm8j90hzjODWS++oZUF0/8/XmwPtiZgLPrXmVQo2/N9s2loPjud
         grxDChulJlWlsxShboOFNdt2XTZTt3DAgXb0yO7rtWyAJZtHDJH4p+KscfmDkLpIZ2
         3guHtdRtSf1R/BTWVaBGr9kx88OZJRXB4HUOWDyh35JuDgfxQ/UgP91jFEgfI4t8hw
         UVxtW129jgWDc7ouMXLK4rz5NIUJLJtBlden3kMpI114g1B7Al2BpsfDdBCkuCiIiU
         bPC0Nef4202MA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F425E29F37;
        Wed, 19 Oct 2022 13:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 00/10] net: dpaa: Convert to phylink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618442458.15395.17847684706172912226.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 13:00:24 +0000
References: <20221017202241.1741671-1-sean.anderson@seco.com>
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        camelia.groza@nxp.com, netdev@vger.kernel.org, edumazet@google.com,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, benh@kernel.crashing.org,
        ioana.ciornei@nxp.com, krzysztof.kozlowski+dt@linaro.org,
        leoyang.li@nxp.com, mpe@ellerman.id.au, paulus@samba.org,
        robh+dt@kernel.org, shawnguo@kernel.org, devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 17 Oct 2022 16:22:31 -0400 you wrote:
> This series converts the DPAA driver to phylink.
> 
> I have tried to maintain backwards compatibility with existing device
> trees whereever possible. However, one area where I was unable to
> achieve this was with QSGMII. Please refer to patch 2 for details.
> 
> All mac drivers have now been converted. I would greatly appreciate if
> anyone has T-series or P-series boards they can test/debug this series
> on. I only have an LS1046ARDB. Everything but QSGMII should work without
> breakage; QSGMII needs patches 7 and 8. For this reason, the last 4
> patches in this series should be applied together (and should not go
> through separate trees).
> 
> [...]

Here is the summary with links:
  - [net-next,v7,01/10] dt-bindings: net: Expand pcs-handle to an array
    https://git.kernel.org/netdev/net-next/c/76025ee53b7d
  - [net-next,v7,02/10] dt-bindings: net: Add Lynx PCS binding
    https://git.kernel.org/netdev/net-next/c/00af103d06b3
  - [net-next,v7,03/10] dt-bindings: net: fman: Add additional interface properties
    https://git.kernel.org/netdev/net-next/c/045d05018a2d
  - [net-next,v7,04/10] net: phylink: provide phylink_validate_mask_caps() helper
    (no matching commit)
  - [net-next,v7,05/10] net: fman: memac: Add serdes support
    https://git.kernel.org/netdev/net-next/c/0fc83bd79589
  - [net-next,v7,06/10] net: fman: memac: Use lynx pcs driver
    https://git.kernel.org/netdev/net-next/c/a7c2a32e7f22
  - [net-next,v7,07/10] net: dpaa: Convert to phylink
    (no matching commit)
  - [net-next,v7,08/10] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
    https://git.kernel.org/netdev/net-next/c/36926a7d70c2
  - [net-next,v7,09/10] powerpc: dts: qoriq: Add nodes for QSGMII PCSs
    https://git.kernel.org/netdev/net-next/c/4e31b808fad1
  - [net-next,v7,10/10] arm64: dts: layerscape: Add nodes for QSGMII PCSs
    https://git.kernel.org/netdev/net-next/c/4e748b1bd7c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


