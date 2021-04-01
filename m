Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3CF352366
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhDAXUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235912AbhDAXUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DA61A61153;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=MG5dO0j4BU/FGn2S970gXVwHPFpUqaV/64qbjgzRfXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CD7ykvNWfAjwlxBPcRNhpEk8QqrOvDhNGjN7J8JpL2dsUBJSvGnJ7Pc9s7YjuT1j2
         5ZYTBXIHcPQ/lMF21ZkKrDmWb+PIyevyVyhR8xmbKsU1dwqSItDnBEkBSqRjS0IwOV
         oJijpq1P/RvrBeHSnctGX4S5Wmp4E/FoCZ7GjPpLrWp9U4JIXOwo4MIK2E1BMUeLmP
         yNtXXq54787S9ycm5h0uY0rNgiqwGQkEnGiQqMdJdIfGXb9j/DsIOStYN4B4AFsPiU
         qXc5MzsnVUd5o/vLIYjiXugUbFlGDY7gFgtrEZLnS8IrPdqNmg6qz1mKHL1wazhQz1
         5mG+Bomjj9tuw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD3D6609D3;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: document a side effect of
 ip_local_reserved_ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920983.16404.61942789615445016.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401155704.35341-1-otto.hollmann@suse.com>
In-Reply-To: <20210401155704.35341-1-otto.hollmann@suse.com>
To:     Otto Hollmann <otto.hollmann@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, dsahern@kernel.org,
        mkubecek@suse.cz, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 17:57:05 +0200 you wrote:
> If there is overlapp between ip_local_port_range and ip_local_reserved_ports with a huge reserved block, it will affect probability of selecting ephemeral ports, see file net/ipv4/inet_hashtables.c:723
> 
>     int __inet_hash_connect(
>     ...
>             for (i = 0; i < remaining; i += 2, port += 2) {
>                     if (unlikely(port >= high))
>                             port -= remaining;
>                     if (inet_is_local_reserved_port(net, port))
>                             continue;
> 
> [...]

Here is the summary with links:
  - [net-next] net: document a side effect of ip_local_reserved_ports
    https://git.kernel.org/netdev/net-next/c/a7a80b17c750

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


