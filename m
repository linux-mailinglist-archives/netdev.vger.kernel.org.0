Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541C4688EF9
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjBCFa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCFaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6E2201A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 21:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F67A61D92
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE4CEC4339C;
        Fri,  3 Feb 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675402222;
        bh=rCv2rolCE5GNlMoQ6389D/6+8nzPyRMf1vR2+wFCwUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uIOMFPhGUM9Ry6Z5CYpsup2cbLTerfEmdMClu+RRgA9RbfQ35CkAPZzi4RsyWp2g5
         /wSkNoqXO/FBOSp6YjkoBMBOBLU/NDcp0oYogU6JKib5HFCldR8us3gFXeStezb+XX
         B+fjdYSx15S2c2tmcMLzfv98zZPydd0daWY4Hbo4Ab0CgT1v6Ls/t9vQvyeWcaNGcY
         5QOWQGbEF+HosvB/5kgusIMNySLQF31dIBMkBI4lrvBGF0j50kLJB3E3pLfLFjzlZq
         ZCObwQNIOi/TXY9HKDDN0HJMOZd6MeU3E17SqKWsLEd4ByWhRvGzkvMw1W6B0LROr8
         4H4mtKajoOvEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF708E270C5;
        Fri,  3 Feb 2023 05:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: add TCP_MINTTL drop reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167540222271.591.8983405225381016025.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 05:30:22 +0000
References: <20230201174345.2708943-1-edumazet@google.com>
In-Reply-To: <20230201174345.2708943-1-edumazet@google.com>
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Feb 2023 17:43:45 +0000 you wrote:
> In the unlikely case incoming packets are dropped because
> of IP_MINTTL / IPV6_MINHOPCOUNT contraints...
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/dropreason.h | 6 ++++++
>  net/ipv4/tcp_ipv4.c      | 1 +
>  net/ipv6/tcp_ipv6.c      | 3 ++-
>  3 files changed, 9 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] tcp: add TCP_MINTTL drop reason
    https://git.kernel.org/netdev/net-next/c/2798e36dc233

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


