Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98935A78B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhDIUAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234538AbhDIUAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 16:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C440A61041;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617998437;
        bh=2wn6MREVOWxkC7v8x75F2gDBUjLldnsuzghttmY3Jyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l3xrENSzOBSHI6W2y3pwmdJ14M67Bpg1P0ql0iZKZVQjHLg5JCntSvUnyqM24P0n9
         HCbxZsvK40al3n4kGXxsTb1OsezBLztGZDIpVqEP9LzVb+34wCajG9akOrhZ7XxjZg
         rHotrZSf5GZ9VPXJca0VVxnTR890WpLnfLylx5CxlQ0a4AFDUoXV96D8/a/yvZfReS
         clL6RDohx8i7Fyep21YCr9A98jnUp0+pC1Q5CBocAsJLqdkDJQUjuTO+jZBJvEYAYA
         jl8+BesYStvUF3GB/3Ph4RWIn28bbES3CQxtSwmynYkdNHmQK5K/sNdpdSlUbe4hs7
         tvAssJII6SO+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B2D0460BE6;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: fix hangup on napi_disable for threaded napi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161799843772.9153.8373343864301541587.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Apr 2021 20:00:37 +0000
References: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
In-Reply-To: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, weiwan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Apr 2021 17:24:17 +0200 you wrote:
> napi_disable() is subject to an hangup, when the threaded
> mode is enabled and the napi is under heavy traffic.
> 
> If the relevant napi has been scheduled and the napi_disable()
> kicks in before the next napi_threaded_wait() completes - so
> that the latter quits due to the napi_disable_pending() condition,
> the existing code leaves the NAPI_STATE_SCHED bit set and the
> napi_disable() loop waiting for such bit will hang.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: fix hangup on napi_disable for threaded napi
    https://git.kernel.org/netdev/net/c/27f0ad71699d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


