Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9BE6BE40D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjCQImu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjCQIm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:42:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FE4E190E
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C8EB824F6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DDE6C433D2;
        Fri, 17 Mar 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679042419;
        bh=frvmTSb14m6SVkFRADd8+ikQrv87JK8Zx7mFCdIR9mw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q9y6+gJrSWwrSIcjGMgVoESLUwqeunVjw3CWKido2v89My81k+KIWyK8QSYuy7jFp
         aPs26x1vkYnrVrfwNTBp1UdQJnt0KEJcXtO9GHqcU8LFVYXc5px+R26z7ugnFN8gUq
         pNRmpCFhiRHBXLlvgZ5+h7ZP1YCO6USQmGWhDRqBiVfIBBAg5Czr/Y0+anfmWTpXkj
         Ud9T5nUPeAkixguQnP1mnuw+FYrQ3syPwJqoAT19oHid7v+p6/Z9uCV9hnvlXmZDhr
         hO/Lz01gDGPYkcL76S32wHnaLMKAa2Ghk7pLjOrRM4EOenD3lGqaXB6q9DPw8jLeE6
         A9SZRkXnvqtYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FCAFE21EE6;
        Fri, 17 Mar 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: annotate lockless accesses to sk_err[_soft]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904241938.20100.14101309756167452055.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:40:19 +0000
References: <20230315205746.3801038-1-edumazet@google.com>
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 20:57:40 +0000 you wrote:
> This patch series is inspired by yet another syzbot report.
> 
> Most poll() handlers are lockless and read sk->sk_err
> while other cpus can change it.
> 
> Add READ_ONCE/WRITE_ONCE() to major/usual offenders.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] tcp: annotate lockless accesses to sk->sk_err_soft
    https://git.kernel.org/netdev/net-next/c/cee1af825d65
  - [net-next,2/6] dccp: annotate lockless accesses to sk->sk_err_soft
    https://git.kernel.org/netdev/net-next/c/9a25f0cb0d7e
  - [net-next,3/6] net: annotate lockless accesses to sk->sk_err_soft
    https://git.kernel.org/netdev/net-next/c/2f2d9972affa
  - [net-next,4/6] tcp: annotate lockless access to sk->sk_err
    https://git.kernel.org/netdev/net-next/c/e13ec3da05d1
  - [net-next,5/6] mptcp: annotate lockless accesses to sk->sk_err
    https://git.kernel.org/netdev/net-next/c/9ae8e5ad99b8
  - [net-next,6/6] af_unix: annotate lockless accesses to sk->sk_err
    https://git.kernel.org/netdev/net-next/c/cc04410af7de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


