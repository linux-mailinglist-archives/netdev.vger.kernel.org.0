Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE725EEB9D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiI2CUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiI2CUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDF699B65
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 434C861E23
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 910BCC43470;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418017;
        bh=iOpHJ2QENss2jRAqS8WGZFmX39Qc0OWU2wFiM/Sj+60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UnldsmSlUqdJIXSeWKCyldFI7KN67H+NHlT0QobrY1hLjNzd7mAaAYbNBeNVKEVmm
         xShgrvnQs6/dRXUjws0GYJYftp8FKfab1GP+ElS3RZ4mZ2KB0lfA36PFGKDk1+lud3
         0JHvq5lX7KDQQYNhRmXRBD15tbEuhZo5yf6QH/0jN45pLVQthCR2hG6aE/DRlsgkhs
         X8/e7jST5K8lhti/nA5YoW28hhQd9bCV9UBoywbyk2VJYkh5uCeuvC6ELGCk+35l2N
         EbW1ib46luMiDWqyKcJqnNrtIY7y2FEn/WFaxd2b361Jt8FXII9BNLChNquQIP26T7
         DN4CYSUkOKOAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71F99C395DA;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix mask of
 RX_DMA_GET_SPORT{,_V2}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441801746.18961.5553365683455368502.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:17 +0000
References: <YzMW+mg9UsaCdKRQ@makrotopia.org>
In-Reply-To: <YzMW+mg9UsaCdKRQ@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        lorenzo@kernel.org, sujuan.chen@mediatek.com, Bo.Jiao@mediatek.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        ptpt52@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Sep 2022 16:30:02 +0100 you wrote:
> The bitmasks applied in RX_DMA_GET_SPORT and RX_DMA_GET_SPORT_V2 macros
> were swapped. Fix that.
> 
> Reported-by: Chen Minqiang <ptpt52@gmail.com>
> Fixes: 160d3a9b192985 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> [...]

Here is the summary with links:
  - net: ethernet: mtk_eth_soc: fix mask of RX_DMA_GET_SPORT{,_V2}
    https://git.kernel.org/netdev/net/c/c9da02bfb111

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


