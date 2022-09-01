Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BF95A93ED
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiIAKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiIAKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCA921E01;
        Thu,  1 Sep 2022 03:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D9EB82571;
        Thu,  1 Sep 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAD84C433D7;
        Thu,  1 Sep 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662027016;
        bh=lyF1AoH2SuCW/n4u3M3W/4DQEDCWpqmu0ejVEWc3mWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RQaJ9mAMUCQCnSAqlo01M8svyC52PJxO+MdtWEiq8Cz9HTmknozU7XBpGsEt+Qn3H
         vlmWBZpKtOCcVXOXHP+w7t5ajH5oiT2yTx5a/EFKpCmBKJQ1HEr4qOUXskiXtnKsnZ
         HN00YOeICVel5pvKv4NO0hxcZsvxo+zPF7YRg+nmfbUzlizNBuqEeDYne65/qpLizT
         2anOYEvAfMwlcTB0ah01aNALg23UOEgPuPpmZT3Fr8O/57luQXN1UkEb3+CVTNymeq
         HiF/R+digNe6EQ414Mi0GzT87y2d7ZvI++LohOd+Nrw95O0OlGBeBDou4gsoKnRHbE
         vl5zMJU9SKE2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 914C3E924D9;
        Thu,  1 Sep 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 0/2] RK3588 Ethernet Support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166202701658.6021.5345078422266376617.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 10:10:16 +0000
References: <20220830154559.61506-1-sebastian.reichel@collabora.com>
In-Reply-To: <20220830154559.61506-1-sebastian.reichel@collabora.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel@collabora.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 Aug 2022 17:45:57 +0200 you wrote:
> This adds ethernet support for the RK3588(s) SoCs.
> 
> Changes since PATCHv2:
>  * Rebased to v6.0-rc1
>  * Wrap DT bindings additions at 80 characters
>  * Add Acked-by from Krzysztof
> 
> [...]

Here is the summary with links:
  - [PATCHv3,1/2] net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588
    https://git.kernel.org/netdev/net-next/c/2f2b60a0ec28
  - [PATCHv3,2/2] dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible
    https://git.kernel.org/netdev/net-next/c/a2b77831427c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


