Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD6586806
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiHALUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiHALUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C4726E8
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDFB06122A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EAC7C433B5;
        Mon,  1 Aug 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659352813;
        bh=8OQkOwOvAZpyViPlF34utI2BZ4eS2Q+qY5WJCWiDSrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J9+PtW8ezC6FPqCm3tBeFnHoPZA11lv6f0GtPR4WXoMb+DBKOvZc9c1LWYQiguE1N
         1TvamJzJ5x+fwvtEqwYcP83AdeEPN6i5JTIGGAHwF4QQUTn5W5oBUu+5EUFlhoOsum
         ITHCgF+80G7e2Js8NrwSczXJjnK8wPdqwbBpulAQzFMwyoIGYWu7YCzJ2hnHnK/06u
         VBI2BaJL0pi8f4T6HtLMNfKvs1lYH7tNs5EFrhxnSCjPmFgUE3H2k0tVh+6fPozHTQ
         AtphjcvFhc9yiSrcS2WebM1rzKPJjH3FO3Z9yINn5sIr1P5jHIsscAGNVjNVtoxTMt
         acnBehiBzeWaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20787C43140;
        Mon,  1 Aug 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next] udp: Remove redundant __udp_sysctl_init() call
 from udp_init().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935281312.11252.4065180388862736851.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 11:20:13 +0000
References: <20220729032137.60616-1-kuniyu@amazon.com>
In-Reply-To: <20220729032137.60616-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiangxia.m.yue@gmail.com, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Jul 2022 20:21:37 -0700 you wrote:
> __udp_sysctl_init() is called for init_net via udp_sysctl_ops.
> 
> While at it, we can rename __udp_sysctl_init() to udp_sysctl_init().
> 
> Fixes: 1e8029515816 ("udp: Move the udp sysctl to namespace.")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [v1,net-next] udp: Remove redundant __udp_sysctl_init() call from udp_init().
    https://git.kernel.org/netdev/net-next/c/02a7cb2866dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


