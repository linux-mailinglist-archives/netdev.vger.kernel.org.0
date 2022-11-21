Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E42632333
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiKUNKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiKUNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60351CDC
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F49AB8101D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9018C43144;
        Mon, 21 Nov 2022 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669036216;
        bh=PeP3TZPdTsuG6PiKCnUbqP4ghsMRgakiQZUyJgo/DIQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tSQhqoAV97VMd6AACUc6BeU4jb6K03+lSJgiuxOBLG01Hc7/Ms0NWfvP1IW4StQm8
         OhS4dqBUl+mYossMljj1HSBhyRTDCkuXRQDExrp1yyA6FJ/XEmUycBXct1fRVHTzzt
         CI7JD+A8zkgfqDylKOOac8xElzW77BsAAjY2N2A7KEe2SOi0U93tjHPFqsRgXVKKRg
         sd9yjJM9+Zzii982yeYPTtREOSoPmqmvM6zXeoPbbyDTEDcXJi6ArEZHsMwwG3+mD8
         oOPf5/cZnocVCWk3HhSYlEMPRq6meju0FtXCpAEGBpxeSWx4GCcl42QPaFU6U9PEHC
         QD9F300zPaMGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0585C395FF;
        Mon, 21 Nov 2022 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: Return errno in sk->sk_prot->get_port().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903621671.4573.8029560604179811568.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 13:10:16 +0000
References: <20221118182506.6226-1-kuniyu@amazon.com>
In-Reply-To: <20221118182506.6226-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        cpaasch@apple.com, fw@strlen.de, peter.krystad@linux.intel.com,
        kuni1840@gmail.com, netdev@vger.kernel.org, mptcp@lists.linux.dev
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Nov 2022 10:25:06 -0800 you wrote:
> We assume the correct errno is -EADDRINUSE when sk->sk_prot->get_port()
> fails, so some ->get_port() functions return just 1 on failure and the
> callers return -EADDRINUSE instead.
> 
> However, mptcp_get_port() can return -EINVAL.  Let's not ignore the error.
> 
> Note the only exception is inet_autobind(), all of whose callers return
> -EAGAIN instead.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: Return errno in sk->sk_prot->get_port().
    https://git.kernel.org/netdev/net-next/c/7a7160edf1bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


