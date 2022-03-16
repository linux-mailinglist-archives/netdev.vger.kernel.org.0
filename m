Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90824DB13C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 14:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356324AbiCPNWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 09:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356335AbiCPNWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 09:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8C674CF;
        Wed, 16 Mar 2022 06:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECE3EB81B35;
        Wed, 16 Mar 2022 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84EA1C340F0;
        Wed, 16 Mar 2022 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647436812;
        bh=tbcOFjyGFmBEwOjIh+3jseYE1fvFZySauTJiPWeHSxQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gum5FAn1JMTLcenLuYd4xxPKwYN/TcLuars1ooFUTgakM/hpQeodftoHNBLqYRDP/
         r4x9h0/sJC5MHmJInTBtUpjs0iMHG/moQHxyv4RbEYnucVidanSQVkSn++BT611/Bu
         okPYd0KVL3soFDhwrHGgC6kaojRznvmTqVssOsdSqV6UTMBShUJYpUpVQqbGrQtGZb
         UHfpJQmYMkjp3P4Yt7XCoB/ts5RbLgVRXn5tKFeAmfY/H386ao84G/HtZ3/+NOzNJK
         luKf7p7YOdtAIjhjvnvWzJ2/KDDhciOQeJobgB8IOcyaRWR+eJMzR8EuyjnwChMFI8
         g46+zgsaItBUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60947EAC09C;
        Wed, 16 Mar 2022 13:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v13 0/7] MediaTek Ethernet Patches on MT8195
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164743681238.18574.8037993673780755676.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 13:20:12 +0000
References: <20220314075713.29140-1-biao.huang@mediatek.com>
In-Reply-To: <20220314075713.29140-1-biao.huang@mediatek.com>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        dkirjanov@suse.de
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Mar 2022 15:57:06 +0800 you wrote:
> Changes in v13:
> 1. add reviewed-by in "net: dt-bindings: dwmac: add support for mt8195"
>    as Rob's comments.
> 2. drop num_clks defined in mediatek_dwmac_plat_data struct in "stmmac:
>    dwmac-mediatek: Reuse more common features" as Angelo's comments.
> 
> Changes in v12:
> 1. add a new patch "stmmac: dwmac-mediatek: re-arrange clock setting" to
>    this series, to simplify clock handling in driver, which benefits to
>    binding file mediatek-dwmac.yaml.
> 2. modify dt-binding description in patch "net: dt-bindings: dwmac: add
>    support for mt8195" as Rob's comments in v10 series, put mac_cg to the
>    end of clock list.
> 3. there are small changes in patch "stmmac: dwmac-mediatek: add support
>    for mt8195", @AngeloGioacchino, please review it kindly.
> 
> [...]

Here is the summary with links:
  - [net-next,v13,1/7] stmmac: dwmac-mediatek: add platform level clocks management
    https://git.kernel.org/netdev/net-next/c/3186bdad97d5
  - [net-next,v13,2/7] stmmac: dwmac-mediatek: Reuse more common features
    https://git.kernel.org/netdev/net-next/c/a71e67b21081
  - [net-next,v13,3/7] stmmac: dwmac-mediatek: re-arrange clock setting
    https://git.kernel.org/netdev/net-next/c/4fe3075fa699
  - [net-next,v13,4/7] arm64: dts: mt2712: update ethernet device node
    https://git.kernel.org/netdev/net-next/c/79e1177809f2
  - [net-next,v13,5/7] net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
    https://git.kernel.org/netdev/net-next/c/150b6adda6b1
  - [net-next,v13,6/7] stmmac: dwmac-mediatek: add support for mt8195
    https://git.kernel.org/netdev/net-next/c/f2d356a6ab71
  - [net-next,v13,7/7] net: dt-bindings: dwmac: add support for mt8195
    https://git.kernel.org/netdev/net-next/c/ee410d510032

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


