Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD90665753E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiL1KUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 05:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiL1KUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 05:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111262DC0;
        Wed, 28 Dec 2022 02:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D1461455;
        Wed, 28 Dec 2022 10:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7BE0C433F0;
        Wed, 28 Dec 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672222816;
        bh=SyqxCpK3W8EbtAhH1SpAUC0rDkDp9U2trMuP6RILko4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CTlcUd0vZNKfSbr5HH/HtbmmGK4Kt12nDMGBM2mvV7+F4kbBKHzWaGifZ5KZtprhR
         vA9zBjqE7mkosZ0DKgK2lQin9gJvvRF2pZRLjorwur5rriIhWCLUeZU4QhIvdYd6tJ
         X2FQW1p1AVwxXLwwdCldfEwfWVtBtzUTWUnAjOlx/mKxO6SyQWg+KbYx9t4q40Hs29
         TtclWFVqTHKYAMk6vdF0PNKxj2SJt/3UmkgQ6OqBCwwRUZdl2Q5EzC2blwMdWFVLWO
         G1379lmvzDX6GwLGR8a1hNigxAkP3yfLzNVesiM2GVkLxUdHpC0/evngva/WId6iMw
         jBBO3XNPxB4LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD062C395DF;
        Wed, 28 Dec 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: ethernet: renesas: rswitch: Fix minor issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222281583.11291.2902549623558280221.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 10:20:15 +0000
References: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Dec 2022 16:13:26 +0900 you wrote:
> This patch series is based on v6.2-rc2.
> 
> Yoshihiro Shimoda (2):
>   net: ethernet: renesas: rswitch: Fix error path in
>     renesas_eth_sw_probe()
>   net: ethernet: renesas: rswitch: Fix getting mac address from device
>     tree
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: ethernet: renesas: rswitch: Fix error path in renesas_eth_sw_probe()
    https://git.kernel.org/netdev/net/c/8e6a8d7a3dd9
  - [net,2/2] net: ethernet: renesas: rswitch: Fix getting mac address from device tree
    https://git.kernel.org/netdev/net/c/bd2adfe3b3b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


