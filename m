Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C013662BC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhDUAAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhDUAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0813261423;
        Wed, 21 Apr 2021 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963211;
        bh=PBeYqStowQVwignopWPr3A2fo4c5glaNTyaDJqE3uJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g/I3dw5GMvAnexx7Jjad9wKhjEMvH2CmqWJAfp46w7dRawrDwekNhfNN45reU/jvo
         xNtqyr4IGyVuta30kNQaLr+TP5zf6VCWDLlr9YGzA8FzWEeg/Z4bo/jnOR7sxgbIZr
         bkTMbE0i36k3WUOkML3XSeGwB9T/zAfL2VROH1Ns05ucK1LkFNHH0HtGSkO2cfVjfg
         /XiuUrgsFjYWkAVT6JTpB5/r+OJNsxbyJFL/kw0TRUj9wgiKzAECj812gzWm8aiwK1
         3ttSibv8RFffrgPyQO5c6UaBT2XHu7DNH+u4FQNbLeLTsWYsgxoH6DOOrJiIIoaDfR
         I7PodidSfkzcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 022FD60A3C;
        Wed, 21 Apr 2021 00:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio-net: restrict build_skb() use to some arches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896321100.2554.2855560777126908523.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:00:11 +0000
References: <20210420200144.4189597-1-eric.dumazet@gmail.com>
In-Reply-To: <20210420200144.4189597-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, linux@roeck-us.net,
        xuanzhuo@linux.alibaba.com, jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 13:01:44 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> build_skb() is supposed to be followed by
> skb_reserve(skb, NET_IP_ALIGN), so that IP headers are word-aligned.
> (Best practice is to reserve NET_IP_ALIGN+NET_SKB_PAD, but the NET_SKB_PAD
> part is only a performance optimization if tunnel encaps are added.)
> 
> [...]

Here is the summary with links:
  - [net-next] virtio-net: restrict build_skb() use to some arches
    https://git.kernel.org/netdev/net-next/c/f5d7872a8b8a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


