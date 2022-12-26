Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA965616D
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiLZJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLZJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF3B1128;
        Mon, 26 Dec 2022 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C14EB80C85;
        Mon, 26 Dec 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C16A0C433EF;
        Mon, 26 Dec 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672046415;
        bh=K2nahARelf8jjVt6hJwqgNrN5+HjOH6hwoG7d09h3ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pn15mqwUXzp9zqPzLqYrst9qz2TUlAqkAR0TvchFi3C+DT3PNyX1Q/hW12qsSWg2p
         BvhFwCY3Wnhk5LN2Vwp5Icfg5sEuyAQReDEnaQ2/z0AKz7D2IeCojnaeaYbN4Qs3wj
         WhtS1ff1AgXnzbfFl6PFmmWJN7NPCOpbTsYh9Qg8svaDhpSBHw3Kin251KrZ4rKsCd
         YolEu4vVrF+2H5Wn93V65EKxXBC6gDwlqgO++ms4DGQ6tikVUrU1ZV1RPFQ7hnsUWh
         lmyvHCIpNrkj7h03T6IjeqtQzT4i7NNxJZYcvEqS9Ouz4+XGYsDbuEPTu48/lQEsCp
         1Zm+ERJLqZSjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94327FE0855;
        Mon, 26 Dec 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: marvell: octeontx2: Fix uninitialized
 variable warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167204641560.10716.11596139736959067527.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Dec 2022 09:20:15 +0000
References: <Y6iLfnODkXm3rFC9@ninsei.anuradha.dev>
In-Reply-To: <Y6iLfnODkXm3rFC9@ninsei.anuradha.dev>
To:     Anuradha Weeraman <anuradha@debian.org>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 25 Dec 2022 23:12:22 +0530 you wrote:
> Fix for uninitialized variable warning.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Anuradha Weeraman <anuradha@debian.org>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ethernet: marvell: octeontx2: Fix uninitialized variable warning
    https://git.kernel.org/netdev/net/c/d3805695fe1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


