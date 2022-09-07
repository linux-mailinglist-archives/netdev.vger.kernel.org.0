Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3323C5B06A0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiIGOaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 10:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiIGOa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 10:30:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB986C1A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 07:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2007F615BE
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77490C433D7;
        Wed,  7 Sep 2022 14:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662561015;
        bh=4ihs11fEXAe0fupBdMm7BL1byS2jMLCkSSEWmCDE1rU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PLADQG9IV2MRbhBDd+MED4HyFgnuM/i2oNX7C7yUf3eHG3rQSCIAT1hW65gS9DagC
         +BG7utphkTU8Do92sUZvE5lQzSw2tHyawv7/E8i0nTRFE1y0YI2ju9aPcnF034pJ6p
         1OKE6aDI5rjKiCIDr2enbzESERpWCjs05mEt5Zd6+pHp3Y0JHxt6H59W5yya3MqMzq
         cSWb5hzMI7sFr9N3v66KehEGkI3SEedvwfJKJXL2Jw9TgTJgo5gyWUpPB/QnrUwfi5
         /DSq0BspPuak3FPQkBoIMKXB2dsiZkUitmuZ/QNm+PFXq5zN6eLoyouUvhe7AbDmEU
         csDokTrizmfmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4771BC73FE7;
        Wed,  7 Sep 2022 14:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix typo in
 __mtk_foe_entry_clear
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256101527.8164.10142384574894849240.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 14:30:15 +0000
References: <6fb6f748b78faba37702f4757e5b3fb279eaf5ed.1662474824.git.lorenzo@kernel.org>
In-Reply-To: <6fb6f748b78faba37702f4757e5b3fb279eaf5ed.1662474824.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Sep 2022 16:36:32 +0200 you wrote:
> Set ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear routine.
> 
> Fixes: 33fc42de33278 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear
    https://git.kernel.org/netdev/net/c/0e80707d94e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


