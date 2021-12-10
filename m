Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A63F47057C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbhLJQXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240836AbhLJQXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:23:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B51C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29445CE2C1C
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 16:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5555FC341C5;
        Fri, 10 Dec 2021 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639153211;
        bh=6wGXHxmlnR2c5HyauYvgkmt/V08ydvbo9k3RFKwcCTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ya3lUk6D6uIByWzlb5ybhEzTp0Gn+U1Yp2CVflmaDOjckoQvaml8TnNNQTgINC3pL
         PWjHooYhFTfUkq5P4ljhuM0aZm47hA55k00Xw5nDMSynZb/Fx8yrIcD8RLKC8yOEV8
         0A56RvlGfG6qFiu27RinU4mau+mt6+NK8DJBaL0Q0gGsfbNQSWnqYE/NYqTHGLyha7
         o5Pi2L180DU45XE4mRevu1NozPWNCk1qou6e5M/F4intBr4Do6YTl5p4u0ULNJm3cO
         Ir+TUF5zKS6BJh1xqBIiOVpxYr6QfuKMSDGgAAv5X4ab4gGF1sdKvJur0wP18qQGT1
         pQh1lYUIin+9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 44E6D609EB;
        Fri, 10 Dec 2021 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/6] net: netns refcount tracking, base series
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163915321127.27071.4076281454394335852.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 16:20:11 +0000
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 23:44:20 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We have 100+ syzbot reports about netns being dismantled too soon,
> still unresolved as of today.
> 
> We think a missing get_net() or an extra put_net() is the root cause.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/6] net: add networking namespace refcount tracker
    https://git.kernel.org/netdev/net-next/c/9ba74e6c9e9d
  - [V2,net-next,2/6] net: add netns refcount tracker to struct sock
    https://git.kernel.org/netdev/net-next/c/ffa84b5ffb37
  - [V2,net-next,3/6] net: add netns refcount tracker to struct seq_net_private
    https://git.kernel.org/netdev/net-next/c/04a931e58d19
  - [V2,net-next,4/6] net: sched: add netns refcount tracker to struct tcf_exts
    https://git.kernel.org/netdev/net-next/c/dbdcda634ce3
  - [V2,net-next,5/6] l2tp: add netns refcount tracker to l2tp_dfs_seq_data
    https://git.kernel.org/netdev/net-next/c/285ec2fef4b8
  - [V2,net-next,6/6] ppp: add netns refcount tracker
    https://git.kernel.org/netdev/net-next/c/11b311a867b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


