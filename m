Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C71F301387
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 07:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbhAWGLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 01:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbhAWGLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 01:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C82F323B04;
        Sat, 23 Jan 2021 06:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611382223;
        bh=RLniG/uSEgA9JDMZQQgxTdmy5OF9U0bKuTK/444Kdr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SzmL/WTK8DCBoN3WK/6NGjS09NiOJsaodQRiPyjVP3x+s9PM73xygaoJKzGgnpWo2
         uxsh9er82uWiDKLXUXHMWvbMQg3s9asMsYsJP3l0pdXwfPZGQ9agnBcsJ6/CIGSdhF
         0ZONCQDu8toDcQOyNgAvGkAgWeHKs9LfRiMMkQE7C4+fM+YJSWIOjnaCaKuFcuQCbF
         gtsb006BFE2WxDKYylLSXiALq7foo966Wu6iVix71a3Hjca/7jTkmFdH5AsX3FyZig
         RFSKR25L0UDbPAGjLpyHImp59RD0S2qeVL/zmXAMa04zZ0EB/8UJZ8tk/M7Y34Zfwj
         etNPW4BjA2xIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA11D652E0;
        Sat, 23 Jan 2021 06:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] HTB offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161138222368.25900.11180760224277767499.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 06:10:23 +0000
References: <20210119120815.463334-1-maximmi@mellanox.com>
In-Reply-To: <20210119120815.463334-1-maximmi@mellanox.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dsahern@gmail.com, saeedm@nvidia.com,
        kuba@kernel.org, tariqt@nvidia.com, yossiku@nvidia.com,
        maximmi@nvidia.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 14:08:10 +0200 you wrote:
> This series adds support for HTB offload to the HTB qdisc, and adds
> usage to mlx5 driver.
> 
> The previous RFCs are available at [1], [2].
> 
> The feature is intended to solve the performance bottleneck caused by
> the single lock of the HTB qdisc, which prevents it from scaling well.
> The HTB algorithm itself is offloaded to the device, eliminating the
> need to take the root lock of HTB on every packet. Classification part
> is done in clsact (still in software) to avoid acquiring the lock, which
> imposes a limitation that filters can target only leaf classes.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] net: sched: Add multi-queue support to sch_tree_lock
    https://git.kernel.org/netdev/net-next/c/ca1e4ab19993
  - [net-next,v4,2/5] net: sched: Add extack to Qdisc_class_ops.delete
    https://git.kernel.org/netdev/net-next/c/4dd78a73738a
  - [net-next,v4,3/5] sch_htb: Hierarchical QoS hardware offload
    https://git.kernel.org/netdev/net-next/c/d03b195b5aa0
  - [net-next,v4,4/5] sch_htb: Stats for offloaded HTB
    https://git.kernel.org/netdev/net-next/c/83271586249c
  - [net-next,v4,5/5] net/mlx5e: Support HTB offload
    https://git.kernel.org/netdev/net-next/c/214baf22870c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


