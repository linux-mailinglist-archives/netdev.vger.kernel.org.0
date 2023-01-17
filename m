Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C0866DA2E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbjAQJmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjAQJlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:41:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D50B2B60F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B86466123F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BB08C433F0;
        Tue, 17 Jan 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673948417;
        bh=eihgT5qhm1+lfKLwyIi0d4iVjgP82tcnOIZ4kA4AjEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bnkVgLmkEaTCxn/hCGnIDxbodJTwNkcWjinZJzPC5nrLeTqaHwrhpCwy9ZBDFg1yZ
         V8UtPOW9FAYrF91q+wBA/ZE6Wih43Gd9ypwcrdythDFMjsJN+b39jTMmZVJwtFrR0Y
         05aWDZ1dtBMvgxl0hWkVeH7Ovfd/f0NwUoVe5s+nA2H0/mV6789X/0dCdNKpHp0+CH
         6vKl8hfJKCEmIvpSObSoJ7q7Ki1V6BmePTmAJ4Xqk0kDr+458aIGkUjmOlH7kRRFOp
         iWgpuy2GPo5cRRAbfOdluYXpqf1pzRwOts1+exStLIVj65nonBdH4EyyCs0Xj7a4G8
         NewWkkum49SMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 010DAC41670;
        Tue, 17 Jan 2023 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/2] net: use kmem_cache_free_bulk in
 kfree_skb_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167394841700.1380.843200893151846493.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 09:40:17 +0000
References: <167361788585.531803.686364041841425360.stgit@firesoul>
In-Reply-To: <167361788585.531803.686364041841425360.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 Jan 2023 14:51:54 +0100 you wrote:
> The kfree_skb_list function walks SKB (via skb->next) and frees them
> individually to the SLUB/SLAB allocator (kmem_cache). It is more
> efficient to bulk free them via the kmem_cache_free_bulk API.
> 
> Netstack NAPI fastpath already uses kmem_cache bulk alloc and free
> APIs for SKBs.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/2] net: fix call location in kfree_skb_list_reason
    https://git.kernel.org/netdev/net-next/c/a4650da2a2d6
  - [net-next,V2,2/2] net: kfree_skb_list use kmem_cache_free_bulk
    https://git.kernel.org/netdev/net-next/c/eedade12f4cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


