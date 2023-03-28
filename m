Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A6A6CB452
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjC1Cu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjC1CuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:50:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1682705
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 19:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B8D7CE1B18
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51AF7C433A4;
        Tue, 28 Mar 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679971819;
        bh=PvkEMYHPD9ijs3/8/L8RNyE5TUc7GR4r52ELVZ8wn7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dfH54eS9+Bz4nX3HYVgnB3f1zwa3crMSyhvG1W1qBR0MfYlVYNjWYl+uQfXNh+uAX
         L3L4fpeqkJQbo1qKJ12lA6uoJ+qk/ktn4VlqCdlGwjRz6TUPPC/KkZhSxs3lKrOFBq
         dp+XG1UT80Heja/hakvIrodXFadpq84+w2Ni2Z31vuGbl1X/lPtvZWGHhfsxxL4b6t
         yDErsBbQC/w2a398GJTMOkdNQrgwM6uDZSI6ID4jVvMsPMRIF6eF19+kqTiK9G+jYg
         TiYB2F9FbZ4vNFubHNlMsiiL8ZO8CSQNVsa5NJP8AcclJEsCrnhhIT6hn7rGoKZLfM
         Q8PLQYTQ08JLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4005CE2A038;
        Tue, 28 Mar 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167997181925.12698.13203831155634441163.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 02:50:19 +0000
References: <20230323162842.1935061-1-eric.dumazet@gmail.com>
In-Reply-To: <20230323162842.1935061-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, razor@blackwall.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 09:28:42 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
    https://git.kernel.org/netdev/net-next/c/3948b05950fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


