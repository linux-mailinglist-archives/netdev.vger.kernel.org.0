Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2243B37E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhJZOCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhJZOCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B211961039;
        Tue, 26 Oct 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635256807;
        bh=cMe+A8LmcSXMa+6+rAfp9vb8N8W8Pt3ULAGEWRb83Hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L5jBFar6f/bBwO7Y5QBtlNzvUgslewF7p+vEDZh196ZMWcQKNDDrdaM4+sTyn2klf
         hwkfVnPeBkqRIg3d375vdcEvzR95hdAjMryz+KmiaM53oB8+IgxltK7xD4Djt7tV8+
         Nz/6Za5BLrxZMSAKKgMncdYDYmMhlGDEsKpLeSQAcrgGFtTFxNoinVfryhkL2FWNz7
         8qDSbtPibM92jD7P9J4zUMybPaIclRe1y2jaaoVu7nzvc4H3q61g4N/Lv/PmzK35k6
         29syIk/5gRCxIJF2rhA1joANnplXzJSLBw1U69NLpJ5jW+OWAwFKyI2xrvEHYZOD3w
         2MdJcxpJHW8pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F468609CC;
        Tue, 26 Oct 2021 14:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tcp: tcp_stream_alloc_skb() changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525680764.8133.17704269460480489294.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:00:07 +0000
References: <20211025221342.806029-1-eric.dumazet@gmail.com>
In-Reply-To: <20211025221342.806029-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        soheil@google.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 15:13:39 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sk_stream_alloc_skb() is only used by TCP.
> 
> Rename it to tcp_stream_alloc_skb() and apply small
> optimizations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tcp: rename sk_stream_alloc_skb
    https://git.kernel.org/netdev/net-next/c/f8dd3b8d7020
  - [net-next,2/3] tcp: use MAX_TCP_HEADER in tcp_stream_alloc_skb
    https://git.kernel.org/netdev/net-next/c/8a794df69300
  - [net-next,3/3] tcp: remove unneeded code from tcp_stream_alloc_skb()
    https://git.kernel.org/netdev/net-next/c/c4322884ed21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


