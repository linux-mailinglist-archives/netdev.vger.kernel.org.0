Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8195BD949
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiITBUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiITBUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F65E3CBC2
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF5862071
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02F35C43470;
        Tue, 20 Sep 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636815;
        bh=MukzcpKQbZSw3x6/nwB8kRUDzfGBIV8c2MxRPXhbWDc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tyEYs29CL7L4YR23RAeifeSYO7F+GaZqYD247nRjMwn7TrIqF+lB8JRQWBU9B2giJ
         5zZZ5jdpDDmamWONeNsbzZGWmzTjRu7FP8tlNu491sFPuYX1JcmNePjvtBVDqz0hUG
         wAw+QGeAVDUVcwI3/Zqy0GzM80hYMQYLkblJOhjBNMy++44ERx5VHSzV4VaUwpmYZo
         +lBt0TJb/k9UnaHCTkRlxP3WKR1gZLnskkNJPjxETIcoZ1N1KUlgeoiGAY7Tp5VwH9
         GzYATnB46aG713fvVQjQRWPXtYPAXbLbPaP0NSDp+WFB84ieRSZCbKr7YtwaMRqfCm
         Y9NiAn2ABbjTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFA28E52538;
        Tue, 20 Sep 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: Fix hang up with small MTU hard-interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363681491.30260.14164726870306150299.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:20:14 +0000
References: <20220916160931.1412407-2-sw@simonwunderlich.de>
In-Reply-To: <20220916160931.1412407-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, syoshida@redhat.com,
        sven@narfation.org
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
by Simon Wunderlich <sw@simonwunderlich.de>:

On Fri, 16 Sep 2022 18:09:31 +0200 you wrote:
> From: Shigeru Yoshida <syoshida@redhat.com>
> 
> The system hangs up when batman-adv soft-interface is created on
> hard-interface with small MTU.  For example, the following commands
> create batman-adv soft-interface on dummy interface with zero MTU:
> 
>   # ip link add name dummy0 type dummy
>   # ip link set mtu 0 dev dummy0
>   # ip link set up dev dummy0
>   # ip link add name bat0 type batadv
>   # ip link set dev dummy0 master bat0
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: Fix hang up with small MTU hard-interface
    https://git.kernel.org/netdev/net/c/b1cb8a71f1ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


