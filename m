Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D6631452C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBIBAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBIBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 654F564E9C;
        Tue,  9 Feb 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612832408;
        bh=SqCmp/Hab7eXk2nmS+mhs6dkadzjIFiRTf5EbWqGk+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSGJ0Hrd2MB8biVigQJQ37esNgw8Np4T2Oyod4WuEGmB1y2pYOfrRN9cCD3L/Rq4I
         U2UEXdRF3GuDDwkfH3gTxXq4Ds7pUMEI411wZ3PtQmwq9elYer+NL4Dv4kCG7tNlWD
         EMcULzb7I56ckUKXPxmYXwHj+t6gz1xiSWFpSe7+ILNMj7ZCFdbZe/fy0qA2B1ykXg
         eNUsS/YQ95y1CCOgJXEGRpZVNwmL3a2LoBXDkOeylyEI1MxY9yr+EsSIEoQLF9V0lf
         OScaUeYwu7iw4PmSm5NLYPMnEfrCbnWz/wKz7hp5XrKBumTxWGy4Z0GdDJ9j77znhZ
         swj14IsZROnRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 51DBE609D6;
        Tue,  9 Feb 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] Add support for route offload failure
 notifications
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161283240833.11828.1873955065991159036.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 01:00:08 +0000
References: <20210207082258.3872086-1-idosch@idosch.org>
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, jiri@nvidia.com, yoshfuji@linux-ipv6.org,
        amcohen@nvidia.com, roopa@nvidia.com, bpoirier@nvidia.com,
        sharpd@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun,  7 Feb 2021 10:22:48 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This is a complementary series to the one merged in commit 389cb1ecc86e
> ("Merge branch 'add-notifications-when-route-hardware-flags-change'").
> 
> The previous series added RTM_NEWROUTE notifications to user space
> whenever a route was successfully installed in hardware or when its
> state in hardware changed. This allows routing daemons to delay
> advertisement of routes until they are installed in hardware.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] rtnetlink: Add RTM_F_OFFLOAD_FAILED flag
    https://git.kernel.org/netdev/net-next/c/49fc251360a1
  - [net-next,02/10] IPv4: Add "offload failed" indication to routes
    https://git.kernel.org/netdev/net-next/c/36c5100e859d
  - [net-next,03/10] IPv4: Extend 'fib_notify_on_flag_change' sysctl
    https://git.kernel.org/netdev/net-next/c/648106c30a63
  - [net-next,04/10] IPv6: Add "offload failed" indication to routes
    https://git.kernel.org/netdev/net-next/c/0c5fcf9e249e
  - [net-next,05/10] IPv6: Extend 'fib_notify_on_flag_change' sysctl
    https://git.kernel.org/netdev/net-next/c/6fad361ae9f4
  - [net-next,06/10] netdevsim: fib: Do not warn if route was not found for several events
    https://git.kernel.org/netdev/net-next/c/484a4dfb7558
  - [net-next,07/10] netdevsim: dev: Initialize FIB module after debugfs
    https://git.kernel.org/netdev/net-next/c/f57ab5b75f71
  - [net-next,08/10] netdevsim: fib: Add debugfs to debug route offload failure
    https://git.kernel.org/netdev/net-next/c/134c75324240
  - [net-next,09/10] mlxsw: spectrum_router: Set offload_failed flag
    https://git.kernel.org/netdev/net-next/c/a4cb1c02c3e1
  - [net-next,10/10] selftests: netdevsim: Test route offload failure notifications
    https://git.kernel.org/netdev/net-next/c/9ee53e37532f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


