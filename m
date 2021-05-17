Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8C3386C02
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhEQVL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239173AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AAB761244;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285810;
        bh=9DBBR+jnk6kTbF9EBf1wcsqycS4oFanJSitPhm730+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V49aABLSBIcj588wKvtiiv7TsjRUPl438vcBcufZF+olppDz7kBaU+lEh4Z1qKkjt
         Io4801TfnzRucqwxtScfJC1QRyipBAE5PpbctQPkJaDI8Ktart7NfWIykgrR73OqoS
         vKpGysIYqHmpCcgLUVAu8awEk31q3QrKTk43w4BTQDt1uVeGx+qrAW8tscFOpJ2Sja
         Zxg5Qakt0xELfAOPsPP1R8jVchV6HmdSXefeObQjR7UaOAObvXHCXBMVYkYpJE3yaq
         6YyxixspXK5SLKbTEWxWgL36mIrgr0fHcnE8aEHZpFgiu7JsJ0k3GFDyyBkrEZ6VxQ
         cVfL4CKeoDxGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8ED3560BFB;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] mld: fix panic in mld_newpack()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581058.6429.8672257443892549784.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <20210516144442.4838-1-ap420073@gmail.com>
In-Reply-To: <20210516144442.4838-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 16 May 2021 14:44:42 +0000 you wrote:
> mld_newpack() doesn't allow to allocate high order page,
> only order-0 allocation is allowed.
> If headroom size is too large, a kernel panic could occur in skb_put().
> 
> Test commands:
>     ip netns del A
>     ip netns del B
>     ip netns add A
>     ip netns add B
>     ip link add veth0 type veth peer name veth1
>     ip link set veth0 netns A
>     ip link set veth1 netns B
> 
> [...]

Here is the summary with links:
  - [v2,net] mld: fix panic in mld_newpack()
    https://git.kernel.org/netdev/net/c/020ef930b826

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


