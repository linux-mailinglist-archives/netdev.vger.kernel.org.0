Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BCA579165
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiGSDkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiGSDkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6982BCE;
        Mon, 18 Jul 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA89614D3;
        Tue, 19 Jul 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B206C341CF;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202014;
        bh=ikQzpN8MCLg1lqxUB80odOxAzCBnExBDPr8pxjL5ywM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QKfb7r7wlMw9lNv81IcoXBmMhd0RxOz/BSm+wXuXUfC23aRJazPvSQniwvEpuvxX/
         K/gbRHK77fIquHeAMNIrwhoZfu+vcobvpVoj6fGYMOLTYJ25J/ImosfYgWIU7Eo+6G
         8Msbo8urtjmNCfXqItruqcprNzMyBZIe5CKagZL3dNl6IXpre+5eqwesyxgm7IJhed
         AZyvtjtQQnFd0zHLiWL7J12QWpigKUxzNwZ01IWccPVF1bws00pS5bRzRz0V/rMRF4
         0xBmz1Ff+GFgaDXarHfGGHjFtOOzKM1pDntJdnVTKHNewUItsIivuDVXTbFpB96ooq
         MfTTX0LCgjSKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2156AE451BA;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix off by one check of
 ARRAY_SIZE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201413.29134.11488522402561841559.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:14 +0000
References: <20220716214654.1540240-1-trix@redhat.com>
In-Reply-To: <20220716214654.1540240-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Sat, 16 Jul 2022 17:46:54 -0400 you wrote:
> In mtk_wed_tx_ring_setup(.., int idx, ..), idx is used as an index here
>   struct mtk_wed_ring *ring = &dev->tx_ring[idx];
> 
> The bounds of idx are checked here
>   BUG_ON(idx > ARRAY_SIZE(dev->tx_ring));
> 
> If idx is the size of the array, it will pass this check and overflow.
> So change the check to >= .
> 
> [...]

Here is the summary with links:
  - net: ethernet: mtk_eth_soc: fix off by one check of ARRAY_SIZE
    https://git.kernel.org/netdev/net/c/3696c952da07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


