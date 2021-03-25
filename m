Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470BA3485D0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbhCYAUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239207AbhCYAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9BBB61A23;
        Thu, 25 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616631609;
        bh=MwvulSdRtLOJtoPf1hmymuTcLsOBq+DisjedWCQQfzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jKnBKB4f1POWP8TREoIlTe0LQ7lVRiaoj41Bg9bctHxpkXn/PRJ+ufVm0CfX/TSWq
         P+SdLH7hUKUoMh16xfcTTwgVyO0rIXOsCvTB3ivFwcqBaL7Nw+rxlb5eaHo5iFoZEV
         t/IAVXJuuQUzOvIAUZdovP9SkOZcBiv/xf+XPBxrP/DVmOpc+ia3wrCHEm+sRVBRS2
         fedEW6TDmDr9jWrmdrSQMdOF5DcGgPI/VQ0wKPwEJX9dkr57oNwBx9wslnKazo6cmC
         tjSX5nXQKMZTnKcSCxAJ9lFIYS1gu1g+hcHkSL2Iq1dHCdYBU8Z4KrggXZT1ahP0mH
         eJY5GVhAXkgxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D267D60C27;
        Thu, 25 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp_metrics: tcpm_hash_bucket is strictly local
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663160985.5502.2362631031254157030.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 00:20:09 +0000
References: <20210324220138.3280384-1-eric.dumazet@gmail.com>
In-Reply-To: <20210324220138.3280384-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 15:01:38 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After commit 098a697b497e ("tcp_metrics: Use a single hash table
> for all network namespaces."), tcpm_hash_bucket is local to
> net/ipv4/tcp_metrics.c
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp_metrics: tcpm_hash_bucket is strictly local
    https://git.kernel.org/netdev/net-next/c/d1c5688087a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


