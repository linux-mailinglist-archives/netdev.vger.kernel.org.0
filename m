Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CD96B3758
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCJHaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCJHaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29486ED680
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C80B7B821CE
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81AF3C4339B;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=hY8KZ4A7n010l1nXUKFB8bhbsjYztX29wcZZAAWP4O8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DNs1hj4FbsDJso7nKq7aq4yBiinwErgp6Z749M51vC5S0IWJcZkXTyJCNYcWkw8mJ
         WeOUC+sTQmOwb/4Xrh+XkRO5NpU0RbxxHxkP/M9gjcQ4EzZ2JYa3HZiJjNcnCvjWjB
         RTNKQIb0cRoPqvi/+RN6ObvBWDiy77+el17oYOb3nTohTBHLhD5oQe6rC9aR1CuOyt
         zh8h6HfIoIoMEV0RUCbRYz52C5IPGdY2LjAbX4j+v4xjPVVicVmamofr40IwUa/uPw
         F8/C+jAVm5kAzjyeWV5zBMVXzf9BhHnkZv8mDaekfgXYeXUw8eZTTJBBXRX3EhDMSY
         Q/t1Q7HXxohfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63819E270C7;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: remove qdisc_watchdog->last_expires
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341940.20837.5778954574225630042.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <20230308182648.1150762-1-edumazet@google.com>
In-Reply-To: <20230308182648.1150762-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 18:26:48 +0000 you wrote:
> This field mirrors hrtimer softexpires, we can instead
> use the existing helpers.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/pkt_sched.h | 1 -
>  net/sched/sch_api.c     | 6 ++++--
>  2 files changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: remove qdisc_watchdog->last_expires
    https://git.kernel.org/netdev/net-next/c/62423bd2d2e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


