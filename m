Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2188232A2BF
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381695AbhCBIbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234234AbhCAX4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 18:56:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CCF3660C3E;
        Mon,  1 Mar 2021 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614642877;
        bh=TDVGPA4/VQlsBMM2ORdo3mXgZR1oJDxG3Rj2nuvGLiA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AeowQ4KGJvcBG+k0xMDH9cqU8oYpfpg05fnWcFQxvREQkEIK2A24aIF7sqYjf0BvI
         MK+KP4FNhyGoZkWoHf8MKGdaCM2eCThcAYS1Qpjutaq4dyn6qPcjuACgM0j9dVYvi3
         vA0PTwPy17Ve0ZoMdthIdQyFP4Dyygw3DEkYUW+fliGzM4q4XkIYphuG2hYCuUQR+T
         pbuXBUUY5BIj2qTGfKFjNuEdfth3ceZUoXJ4XDlA1diF2FkDuBnIlSYm0VFp1Yy1zK
         Em6hGvlSN82GYyJbiSsgP7Yblg2U0GoNOhvPJ2aszMKWkUi3oQVIYGgu106muURAd+
         6qxdaABkZOKwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE2D760C1E;
        Mon,  1 Mar 2021 23:54:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: add sanity tests to TCP_QUEUE_SEQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161464287777.7970.13569736904528253009.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 23:54:37 +0000
References: <20210301182917.1844037-1-eric.dumazet@gmail.com>
In-Reply-To: <20210301182917.1844037-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, xemul@parallels.com, ieatmuttonchuan@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 10:29:17 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Qingyu Li reported a syzkaller bug where the repro
> changes RCV SEQ _after_ restoring data in the receive queue.
> 
> mprotect(0x4aa000, 12288, PROT_READ)    = 0
> mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
> mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
> mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
> socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
> setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
> setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
> sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
> setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
> setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
> recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)
> 
> [...]

Here is the summary with links:
  - [net] tcp: add sanity tests to TCP_QUEUE_SEQ
    https://git.kernel.org/netdev/net/c/8811f4a9836e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


