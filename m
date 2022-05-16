Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D91528251
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbiEPKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242704AbiEPKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAD824099
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F23B8109A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2321EC3411A;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652697614;
        bh=J+6vur61ongbbfu20wYIfPAe4Xm4731peu/adraGjuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GIIWKyKVbYpDyR1A67M5P1h/s79heXku8R9eqkOlKaRV4YD7ZB9u8R7hR1FWWrSwI
         kSVrqBzwcoJq/vNFYybovQb1TeS+hP+6x/D14PysMTGZ5v1I4mLrKftSYnlnaLNNI2
         +L3r1mymq23a4dGXsBWTqb4SXwqGP8Rz2rZO1WTf186MXaOjwN4QYavZADoc9kUyAB
         BvLB3jYyVQLfzZjDkcQ42ZhMC84Fl4ElhvprjEm1hgHpr1bIumtybxma9rPmblvFfE
         qj4rJfF4aPOc3knAKpvlwLOQ0RAJ4aCgANJH1msuLsTU4321qL8JNYm3G441Ln9grJ
         fwOTzdAImRXUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 007FBE8DBBF;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: polish skb defer freeing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269761399.8728.11502818429401349664.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:40:13 +0000
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
In-Reply-To: <20220516042456.3014395-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 15 May 2022 21:24:52 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While testing this recently added feature on a variety
> of platforms/configurations, I found the following issues:
> 
> 1) A race leading to concurrent calls to smp_call_function_single_async()
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: fix possible race in skb_attempt_defer_free()
    https://git.kernel.org/netdev/net-next/c/97e719a82b43
  - [net-next,2/4] net: use napi_consume_skb() in skb_defer_free_flush()
    https://git.kernel.org/netdev/net-next/c/2db60eed1a95
  - [net-next,3/4] net: add skb_defer_max sysctl
    https://git.kernel.org/netdev/net-next/c/39564c3fdc66
  - [net-next,4/4] net: call skb_defer_free_flush() before each napi_poll()
    https://git.kernel.org/netdev/net-next/c/909876500251

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


