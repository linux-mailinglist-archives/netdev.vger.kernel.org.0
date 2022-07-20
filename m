Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF457AB0B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiGTAkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237990AbiGTAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED6D4F18C
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ED63B81DD7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C80CBC341CE;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658277613;
        bh=rKl6+n8U0dNHbTkWDeG4PWDZcTMCHPPupA9tyCjbTOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cc14G45xNTO1HvktI9I7MQEwB6JQW2ATKXy91DZDt77xDfQe1YHucDTUcYonRhtJH
         dDbzWTk3wxO7VUs6YLMxbOCOPgGknRjwtmVcJg3UK5akqUeE6jjvE/dOQqNxMapx6k
         XgaBKNo14jjUKpYNrBgdQE8rJGX9hes3uhAHHJn9yvLoVWlyXUPtACOT0jDVuULIEf
         UWZ53iDfX1VvjWUBfiEidsqhgW0a2bYNgu6lIf48TsCvBTEKOQwVvT0tXSVq1U0cS8
         oqySyUwdQt2dSs4NRkhblbDoAPxOrulSzhuT5nw/yvCCmUddhhRySmU0PUoDCfIPmA
         eCyllgHsrqJ6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A6B9D9DDDB;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_ppe: fix possible NULL pointer
 dereference in mtk_flow_get_wdma_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827761362.10063.15701613419779196006.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 00:40:13 +0000
References: <4e1685bc4976e21e364055f6bee86261f8f9ee93.1658137753.git.lorenzo@kernel.org>
In-Reply-To: <4e1685bc4976e21e364055f6bee86261f8f9ee93.1658137753.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 18 Jul 2022 11:51:53 +0200 you wrote:
> odev pointer can be NULL in mtk_flow_offload_replace routine according
> to the flower action rules. Fix possible NULL pointer dereference in
> mtk_flow_get_wdma_info.
> 
> Fixes: a333215e10cb5 ("net: ethernet: mtk_eth_soc: implement flow offloading to WED devices")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_ppe: fix possible NULL pointer dereference in mtk_flow_get_wdma_info
    https://git.kernel.org/netdev/net/c/53eb9b04560c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


