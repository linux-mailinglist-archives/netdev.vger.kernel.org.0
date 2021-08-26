Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286063F8490
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbhHZJbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241112AbhHZJa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 05:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A5346610C9;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629970206;
        bh=eCaIeOtnaMDMs70PFG3hI5otTZvCFJsFQB37iSnmNmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HXe4boagblmont4TaYsRP29bcxpckTvhSdUCYHKSJcIV3EjIvH6jy7kNKDJ6SZT82
         uClRzdQwgJzKsSOqboqUudJJX6YwCZynwxbR5mFMvm+aS5ssoXIOZjuZoWY4J6Kedk
         fidINiEB7sTBLYz03fI2kyEJyQiCgHjzV6I2iv/cLOGjNHJprvQSFBdHyoZMf6PaZA
         XG9MuPG1fmdFU0T2bdP5nwomjDHkT4/P6hwwBGbstuLJ6uahgjteZ9tZUmsxY/RvM/
         +iIiJ3rR8xzxhJNZpOzf/JhuNyyyri1EK6HLk4yijd24wjYYHx+Lx5fYwFxB7Qv1Ok
         8hXRwmFCTCfMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96DA060A12;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] inet: use siphash in exception handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997020661.28182.14261277414825954591.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 09:30:06 +0000
References: <20210825231729.401676-1-eric.dumazet@gmail.com>
In-Reply-To: <20210825231729.401676-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, w@1wt.eu, kman001@ucr.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 16:17:27 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> A group of security researchers brought to our attention
> the weakness of hash functions used in rt6_exception_hash()
> and fnhe_hashfun()
> 
> I made two distinct patches to help backports, since IPv6
> part was added in 4.15
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv6: use siphash in rt6_exception_hash()
    https://git.kernel.org/netdev/net/c/4785305c05b2
  - [net,2/2] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
    https://git.kernel.org/netdev/net/c/6457378fe796

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


