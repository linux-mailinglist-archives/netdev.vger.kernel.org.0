Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F5268EAB3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjBHJNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjBHJMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7194614C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 01:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57948B81C86
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0B06C4339B;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675847418;
        bh=FxBcJ9a/SucJJL22BSmbZLPENHvNE4Mra7Lm9708qso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDr0/lZnMHd+ldlOerBA59djbGYQid2xe3rRaUeJk0HNUX4LUef1fsB0wplIl/OAf
         xrkSiK1vq7CBDw7xpEbn3q4UTH2Iq41GoFB9anW4b6b+Tih/oPSIEeeeyV9DSGA2gn
         3OIX0LxDNMoQ6tBjsxBsansgwPaUDscS4hFHxNzIxdQOBLukX9eRQMyTk0s7y/Ae85
         Aa3zpw6RPm4UP019MDKCjPGUDywmo8xtyyq9gcsAMEGe86xOx9wsNPaDsLdVtoDbJG
         EMOtr8THqBxW8wo1fPyFCeHhMhnLhSpRfgvpFma+CPprapMRqiCsArGkKAGoerjjFF
         dypzN4zQDq89w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D890AE4D032;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix wrong parameters order in
 __xdp_rxq_info_reg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584741788.9727.3543093421565560108.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:10:17 +0000
References: <20230206204703.904533-1-tariqt@nvidia.com>
In-Reply-To: <20230206204703.904533-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nbd@nbd.name,
        lorenzo@kernel.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 6 Feb 2023 22:47:03 +0200 you wrote:
> Parameters 'queue_index' and 'napi_id' are passed in a swapped order.
> Fix it here.
> 
> Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()
    https://git.kernel.org/netdev/net/c/c966153d1202

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


