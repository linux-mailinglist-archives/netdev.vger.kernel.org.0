Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEE643B45
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiLFCUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiLFCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC01EC61
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18BFFB81210
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDEDEC433D7;
        Tue,  6 Dec 2022 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670293215;
        bh=3xngoC5twmoImoskHL693S6+xKVwrmGdOHi6sk1lcwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sRLJEJ09nYclz3ALakOAg93398eWnt+O90hc1eeG/M1UjQHmZcc1V9StmcSrVbUbH
         82rzhzf6PUoy/RuCNH/tOy1SPxRlNcTKrjWrCHyIdn55e47V/ezjFxy+6pXUcMsYJ5
         gcFgHobATfR3BDB0J00IY5hggu9FuHYPqzLoh1deyx+3RQdMNnd7uuD/dfoBINVzmq
         w9kOIIe/F1VGkSymPPlh9Req9SzWv48bT/YW+fY5YRn32geEKznFUSKY5RCMF/ogbq
         iFNsMagaVmWVUbLQQMxKKbfm5gzk6CQt2qyP1F76yZK9w7QCLEwiFf5NF1SuOnvS6A
         qDzfU45yMxZQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1A60C395EA;
        Tue,  6 Dec 2022 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mtk_eth_soc: enable flow offload support fot
 MT7986 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167029321565.12541.13204122359496761946.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 02:20:15 +0000
References: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
In-Reply-To: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com,
        lorenzo.bianconi@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  3 Dec 2022 14:20:37 +0100 you wrote:
> Since Wireless Ethernet Dispatcher is now available for mt7986 in mt76,
> enable hw flow support for MT7986 SoC.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] net: mtk_eth_soc: enable flow offload support fot MT7986 SoC
    https://git.kernel.org/netdev/net-next/c/c9f8d73645b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


