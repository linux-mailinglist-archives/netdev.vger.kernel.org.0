Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654C4504E64
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiDRJcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 05:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiDRJcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 05:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E4216582
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 02:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5803B611A9
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 09:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6D61C385AF;
        Mon, 18 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650274211;
        bh=CZ45dJKi4Zuhx7J9f+ef0DvLjVgR5l6HFY6mRwCRyZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mQ4y9xC4+nq7Sllvg4+35c4aDy2PMwOrZWxmJxWCqt4keybcf7ww4udclV0EkbaM9
         H4UQi7dMNdsXNryLFsSnWB4yshC8C0gnjNNme6G+WbMzlRH2+1R3vPSsz2pA1zf1uB
         dzb2yBv20g7E5jnw3WCxuZysftsTJF7T+Hg+XRKE1NBn1w0PUXCDRUVoXofaQBxYkX
         G8HCcrkN2znkIk6cOl8gndRZ2i8uQxI0rKV17lIiFNXP+BHDGCXooAq0ZPOIkX7iZk
         GRtIQ3T02pcm8lwfdo8+q+dBQGD+1gSnZVECh3EPFk1zsF69UaL96vbw3R1Fk1q26K
         S5VP3vvKLZUDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1735E8DD61;
        Mon, 18 Apr 2022 09:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] tcp: fix signed/unsigned comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165027421165.11239.14856871083124054472.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Apr 2022 09:30:11 +0000
References: <20220417183432.3952871-1-eric.dumazet@gmail.com>
In-Reply-To: <20220417183432.3952871-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, lkp@intel.com,
        schwab@linux-m68k.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 17 Apr 2022 11:34:32 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Kernel test robot reported:
> 
> smatch warnings:
> net/ipv4/tcp_input.c:5966 tcp_rcv_established() warn: unsigned 'reason' is never less than zero.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] tcp: fix signed/unsigned comparison
    https://git.kernel.org/netdev/net-next/c/843f77407eeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


