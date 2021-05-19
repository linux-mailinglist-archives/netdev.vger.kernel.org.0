Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C053897C7
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhESUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhESUVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6095B613AF;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455615;
        bh=ZkxFLfa6p1hJdfcaMf1oaRxUNaMKJOKZN6gvld7n1W8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RnE5g4j3qtirGCiaEXUl0uOgzoioHIb0+elMAYMJ4b6NGgdOj91j27/4BaM/DzUGa
         QMwkHv40TB9VJjxkoy14We2CYa0u3Nd9mSIMtOJgCLQw1GqdaBUh1ljsS8mYTlTbtj
         StNoxVAt0LN1ucvDzuAlt2SHjSXfbJ4cpaDfuh9/F5ZhpNDANeQqk//8LOIdeD0rDE
         DQpTcGP/dzxnXw/TRdDrYOmvReFq3YmaG+P+LpjNhelhhyVLqrAE6vFuyjqgp2yj2M
         tIBjjAxIanVK1apKgSuhQ1PqhQnp3X0r6/pVV6QHmqGOp4usdU/WCABUuaGoEkhq/y
         mok/l+Q4GQvmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 572E760CD8;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: cls_api: increase max_reclassify_loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145561535.14289.10376734832915124466.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:20:15 +0000
References: <3ab4c68503a3e3e1b4f11a0c0900b872cfc806f6.1621426820.git.dcaratti@redhat.com>
In-Reply-To: <3ab4c68503a3e3e1b4f11a0c0900b872cfc806f6.1621426820.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 15:17:21 +0200 you wrote:
> modern userspace applications, like OVN, can configure the TC datapath to
> "recirculate" packets several times. If more than 4 "recirculation" rules
> are configured, packets can be dropped by __tcf_classify().
> Changing the maximum number of reclassifications (from 4 to 16) should be
> sufficient to prevent drops in most use cases, and guard against loops at
> the same time.
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: cls_api: increase max_reclassify_loop
    https://git.kernel.org/netdev/net-next/c/05ff8435e505

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


