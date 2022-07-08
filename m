Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2566956BAC6
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiGHNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbiGHNaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD62CCB5;
        Fri,  8 Jul 2022 06:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2674F6272E;
        Fri,  8 Jul 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D6B5C341CB;
        Fri,  8 Jul 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657287014;
        bh=8mJMsLzLnFaXdAAHdnwJWxIAa9x3j7A+VkciPYc9Tn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gr3+6HhM7MMD8zPk4VRlfOyq1nxlctXLNDPq+umc7VG3jUAuBlwhe19Jv78bjnf9f
         NLCd79Dk/R50f6qAuqlmtndeBZ4Xh4zWSURxX+EItWRGzkBzCeyaP1KGYGDlIZ0VpG
         ub/G4vHUS7r3BXta5HqMGqwJskE+EbgdrPJHLKWgedjMcIXVs5T/hOTCr3kDF+vg7M
         yeXJ6IO/vIRdq6DGX9A4Vrc3eoUhcW90IlD+ZVsB4/DyZyZQdQf1OF6eIgBr923bVO
         dV2xI6nOEGpKKgo2qUUbvIt8aLWsEbTWQ+0hcCGb2KnF00MwW6Eg/VytBkF+jID2H5
         JGZGbzz8TCD3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61E3EE45BE1;
        Fri,  8 Jul 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ag71xx: switch to napi_build_skb() to reuse
 skbuff_heads
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728701439.7845.10823920521689241514.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 13:30:14 +0000
References: <20220707141056.2644-1-liew.s.piaw@gmail.com>
In-Reply-To: <20220707141056.2644-1-liew.s.piaw@gmail.com>
To:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Jul 2022 22:10:56 +0800 you wrote:
> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
> cycles on freeing/allocating skbuff_heads on every new Rx or completed
> Tx.
> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
> Tx, so it's never empty. The budget parameter is added to indicate NAPI
> context, as a value of zero can be passed in the case of netpoll.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ag71xx: switch to napi_build_skb() to reuse skbuff_heads
    https://git.kernel.org/netdev/net-next/c/67d7ebdeb2d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


