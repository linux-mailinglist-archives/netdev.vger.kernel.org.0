Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A448678FFF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjAXFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjAXFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B542B284
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED263B81052
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 752C7C433D2;
        Tue, 24 Jan 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538817;
        bh=qdatEwANTcHCg1vIoqTGfx/JGNrO5Kz0Yl6GKtRQNIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gtajm+HZxtaCcmZBAKPrZk+GuoiFmOlwHiAtG21+uwrBB+CaQVbB4PlMCCEo5Vy/O
         Wi+t8bnPcI6bo9HKgkP1BpLSRKLerCknSE389GdQx+b+rc55w9jViNbKn+UB+6pi0/
         u+QCkTLVsLKPD/FnReTNI9BbNKxI9RadI9SLg6pXvDby6kqsHdksyoxO9+JADHq7l3
         tIRiqwtMZ8rxNRJkl8mT589/RCgYhwgbhYciJKQvJVbByJ1k1uKcoeawjj7C1E14Tp
         tIhbiIKo8BhIA9gLjQm3qTCro333PhrpDInSLT7g4yiBCHUweW6vMkoAsI/4MG1J+k
         hwpoe98NBLlBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 606D7E4522B;
        Tue, 24 Jan 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] netlink: annotate various data races
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453881738.30916.1917772216406664118.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:40:17 +0000
References: <20230120125955.3453768-1-edumazet@google.com>
In-Reply-To: <20230120125955.3453768-1-edumazet@google.com>
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 12:59:52 +0000 you wrote:
> A recent syzbot report came to my attention.
> 
> After addressing it, I also fixed other related races.
> 
> Eric Dumazet (3):
>   netlink: annotate data races around nlk->portid
>   netlink: annotate data races around dst_portid and dst_group
>   netlink: annotate data races around sk_state
> 
> [...]

Here is the summary with links:
  - [net,1/3] netlink: annotate data races around nlk->portid
    https://git.kernel.org/netdev/net/c/c1bb9484e3b0
  - [net,2/3] netlink: annotate data races around dst_portid and dst_group
    https://git.kernel.org/netdev/net/c/004db64d185a
  - [net,3/3] netlink: annotate data races around sk_state
    https://git.kernel.org/netdev/net/c/9b663b5cbb15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


