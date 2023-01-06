Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1355865FADE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjAFFKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjAFFKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F95D65AEC;
        Thu,  5 Jan 2023 21:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1123F61D0D;
        Fri,  6 Jan 2023 05:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E1F9C433EF;
        Fri,  6 Jan 2023 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672981816;
        bh=5SLoqxM/8upTu0w4AyoWnpKjNoUu4gj9nG++Tz+f48g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WkcdSDlv3cLPTHUn8hCekQS0cPZyNmvxVks3RChvCugsSKvLcPllm3ckGRILoDMKP
         lW8ikITsVQKpgMNgzKFzHOPEpyvse0l836SvKC4agzBUr79YdjmTEnxYdtYMnHUqHf
         yOe9wY7wJjXrxCpc8vEpq+nkvcHvT+kRfuLblCTdEAJ+iRBQAaus6wK/pZu3TGdpvb
         a5sOxuv9iQWNDBDOIwfZvvJsl3zdlO+7/NoajYUJ7PhWou9j5S4ztK8ERtDJWXE0/c
         p+5odje49vnEmVi2tO4fl1s6hQEGSTF7wUxHS+c889mcy9b7D505o+1kDhtGt3/Pb1
         csVLtzc+MIRHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4324CE5724D;
        Fri,  6 Jan 2023 05:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 0/2] arm64: dts: mt8195: Add Ethernet controller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167298181626.11078.11919389168312167543.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 05:10:16 +0000
References: <20230105010712.10116-1-biao.huang@mediatek.com>
In-Reply-To: <20230105010712.10116-1-biao.huang@mediatek.com>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     andrew@lunn.ch, angelogioacchino.delregno@collabora.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        macpaul.lin@mediatek.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 Jan 2023 09:07:10 +0800 you wrote:
> Changes in v8:
> 1. add reviewed-by as Andrew's comments.
> 
> Changes in v7:
> 1. move mdio node to .dtsi, and remove the compatible
> property in ethernet-phy node as Andrew's comments.
> 2. add netdev@ to cc list as Jakub's reminder.
> 
> [...]

Here is the summary with links:
  - [v8,1/2] stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed
    https://git.kernel.org/netdev/net/c/c26de7507d1f
  - [v8,2/2] arm64: dts: mt8195: Add Ethernet controller
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


