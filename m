Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE1862B25A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiKPEaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKPEaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C07313FA2;
        Tue, 15 Nov 2022 20:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0166199D;
        Wed, 16 Nov 2022 04:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28435C433B5;
        Wed, 16 Nov 2022 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668573016;
        bh=EU1LfzRE1qzP88BXkl6vs7WBr5H5/7KAwJzENNpOsBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m+sHUBCwhpSNhem3afAZHAamLoK1fFlRsibFke9LEpXHQ3XsXO+H8HX7uQBnztybr
         29m1G1dFG69atnSazArrncF+s/ytyA7HjB9N6GOTDsqeNNgdO0/93uR6Tg7wseX2MD
         TmUhEeH94FMcsI+7aKSrGZiUcQ/KTFL/PqQS5wGXGSi2sE6It4ZWXZcmSl3vPSkKy6
         h90CY2XTDNsBod4oXMrtG4FbFPyoOhwr3ru2Fbt+cWtHsy2yEZ+tNgGP49Bn4Zoz8x
         8w0ZgUtEVFuc9EOdSxF7KaAdsWHKkL1BR07wUydEIQxPINnxi+PolW3S1riS61dV00
         fScFPa6Bv2Zng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EC74C395F8;
        Wed, 16 Nov 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] mtk_eth_soc rx vlan offload improvement + dsa
 hardware untag support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857301605.26862.16492412273467465968.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 04:30:16 +0000
References: <20221114124214.58199-1-nbd@nbd.name>
In-Reply-To: <20221114124214.58199-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, matthias.bgg@gmail.com,
        olteanv@gmail.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
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

On Mon, 14 Nov 2022 13:42:10 +0100 you wrote:
> This series improves rx vlan offloading on mtk_eth_soc and extends it to
> support hardware DSA untagging where possible.
> This improves performance by avoiding calls into the DSA tag driver receive
> function, including mangling of skb->data.
> 
> This is split out of a previous series, which added other fixes and
> multiqueue support
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] net: dsa: add support for DSA rx offloading via metadata dst
    https://git.kernel.org/netdev/net-next/c/570d0a588dfb
  - [net-next,v4,2/4] net: ethernet: mtk_eth_soc: pass correct VLAN protocol ID to the network stack
    https://git.kernel.org/netdev/net-next/c/190487031584
  - [net-next,v4,3/4] net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload
    https://git.kernel.org/netdev/net-next/c/08666cbb7dd5
  - [net-next,v4,4/4] net: ethernet: mtk_eth_soc: enable hardware DSA untagging
    https://git.kernel.org/netdev/net-next/c/2d7605a72906

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


