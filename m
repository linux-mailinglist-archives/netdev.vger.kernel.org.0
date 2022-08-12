Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC58590F75
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbiHLKaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiHLKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D5312D0A;
        Fri, 12 Aug 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87AC561683;
        Fri, 12 Aug 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8FDAC43470;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300216;
        bh=kiGjzWlVTqZ3IkIGt2dLif9hD6h2olErDZJKs5jeMS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f0RGacCJ486RznCwbFLgScQhrxnvQubJycolSLxr+UzNrUxxnCxU3fKHbulO579hw
         90vn/ppQ62D/7fou8/bonopCCKH9VxrL0Fe4H/v3ab0TfOUR9PwEK0t1n7r2fcclSx
         fQtbmJkom0fdElnwE4b+D60wM5X7jrEirOzZjpP0FfVkZ0TdFPVC0PKWowFCw8C2nx
         HcB3+Vyic6nEmlzPbY8PidyiLE5E4EtYEyLvyW2INaMeEYfp0tdWMMtHgllAoCcoxg
         CU1y5RXZj9vn7Ob3bR0boZ5JftU2yzBbvF/BHLMIsOr0tDbMtE0+SiGK1MAuHe1a/e
         h6A/GSFjiJeTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D600C43146;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cxgb3: Fix comment typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030021664.10916.10850939749360400636.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:30:16 +0000
References: <20220811115701.4578-1-wangborong@cdjrlc.com>
In-Reply-To: <20220811115701.4578-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     edumazet@google.com, rajur@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 11 Aug 2022 19:57:01 +0800 you wrote:
> The double `the' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: cxgb3: Fix comment typo
    https://git.kernel.org/netdev/net/c/75d8620d46f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


