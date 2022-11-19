Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABFD630B99
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiKSDy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiKSDyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:54:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3115FC72C8;
        Fri, 18 Nov 2022 19:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D8662855;
        Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A02AEC43147;
        Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829819;
        bh=soW1Kc5f4meOkpm3t6Ttp/wLShmdkeEAIerUQU/e8Bw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFHmBqsCcaWUQpBcjaxEl7FzbNsgrl4owLQq1Ab6qnLqwXpluT39QoLhqlFzDuD1r
         KWfCQA9EH3WF0W9mTYo97ZbtaJ2OxeEuNTpbUhMj3ST0SAZ0AaJeVCfl/DMxpZoW2G
         QwGTCFeY9fhWaPssqRwYiXZOm6nLcJ0b5JMUkQswW5dQhQClK6eA/8shs+LQELFqza
         D/R9lB9W2EHw7QtRRWdWfEsV3nguYv4vetkMOe0YMTHZZAsO726eWmkwoA5G2cmMO8
         cUZcNj3cB/ykTEcdyl/fw/8Gh/RwwgXqwLpHtmJtohpgQ3TCgBpEvD1OQPT5LO98pY
         +XSBzmDr3aB8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E84AE4D017;
        Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] net: ethernet: mtk_eth_soc: increase tx ring
 size for QDMA devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981958.27279.4643312403329696059.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:19 +0000
References: <20221116080734.44013-2-nbd@nbd.name>
In-Reply-To: <20221116080734.44013-2-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Nov 2022 09:07:29 +0100 you wrote:
> In order to use the hardware traffic shaper feature, a larger tx ring is
> needed, especially for the scratch ring, which the hardware shaper uses to
> reorder packets.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 ++++++++++++---------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 +
>  2 files changed, 23 insertions(+), 16 deletions(-)

Here is the summary with links:
  - [net-next,1/6] net: ethernet: mtk_eth_soc: increase tx ring size for QDMA devices
    https://git.kernel.org/netdev/net-next/c/c30e0b9b88b3
  - [net-next,2/6] net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
    https://git.kernel.org/netdev/net-next/c/f4b2fa2c25e1
  - [net-next,3/6] net: ethernet: mtk_eth_soc: avoid port_mg assignment on MT7622 and newer
    https://git.kernel.org/netdev/net-next/c/71ba8e4891c7
  - [net-next,4/6] net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues
    https://git.kernel.org/netdev/net-next/c/f63959c7eec3
  - [net-next,5/6] net: dsa: tag_mtk: assign per-port queues
    https://git.kernel.org/netdev/net-next/c/d169ecb536e4
  - [net-next,6/6] net: ethernet: mediatek: ppe: assign per-port queues for offloaded traffic
    https://git.kernel.org/netdev/net-next/c/8bd8dcc5e47f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


