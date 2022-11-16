Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D240B62BF80
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiKPNaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiKPNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C7C5FC5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D6D61DEF
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18370C433D6;
        Wed, 16 Nov 2022 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668605419;
        bh=LIwGKdKwntkB4qFNHNodooHn8vh91UnZiipH3p3HrVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B6E0lwGJjaurZQCk3B/pDmFLVHAiBZ53wafqTCISqLq+3l3twRwgFLt2fgPSzwzNB
         E39uoC8/RMnxX3hhcO+d7ys5AoJXTHMdrdYJ3fLhhbsfCxNj/uLKolJBzTM65xjCXH
         NJVxbbPRGIkkC7FXxe4sGHAmoY1PoEpdsiM4achUEoOMg5Y+Ge0CehzkXHnH4WdsCL
         g1tNP5ecrQvoUYOQWC5e+1UhrXThP4TiAJGkuLwHJdjSCiIA0AF32PpcnMcrntOiq6
         ibmHTfw1Ph2vifG34km6CGe9ZkBZoMkOnbCh4eh8xHDBudoTH79+CwgbaUb2e5RfEk
         H5fox7wTumC+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2A49C395F6;
        Wed, 16 Nov 2022 13:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: add atomic dev->stats infra
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860541898.25745.7701892532542014447.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 13:30:18 +0000
References: <20221115085358.2230729-1-edumazet@google.com>
In-Reply-To: <20221115085358.2230729-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 08:53:54 +0000 you wrote:
> Long standing KCSAN issues are caused by data-race around
> some dev->stats changes.
> 
> Most performance critical paths already use per-cpu
> variables, or per-queue ones.
> 
> It is reasonable (and more correct) to use atomic operations
> for the slow paths.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: add atomic_long_t to net_device_stats fields
    https://git.kernel.org/netdev/net-next/c/6c1c5097781f
  - [net-next,2/4] ipv6/sit: use DEV_STATS_INC() to avoid data-races
    https://git.kernel.org/netdev/net-next/c/cb34b7cf17ec
  - [net-next,3/4] ipv6: tunnels: use DEV_STATS_INC()
    https://git.kernel.org/netdev/net-next/c/2fad1ba354d4
  - [net-next,4/4] ipv4: tunnels: use DEV_STATS_INC()
    https://git.kernel.org/netdev/net-next/c/c4794d22251b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


