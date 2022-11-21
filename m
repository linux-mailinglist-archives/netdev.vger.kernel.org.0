Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3021631D52
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiKUJux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiKUJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847782AE08
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38834B80DC5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0850C433B5;
        Mon, 21 Nov 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669024214;
        bh=TxeDnuCFdkOMJLf4SGj8DH2Nqu6PFqHc0BR8izOerys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=beZQP9HytS6xbUxMxBBIBz8nW9T+35xx+2Aq87YZTZ1WF6019g4Yk/A8HGLJI3BMC
         kX47Yb/bkG9iXgAZK8dNpSBmcLTG+Cm6jRghZItb9Zo0IGGUOFSqFpN1UJKsSq2ULe
         d1csyIdxSkIx5YxgxzAIsMjhGJvE57SDGyYm1VOIfUe6O7iqe22/FV/dtCeMQ+zG3c
         75ZlFfn4jGQbG8/6CvS69hShUtIwNDjOPh1PU7UDlO3NjTSZORrkXQGKIYSxqUXLdn
         FkXxiwzkkc4NbPbYRxofDLs00R0JHCGGMXCiFwENIrxL9CyaKkrB5q6Qygq3mqw8EB
         /38OjLtbGXeUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC296E29F40;
        Mon, 21 Nov 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1}
 definitions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902421476.7862.8202888233247516668.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 09:50:14 +0000
References: <9a10df72ee337803bc369481a2b82f7aa14b0913.1668695355.git.lorenzo@kernel.org>
In-Reply-To: <9a10df72ee337803bc369481a2b82f7aa14b0913.1668695355.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 15:29:53 +0100 you wrote:
> Fix RSTCTRL_PPE0 and RSTCTRL_PPE1 register mask definitions for
> MTK_NETSYS_V2.
> Remove duplicated definitions.
> 
> Fixes: 160d3a9b1929 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
    https://git.kernel.org/netdev/net-next/c/ef8c373bd91d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


