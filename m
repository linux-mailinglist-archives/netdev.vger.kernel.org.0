Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A199396CB9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhFAFWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232635AbhFAFWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DF2E61376;
        Tue,  1 Jun 2021 05:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524805;
        bh=3mRFCANUC8Pzollbo28QfaNnYdZ9zliC79euuilBPgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WcPW1aq7QdZ8iMhg4NnVvX75JHh0Cppg7H9whqwtGvqRoeLf4IXuYDQOJ9uJxB2Ix
         l7Z7ieI1nMeJgo+b6EGz4ztA1h3+ucAjAxHd1xDiWZvRfxURBYbfeatr96jfBT7R8B
         9n/H8x9NrDHsm6zIB61kzNgb3uF/QdtiXYE75Ihp8hhgKJFG+ODc1+anuFWB7/QTEP
         ytbb9xD0ux+9gGhXdHzo4XXaK1puB/njuPCu7hogEdT+c/06+4hO5tUBV3BJI2L8tB
         UdHZNnTiKxMGqoOxWW2DgT55PVq48MjC+e6ciZ5SrzJ5Tf1XEE01PThUvflyLq1ASm
         1ikfnEUBKyQcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12A4360ACA;
        Tue,  1 Jun 2021 05:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: use prandom_u32() for ID generation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252480507.23898.17168292577434341829.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:20:05 +0000
References: <20210529110746.6796-1-w@1wt.eu>
In-Reply-To: <20210529110746.6796-1-w@1wt.eu>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, aksecurity@gmail.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 29 May 2021 13:07:46 +0200 you wrote:
> This is a complement to commit aa6dd211e4b1 ("inet: use bigger hash
> table for IP ID generation"), but focusing on some specific aspects
> of IPv6.
> 
> Contary to IPv4, IPv6 only uses packet IDs with fragments, and with a
> minimum MTU of 1280, it's much less easy to force a remote peer to
> produce many fragments to explore its ID sequence. In addition packet
> IDs are 32-bit in IPv6, which further complicates their analysis. On
> the other hand, it is often easier to choose among plenty of possible
> source addresses and partially work around the bigger hash table the
> commit above permits, which leaves IPv6 partially exposed to some
> possibilities of remote analysis at the risk of weakening some
> protocols like DNS if some IDs can be predicted with a good enough
> probability.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: use prandom_u32() for ID generation
    https://git.kernel.org/netdev/net-next/c/62f20e068ccc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


