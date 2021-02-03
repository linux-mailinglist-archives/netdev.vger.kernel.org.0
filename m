Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986A630D133
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhBCCAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhBCCAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E42EC64F75;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612317610;
        bh=N2B7p6Fz22DhtYIDGOzQWKy6DdHMyc5sOsq6y8TODWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gf7Q6Kq2gFmaMF5rEia8XFo7BPNIV1NHspID6QXSdhmptz/WlrO1YFooTAmZz2aMl
         EIlHVBYNLAH7IgkiBmbN4rLCEJgoTS3tdcuh6aFXyjSzr3Kbf4tR+eYKLbzGSfDxEO
         dV40s6BFR3lKnAjX/otmsCmZBRoNNT5PBSw1NQ6jqf7ibboR41poTVyhzu7Tfr42UH
         3IK+PnhxeO+do5OQ5986BWykS8BxkbtWAJkKxtudVvwhDquUNPwePAAbYZyGydy0dS
         WWup03WjaOktJOUIFh6taAmu9StnGtt9r1+4457l5Sl0S+3e9ZpODtHx5X16frl5Fm
         17gqzHIBSPubQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0458609E5;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] Add notifications when route hardware flags
 change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161231761084.3354.1009211825820091003.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 02:00:10 +0000
References: <20210201194757.3463461-1-idosch@idosch.org>
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, jiri@nvidia.com,
        amcohen@nvidia.com, roopa@nvidia.com, bpoirier@nvidia.com,
        sharpd@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 21:47:47 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Routes installed to the kernel can be programmed to capable devices, in
> which case they are marked with one of two flags. RTM_F_OFFLOAD for
> routes that offload traffic from the kernel and RTM_F_TRAP for routes
> that trap packets to the kernel for processing (e.g., host routes).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] netdevsim: fib: Convert the current occupancy to an atomic variable
    https://git.kernel.org/netdev/net-next/c/9e635a21cae0
  - [net-next,v2,02/10] netdevsim: fib: Perform the route programming in a non-atomic context
    https://git.kernel.org/netdev/net-next/c/0ae3eb7b4611
  - [net-next,v2,03/10] net: ipv4: Pass fib_rt_info as const to fib_dump_info()
    https://git.kernel.org/netdev/net-next/c/085547891de5
  - [net-next,v2,04/10] net: ipv4: Publish fib_nlmsg_size()
    https://git.kernel.org/netdev/net-next/c/1e7bdec6bbc7
  - [net-next,v2,05/10] net: ipv4: Emit notification when fib hardware flags are changed
    https://git.kernel.org/netdev/net-next/c/680aea08e78c
  - [net-next,v2,06/10] net: Pass 'net' struct as first argument to fib6_info_hw_flags_set()
    https://git.kernel.org/netdev/net-next/c/fbaca8f895a6
  - [net-next,v2,07/10] net: Do not call fib6_info_hw_flags_set() when IPv6 is disabled
    https://git.kernel.org/netdev/net-next/c/efc42879ec9e
  - [net-next,v2,08/10] net: ipv6: Emit notification when fib hardware flags are changed
    https://git.kernel.org/netdev/net-next/c/907eea486888
  - [net-next,v2,09/10] selftests: Extend fib tests to run with and without flags notifications
    https://git.kernel.org/netdev/net-next/c/d1a7a489287c
  - [net-next,v2,10/10] selftests: netdevsim: Add fib_notifications test
    https://git.kernel.org/netdev/net-next/c/19d36d2971e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


