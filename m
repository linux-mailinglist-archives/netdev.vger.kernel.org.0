Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC65845A2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiG1SKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiG1SKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CBB1182A;
        Thu, 28 Jul 2022 11:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABA961DAD;
        Thu, 28 Jul 2022 18:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1C46C433B5;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659031814;
        bh=ppCmYlclJCNj1Oq4JCRie1DNfqM3IDoEheXuO58cvTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLM26ccgbZnNt0CUIvvwJbBC6poS7oR7/G7lozocJNnsWBDxawsTE6oPYLvcekSPN
         ovhwHnCYigojA0lNzHgTrDin14WQ/SByLA2OVU7L2NpfhksLivH7MZNJH2J8xeFsfY
         upCMg0rPvG+0n9X7WTX/mMT9xEfyqLAthPpDj6B+pjyDeG4ARdXrKwLsIMvAkusSjw
         m+TfAmO8YGLPI68SUg9e5Dz+pdwTFTRUpG4dq/+gx+mL3O8uP1QYGhApfb7oEkBcC1
         ze5Hje/u8jYLcuTh3tF+WaMTjKeNCb5lvS6x9mArIv0MifFmqvap/ThP+fuXo8Szs3
         CIOAPxN00q3Qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C93C6C43143;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] stmmac: dwmac-mediatek: fix resource leak in probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165903181382.2291.8863547537135721463.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 18:10:13 +0000
References: <YuJ4aZyMUlG6yGGa@kili>
In-Reply-To: <YuJ4aZyMUlG6yGGa@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peppe.cavallaro@st.com, biao.huang@mediatek.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 14:52:09 +0300 you wrote:
> If mediatek_dwmac_clks_config() fails, then call stmmac_remove_config_dt()
> before returning.  Otherwise it is a resource leak.
> 
> Fixes: fa4b3ca60e80 ("stmmac: dwmac-mediatek: fix clock issue")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] stmmac: dwmac-mediatek: fix resource leak in probe
    https://git.kernel.org/netdev/net/c/4d3d3a1b244f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


