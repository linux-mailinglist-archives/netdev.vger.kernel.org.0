Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24844E6BAE
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357091AbiCYBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiCYBBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:01:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823BABBE18;
        Thu, 24 Mar 2022 18:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3510FB8270A;
        Fri, 25 Mar 2022 01:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4B8DC340EE;
        Fri, 25 Mar 2022 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648170011;
        bh=d5wIT0LEc5NSb6GdheZy9GT6g8BIIfqcfuV9J4NhnkI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jaCMjPx9bND0CXArgbcaExEPjQBupRg9h2aRPxs2Az1yPbBA/5zDhs8FxtibXyvhz
         6EPqBtkz6BPwc/jqpqgnfK4HMWnwtjNiV5PWak7D/75c9IuQRfFUoEa9RQl6MLdNL6
         YdXhTBFmTGQ6/Gf3ERw+aEcLNEQkioBVX8YllIZ1i0RGPfkQ08slYVAdHTLvwz64e7
         gDuY+sa5Tba17THbnH1KVlqnm//N4qLJ4JYBBV8AeXrG+QPXZqPQ9lgy44KpLiMgOv
         R3sZy7ok5S1QbBOeWzZf5EvNvVEOPQQrqjmNZLvruCm1zlmibXYEcHAklI+GTwB7P6
         EjscCWYnSa7PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1D50F0383F;
        Fri, 25 Mar 2022 01:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-qcom-ethqos: Enable RGMII functional clock
 on resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164817001079.21015.15011506494031889384.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 01:00:10 +0000
References: <20220323033255.2282930-1-bjorn.andersson@linaro.org>
In-Reply-To: <20220323033255.2282930-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     vkoul@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.sharma@linaro.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 20:32:55 -0700 you wrote:
> When the Qualcomm ethqos driver is properly described in its associated
> GDSC power-domain, the hardware will be powered down and loose its state
> between qcom_ethqos_probe() and stmmac_init_dma_engine().
> 
> The result of this is that the functional clock from the RGMII IO macro
> is no longer provides and the DMA software reset in dwmac4_dma_reset()
> will time out, due to lacking clock signal.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-qcom-ethqos: Enable RGMII functional clock on resume
    https://git.kernel.org/netdev/net/c/ffba2123e171

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


