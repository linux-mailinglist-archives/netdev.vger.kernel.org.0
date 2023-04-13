Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC46E0C23
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDMLKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjDMLKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683465FD4;
        Thu, 13 Apr 2023 04:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C2060FDC;
        Thu, 13 Apr 2023 11:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 441A6C433EF;
        Thu, 13 Apr 2023 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681384221;
        bh=047FHGu9Eh8p6igVsqOs4jlOjs1RHZPTczyCtqb9f/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YXVm+OHaLTnqBfgcKFP4knXEdr5JTsUgTwsBhgF7TOKENOpQCuekM2c0EA/h+WIO+
         YYGrz9UHaKjWR7pe5/O/f96cTWNM4/jIgCSJe6AqzAhHC2+3WjxmUtAMendPPL1PfL
         ve/zg2SM8urW4HmGiHtPRvG3fv+fVB5FC1ieep42EfYzMrRnl0Yvi4I2jGws4XRNqi
         MxfNbnB0tK0lkuJxFAQhgUdQj/m7ceHdXldw/uNJtR7fL6AUlvUyR1uloPdcBGmsNa
         W2EtSA541g5l3/e6j5d9kV9KsKtz6mixNhqv+GtKD0dNCL3yXlxupt1uysCy8iyp6a
         FndSwIFFyplDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C284E52443;
        Thu, 13 Apr 2023 11:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/12] Add EMAC3 support for sa8540p-ride
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168138422111.3376.5659809856940118374.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 11:10:21 +0000
References: <20230411200409.455355-1-ahalaney@redhat.com>
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 11 Apr 2023 15:03:57 -0500 you wrote:
> This is a forward port / upstream refactor of code delivered
> downstream by Qualcomm over at [0] to enable the DWMAC5 based
> implementation called EMAC3 on the sa8540p-ride dev board.
> 
> From what I can tell with the board schematic in hand,
> as well as the code delivered, the main changes needed are:
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/12] dt-bindings: net: snps,dwmac: Update interrupt-names
    https://git.kernel.org/netdev/net-next/c/d554ba0ea03c
  - [net-next,v4,02/12] dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
    https://git.kernel.org/netdev/net-next/c/d70c215bdd17
  - [net-next,v4,03/12] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
    https://git.kernel.org/netdev/net-next/c/02e98ce3db14
  - [net-next,v4,04/12] dt-bindings: net: qcom,ethqos: Add Qualcomm sc8280xp compatibles
    https://git.kernel.org/netdev/net-next/c/25926a703ec1
  - [net-next,v4,05/12] net: stmmac: Remove unnecessary if statement brackets
    https://git.kernel.org/netdev/net-next/c/7c6b942b81ca
  - [net-next,v4,06/12] net: stmmac: Fix DMA typo
    https://git.kernel.org/netdev/net-next/c/d638dcb52b09
  - [net-next,v4,07/12] net: stmmac: Remove some unnecessary void pointers
    https://git.kernel.org/netdev/net-next/c/0c3f3c4f4b15
  - [net-next,v4,08/12] net: stmmac: Pass stmmac_priv in some callbacks
    https://git.kernel.org/netdev/net-next/c/1d84b487bc2d
  - [net-next,v4,09/12] net: stmmac: dwmac4: Allow platforms to specify some DMA/MTL offsets
    https://git.kernel.org/netdev/net-next/c/33719b57f52e
  - [net-next,v4,10/12] net: stmmac: dwmac-qcom-ethqos: Respect phy-mode and TX delay
    https://git.kernel.org/netdev/net-next/c/164a9ebe9742
  - [net-next,v4,11/12] net: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
    https://git.kernel.org/netdev/net-next/c/030f1d5972aa
  - [net-next,v4,12/12] net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support
    https://git.kernel.org/netdev/net-next/c/b68376191c69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


