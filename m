Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF713FC672
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbhHaLLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241409AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D75E6103D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=LYHy/lUp5K5gHgvInb57Fvkzp4v3OFwazV2Gm93KYlE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h5oB+p7iOpJuJrGStEunBg4wXBAdzMMngc/c1A/CxqfoPfvBHCBTjebbNBWm2n1vy
         PzFUqtijarnVFrE9DPxG0odOGi6nPWABiPOivMDuDJjEH3zAHSLZwbcvtNO4kMW8fY
         ZFvMSuFvjrw2mw/nU8mJsoh9l5hzLc0KhHIvNl0h3nA8PCxI+VwVm3fYgqzXvScoAB
         PLVeAWqJPxl/yN2RpMi/cZXtszbMg/wKAYahHWDvVp7vTWpXeH9etYnzXFTxrL19P6
         CBg8PDP0Dq485ji0a10H74Qf7lpp3Mybutn0gQUqZ3l+qQUDOgvfb0woE907kIZQQH
         DAPT94clbH6Xw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 38B7360A7D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: fix endianness issue in
 inet_rtm_getroute_build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820822.5377.11850488138228247317.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210831020210.726942-1-eric.dumazet@gmail.com>
In-Reply-To: <20210831020210.726942-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, roopa@nvidia.com, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 19:02:10 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> The UDP length field should be in network order.
> This removes the following sparse error:
> 
> net/ipv4/route.c:3173:27: warning: incorrect type in assignment (different base types)
> net/ipv4/route.c:3173:27:    expected restricted __be16 [usertype] len
> net/ipv4/route.c:3173:27:    got unsigned long
> 
> [...]

Here is the summary with links:
  - [net] ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
    https://git.kernel.org/netdev/net-next/c/92548b0ee220

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


