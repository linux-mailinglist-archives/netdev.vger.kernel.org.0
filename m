Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4CB60FF73
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiJ0Rk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiJ0RkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D275509F
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 10:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19AB76240C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 17:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74069C433B5;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666892419;
        bh=FLCt6zOb6QGiF4FUTJ1ij1HtTRaCWO9DRbzau1EVzso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EBUc4J8T5WlLngA+PJXoK6NprfBL0bs93W3+tdxLycID/ZlBBk8jpRmAzipJcBvpU
         PCzxdWtpZTs7fRQxLDByuXfjs6S821ZGDv+yuTYaIGTUgp5fgqB97+ZNQpqoWdpFGB
         EWK9tuZizy8/ajLG3hAg4raMbTR9fcLn6n6vBAt15VGw2vu8xrHS29x3Zm2NdvvhGC
         DOIIVokRRC6wxC9TKG8vlHOmiNQ3WOUbUADZkOrIT735hc2fCmpoeo0gqG2cliCpPL
         U1W0FjVMLUvGUkIklNLowskzCspNY6gWKH0rl4bkCD6TWO8+gGKDG5Ab4dFCH0/bW2
         841k6k+kTuyeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57FFEE270D9;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ip: rework the fix for dflt addr selection for
 connected nexthop"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689241935.10875.15638803600387850585.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 17:40:19 +0000
References: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ja@ssi.bg, dsahern@kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Oct 2022 12:09:49 +0200 you wrote:
> This series reworks the fix that is reverted in the second commit.
> As Julian explained, nhc_scope is related to nhc_gw, it's not the scope of
> the route.
> 
>  net/ipv4/fib_frontend.c  | 4 ++--
>  net/ipv4/fib_semantics.c | 2 +-
>  net/ipv4/nexthop.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net,1/3] Revert "ip: fix triggering of 'icmp redirect'"
    https://git.kernel.org/netdev/net/c/745b913a5994
  - [net,2/3] Revert "ip: fix dflt addr selection for connected nexthop"
    https://git.kernel.org/netdev/net/c/e021c329ee19
  - [net,3/3] nh: fix scope used to find saddr when adding non gw nh
    https://git.kernel.org/netdev/net/c/bac0f937c343

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


