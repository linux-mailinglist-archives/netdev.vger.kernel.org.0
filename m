Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB706C0ED6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCTKbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCTKbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:31:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC815CBF
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF52EB80DF6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A330DC4339B;
        Mon, 20 Mar 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679308218;
        bh=9RaXCfVzXMa2dO6crrVcELfQaLVsYQJxH9Rn+3/PmsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EbCMgTCOa2SB13eDzGj9LRQwch26DC8QGqo4rXeyRAzSk3UXNAnYhE9f8A2u17/wD
         MJlnkHPrulHWyEvygn4bdkDX3E4lL1FHx3Z54LmGuSdzidEAYVjdq/SiixIm6srWWC
         pLLphSl/76o1hKKPpqI6ouPw77+Zo7gyp0sU7qgWfQJdiE5UYF5NB/PqD74zAuoIUV
         KUchwPqlRKjEuydidgh4pCsieVqEfZ8LONIwEcyJpbsHo+Hx8bSqFcjfKtrJ2gVzx/
         654u04SI6HpLKPvP+RSmGHveRQs0DZkumLOgWG64CN6bPlZvUeom/ih9mJvC1I+ikx
         qzmu4UYkb4E6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86C9FC395F4;
        Mon, 20 Mar 2023 10:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v9 0/2] net/ps3_gelic_net: DMA related fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930821854.19842.2337685653320772957.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:30:18 +0000
References: <cover.1679160765.git.geoff@infradead.org>
In-Reply-To: <cover.1679160765.git.geoff@infradead.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        alexandr.lobakin@intel.com, alexander.duyck@gmail.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 17:39:15 +0000 you wrote:
> v9: Make rx_skb_size local to gelic_descr_prepare_rx.
> v8: Add more cpu_to_be32 calls.
> v7: Remove all cleanups, sync to spider net.
> v6: Reworked and cleaned up patches.
> v5: Some additional patch cleanups.
> v4: More patch cleanups.
> v3: Cleaned up patches as requested.
> 
> [...]

Here is the summary with links:
  - [net,v9,1/2] net/ps3_gelic_net: Fix RX sk_buff length
    https://git.kernel.org/netdev/net/c/19b3bb51c3bc
  - [net,v9,2/2] net/ps3_gelic_net: Use dma_mapping_error
    https://git.kernel.org/netdev/net/c/bebe933d35a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


