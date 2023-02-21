Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC68269D7D2
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjBUBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjBUBAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C2A1E284
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 17:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 725F760F6A
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4BB5C433D2;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676941222;
        bh=3gPE1C88dgmXJlwXG7VTMEgvzEVQxmzJAo2FypiFjKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oJcC73NV55tjbqIErESJiwPSorjn3ReXF4RHpvr9wPcARPq8YxWXqd6gQGpf7954Z
         fEFRS/ukojnFbe8nBywCkIUzjwnVs2/epOHdgSYrsTJaOTNYdWkDwzgn3OhX4jQyQ0
         UWLBzbEJKbnFWsT/4N+E51f3qB1oabnYsj5eXqB7WqKalb4+zRsM8vEnX2+XIn+N4h
         UW1Qoldpnr46EoQ9fm/5urZgj6l7Ck0v3eZA+Un7CjJwXsz0hT3Iv6zBxrK26e7/AC
         PvWqsNXb5sEMBASvbyUEfZAafZAVXKVEDnNPTdIzBPjoNSQtADeHJQ0/SSsI+HD/ye
         iSJ6RklLgXorg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADDFEC59A4C;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 1/9] net/mlx5e: Switch to using napi_build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694122270.14671.16443132044338749783.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 01:00:22 +0000
References: <20230218090513.284718-2-saeed@kernel.org>
In-Reply-To: <20230218090513.284718-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, gal@nvidia.com, maciej.fijalkowski@intel.com,
        aleksander.lobakin@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Sat, 18 Feb 2023 01:05:05 -0800 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Use napi_build_skb() which uses NAPI percpu caches to obtain
> skbuff_head instead of inplace allocation.
> 
> napi_build_skb() calls napi_skb_cache_get(), which returns a cached
> skb, or allocates a bulk of NAPI_SKB_CACHE_BULK (16) if cache is empty.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/9] net/mlx5e: Switch to using napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/53ee91427177
  - [net-next,V2,2/9] net/mlx5e: Remove redundant page argument in mlx5e_xmit_xdp_buff()
    https://git.kernel.org/netdev/net-next/c/bfc63c979690
  - [net-next,V2,3/9] net/mlx5e: Remove redundant page argument in mlx5e_xdp_handle()
    https://git.kernel.org/netdev/net-next/c/9da5294e2c6a
  - [net-next,V2,4/9] net/mlx5: Simplify eq list traversal
    https://git.kernel.org/netdev/net-next/c/3ac0b6aa892a
  - [net-next,V2,5/9] net/mlx5e: Implement CT entry update
    https://git.kernel.org/netdev/net-next/c/94ceffb48eac
  - [net-next,V2,6/9] net/mlx5e: Allow offloading of ct 'new' match
    https://git.kernel.org/netdev/net-next/c/f869bcb0d28e
  - [net-next,V2,7/9] net/mlx5e: Remove unused function mlx5e_sq_xmit_simple
    https://git.kernel.org/netdev/net-next/c/b5618a6b19c9
  - [net-next,V2,8/9] net/mlx5e: Fix outdated TLS comment
    https://git.kernel.org/netdev/net-next/c/afce9271facb
  - [net-next,V2,9/9] net/mlx5e: RX, Remove doubtful unlikely call
    https://git.kernel.org/netdev/net-next/c/993fd9bd656a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


