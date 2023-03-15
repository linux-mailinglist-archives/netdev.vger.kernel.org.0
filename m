Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F956BAA75
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCOIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCOIKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A086E19E;
        Wed, 15 Mar 2023 01:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09B861BF2;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E9C3C4339B;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678867819;
        bh=ZE2gJf7Qtp/BclkfKMNO0Nz/2FFS6nF65CxjhGzA0lk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oEhuoY4dsHwguwEasSGvsUGE3AdU0BzzmnpkMrfugSCqUS+0PmuUwkc3ih8RucQTF
         vlgBlbCFbLf512X4OSYNd075122RWW78kQaO6RvdeS/QHlSlcPl8OAIaapHh7GVUv/
         dYng2yo1R5dhMYQFWc1WgQviwUTu36ZzFW7L5yS7tR6xy3BpHmit5blGOOm0qnmFRq
         mPFrhmHAgouEa67cZc9Sksc6viZY6jS2TCeiDtBMGH6CWCXk7dc4OxhPibgNo9tI/Q
         iPEgcgjwpjrC7EJUF6Ywrf4WNmPnxB7myrp5mhOM1JvaZZFg+rhGfHrZ6fGkJiyEzy
         cptUpogxSeSuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAEF0E66CBC;
        Wed, 15 Mar 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/5] net: stmmac: qcom: drop of_match_ptr for ID table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886781895.24118.12865753856982903717.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:10:18 +0000
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bh74.an@samsung.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Mar 2023 22:46:28 +0100 you wrote:
> The driver is specific to ARCH_QCOM which depends on OF thus the driver
> is OF-only.  Its of_device_id table is built unconditionally, thus
> of_match_ptr() for ID table does not make sense.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [1/5] net: stmmac: qcom: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/dc54e450a5dd
  - [2/5] net: stmmac: generic: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/e6512465838b
  - [3/5] net: marvell: pxa168_eth: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/69df36d524db
  - [4/5] net: samsung: sxgbe: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/7f319fe4363c
  - [5/5] net: ni: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/7e9aa8cad084

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


