Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08775362C49
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhDQAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234764AbhDQAKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA2F2610A6;
        Sat, 17 Apr 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618618209;
        bh=Ok/i+k2MBRSuOHaAtLQbigyPVzfFhE82N/tLZGICACA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N5Qy34BMj5BGeGx1PMauB5Pp6gacQZ84TVib+CMLZ7h69ZoqszJIRF3lFankM1t8G
         64oWXkvI2bkwlRRWqemvrhzJhQ2wi8ER2DR1XN/Ra3O4Ym0Kp38OFYktJ2Um6RnSKA
         /1rkCWNESfcCcGV2Lch6HdbM5VsSGsK3ZNxGbU3qf8Iff0W8wTJWgjATELod6E+j8s
         bFbWbJ8IVm7bCcatmKFuF7t8ltbYhEAjXjGgc2vEiAR60x/zpeRrmxJ6/dVABJClPd
         6k0SzMtg3OhC6+vTiEevP5yfUVcKkJlLpC5fMJumf4QmMftv6054c6c6z48eqOUCZ2
         XHaE1dwBerbsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DEF3F60CD4;
        Sat, 17 Apr 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: don't call ->netlink_bind with table lock held
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861820890.31087.4989302514771758966.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:10:08 +0000
References: <20210416192913.6139-1-fw@strlen.de>
In-Reply-To: <20210416192913.6139-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        lucien.xin@gmail.com, johannes.berg@intel.com,
        stranche@codeaurora.org, pabeni@redhat.com, pablo@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 16 Apr 2021 21:29:13 +0200 you wrote:
> When I added support to allow generic netlink multicast groups to be
> restricted to subscribers with CAP_NET_ADMIN I was unaware that a
> genl_bind implementation already existed in the past.
> 
> It was reverted due to ABBA deadlock:
> 
> 1. ->netlink_bind gets called with the table lock held.
> 2. genetlink bind callback is invoked, it grabs the genl lock.
> 
> [...]

Here is the summary with links:
  - [net] netlink: don't call ->netlink_bind with table lock held
    https://git.kernel.org/netdev/net/c/f2764bd4f6a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


