Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78723C19D0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhGHTct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHTcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 15:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D02C06161F;
        Thu,  8 Jul 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625772603;
        bh=SWoxXU0iy/TzzQ1pwxyT82jQi+29J/oWDyMPH4cFMKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uHokGR6Y9Db0WE5q8kAqapLmhkfYNR5E6bgZnvVRbzvGxd1kgigBuIcsgz6o/uune
         ry82xqemydsKSEkmCts6Y+TzPIkeeu12jpZgY0iWO/yPZocleVNVEIFl7nJnIbbFEo
         ZoT37MhA6dCwaaOpiBpPtwHXKPtxYKTPsG4jhfTypcEWmhCDQ7fo1I+Pz5Le6qx+9C
         1XhOICfAzf4BuAsU2vsLdMtgWPFvpC+bgDxaBqswtQqDvl9LDPARK6/VYg9GhDl1zp
         tFc0w7hUF612xynt8DSkah5GWu8TgN/u1l6F+m7YWzEURuIYkiMT08pZ39j+56OaA6
         tz4Y8m0otzB7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C34DA609E6;
        Thu,  8 Jul 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577260379.7578.8193016598326598928.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 19:30:03 +0000
References: <20210708072109.1241563-1-eric.dumazet@gmail.com>
In-Reply-To: <20210708072109.1241563-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, maze@google.com, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 00:21:09 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While TCP stack scales reasonably well, there is still one part that
> can be used to DDOS it.
> 
> IPv6 Packet too big messages have to lookup/insert a new route,
> and if abused by attackers, can easily put hosts under high stress,
> with many cpus contending on a spinlock while one is stuck in fib6_run_gc()
> 
> [...]

Here is the summary with links:
  - [v3,net] ipv6: tcp: drop silly ICMPv6 packet too big messages
    https://git.kernel.org/netdev/net/c/c7bb4b89033b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


