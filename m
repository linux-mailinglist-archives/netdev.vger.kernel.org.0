Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6282EFD77
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAIDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbhAIDat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E063923A1E;
        Sat,  9 Jan 2021 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610163008;
        bh=TXqyEM8oDGXwZcnl9+7r3z6pesYlQjJPspHps3s3DNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aWBeVAWLaLncbrxH19CXAR6X7iPOZSzqDYZVoGZVZl+jlRXsTvEAtuyhv/52gkM/y
         RTO8zQ/G8J0dkWNvIZK3ZBE9j7g0V0kBynUVZJFpoWPAG5TQqCpjm5nZOzukX1GBw2
         ehX1P284DOa6Al7sRO4Rrvnv+oekKeP/BkM37BImsRm8JPsbqD9THjhUnozfLqDXWW
         ZQ41+NcNAnFyEM0MN4YsJCCqGRJw859QpqvA+9iHJTkCQElQ15hFD3xAtlGYHIGnRU
         5+kuo+rvqojV0SFlBdqTeKcdMex348jDY1QKMy+KUqA3n3pjcNc/aFrk9z/Bb+JAvg
         F+SNpy/LIVikg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id CFAD0605AC;
        Sat,  9 Jan 2021 03:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ip_tunnel: clean up endianness conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161016300884.29520.17441189282427166681.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 03:30:08 +0000
References: <20210107144008.25777-1-jwi@linux.ibm.com>
In-Reply-To: <20210107144008.25777-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  7 Jan 2021 15:40:08 +0100 you wrote:
> sparse complains about some harmless endianness issues:
> 
> > net/ipv4/ip_tunnel_core.c:225:43: warning: cast to restricted __be16
> > net/ipv4/ip_tunnel_core.c:225:43: warning: incorrect type in initializer (different base types)
> > net/ipv4/ip_tunnel_core.c:225:43:    expected restricted __be16 [usertype] mtu
> > net/ipv4/ip_tunnel_core.c:225:43:    got unsigned short [usertype]
> 
> [...]

Here is the summary with links:
  - [net-next] net: ip_tunnel: clean up endianness conversions
    https://git.kernel.org/netdev/net-next/c/fda4fde297f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


