Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B105F0B97
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiI3MUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiI3MUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A0A9E6A1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AFA56231A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2849C43140;
        Fri, 30 Sep 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664540416;
        bh=8wyBq27ONaRYEt9K2HA+ePtn92L/OzkiwBcP7zlpfHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aC4+wJ2si426CQyGxgqJ6dccICJFuBXVIF1SjbVZ6be8SmS1yyYNdnWbX8VxPZ6Ke
         PLfUBknl7vimVCkWWp8nMRth+R3Lk/lE8Hz6ZXElvijTUP9EQkcRoHncKNpmctnJlz
         mOmu0TEiSRjpFyLc3G8glvv8SkzNP3SwbkmaMJw49Xt7Z3Iz/o6lP9LuzPJ+R5UTnu
         BioyM4+AHJmnAMlnsRy6z6i44QggYJ4dw4uAbVeBN0raasfO15da5tk3nRq38lwqLv
         HsJBeU67MswBq1WelxmTUdbI1YuY1NQqjHT7reHe4BQzwqTbvomCfNRBlks0Uv6RSL
         WxrMA5oXcW1PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C894CC395DA;
        Fri, 30 Sep 2022 12:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix tcp_cwnd_validate() to not forget
 is_cwnd_limited
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166454041581.28902.7091492423024091843.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:20:15 +0000
References: <20220928200331.2997272-1-ncardwell.kernel@gmail.com>
In-Reply-To: <20220928200331.2997272-1-ncardwell.kernel@gmail.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        netdev@vger.kernel.org, ncardwell@google.com, yyd@google.com,
        ycheng@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 16:03:31 -0400 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> This commit fixes a bug in the tracking of max_packets_out and
> is_cwnd_limited. This bug can cause the connection to fail to remember
> that is_cwnd_limited is true, causing the connection to fail to grow
> cwnd when it should, causing throughput to be lower than it should be.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited
    https://git.kernel.org/netdev/net/c/f4ce91ce12a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


