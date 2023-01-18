Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75113671E2D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjARNlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjARNkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF16BFF73;
        Wed, 18 Jan 2023 05:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87AA8B81CEB;
        Wed, 18 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F4179C433D2;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674047418;
        bh=oYonSHuDZS4OI1phKo81M9gyFbCoy6DvJ3Gg4q/1aJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BcttJZE6TaTO152ngaAMmaU1axuYWO41WtMMzRTIgkas3/Xp/JqwS1TYSxUQEzzYv
         egVZPTmmsJOEnlq7lEmZ+UEdv5D24qhvrH8917O4mr5+T7/wRBNmxSRu1nEC5G+foT
         7U3UFdH+Dhb3cO5XsjQIaGNEWshMfq+2LjMs2xRJE9ThFuiu8dS76o1YgfqCKw7dKS
         rcUKdKDaguKlfEPYgexdcpHjQ5ZgCkLRWffMT/KqGZqCKXqylswowewo0o1hsRHKnJ
         GXmFeXdRuMxxT4VnyLksA5EVginMJ4A5aSYC5L4HJ2AZsuodgnQb65Q9A/TlX6DHtK
         PWVBXbqw6uoMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC771C3959E;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 0/7] Add eqos and fec support for imx93
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404741783.5923.15821433404030533647.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:10:17 +0000
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux-imx@nxp.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 13 Jan 2023 11:33:40 +0800 you wrote:
> Hi,
> 
> This patchset add imx93 support for dwmac-imx glue driver.
> There are some changes of GPR implement.
> And add fec and eqos nodes for imx93 dts.
> 
> Clark Wang (7):
>   net: stmmac: add imx93 platform support
>   dt-bindings: add mx93 description
>   dt-bindings: net: fec: add mx93 description
>   arm64: dts: imx93: add eqos support
>   arm64: dts: imx93: add FEC support
>   arm64: dts: imx93-11x11-evk: enable eqos
>   arm64: dts: imx93-11x11-evk: enable fec function
> 
> [...]

Here is the summary with links:
  - [V2,1/7] net: stmmac: add imx93 platform support
    https://git.kernel.org/netdev/net-next/c/e5bf35ca4547
  - [V2,2/7] dt-bindings: add mx93 description
    https://git.kernel.org/netdev/net-next/c/b2274ffe90be
  - [V2,3/7] dt-bindings: net: fec: add mx93 description
    https://git.kernel.org/netdev/net-next/c/f743e7664dca
  - [V2,4/7] arm64: dts: imx93: add eqos support
    https://git.kernel.org/netdev/net-next/c/1f4263ea6a4b
  - [V2,5/7] arm64: dts: imx93: add FEC support
    https://git.kernel.org/netdev/net-next/c/eaaf47108540
  - [V2,6/7] arm64: dts: imx93-11x11-evk: enable eqos
    https://git.kernel.org/netdev/net-next/c/1b110dd678d9
  - [V2,7/7] arm64: dts: imx93-11x11-evk: enable fec function
    https://git.kernel.org/netdev/net-next/c/c897dc7f3a8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


