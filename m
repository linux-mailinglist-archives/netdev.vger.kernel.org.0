Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D402834C0AE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhC2AuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhC2AuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 145CA6193F;
        Mon, 29 Mar 2021 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979009;
        bh=l1YSZkVfTzfw5T2L7OVwWLP20vixe1eM1sNQ8ZwHx1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jLHriujjjRPhG4pSMKKE6PqvyPvtMZ3vSBq1Zx+9rGoe3x5aeeUhHqhHY8yddrj4Y
         Rfze5TZL9t+wMtOnOVHolsqIG6Kdw8SlCLB4d0jadFYY9iOaNYe5SFIzJt4DtA4jHX
         dNPDoVP+MuvUt1/i2by0LB2sTBEaGZZhCH8dnEVPBCCH/MfzpwRT/CG7VRedAAGEM9
         B6NZ3XyFoqOaiwsNqiR/Y6fJdwLFhxrAtOMwrI43QjvKdqpgqcpU5SF0TehKiVYjp5
         UmaRgndvB0AaArUX73VsI+FlaIuiHIMHH8eaIJF2Mk3092rj+BuchlS9izuaWOe5DK
         5Qzeq7fGNjR+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01566609E8;
        Mon, 29 Mar 2021 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] selftest: add tests for packet per second
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697900900.26284.9668588336141485230.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:50:09 +0000
References: <20210326130938.15814-1-simon.horman@netronome.com>
In-Reply-To: <20210326130938.15814-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        idosch@idosch.org, baowen.zheng@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 14:09:36 +0100 you wrote:
> Add self tests for the recently added packet per second rate limiting
> feature of the TC policer action[1].
> 
> The forwarding selftest (patch 2/2) depends on iproute2 support
> for packet per second rate limiting, which has been posted separately[2]
> 
> [1] [PATCH v3 net-next 0/3] net/sched: act_police: add support for packet-per-second policing
>     https://lore.kernel.org/netdev/20210312140831.23346-1-simon.horman@netronome.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] selftests: tc-testing: add action police selftest for packets per second
    https://git.kernel.org/netdev/net-next/c/c127ffa23e41
  - [net-next,2/2] selftests: forwarding: Add tc-police tests for packets per second
    https://git.kernel.org/netdev/net-next/c/53b61f29367d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


