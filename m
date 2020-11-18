Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9314F2B8537
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgKRUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgKRUAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:00:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605729607;
        bh=k9iy11mJqWCY4hj0HY9aPUixiRE6rcNlhFlum9KjY6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JY+r/nNu/2JbOIJzSMP3IhzVgmBYTZsyJFxaTLHJkXUWUe92NsMHQ1MOeIAsehCBg
         FpnYsKJLwafqfd8O2A3IEFDiVxzMR4a6UYwahgGJsRYTFopB5QKvWgAo/YXMQw2g/J
         q2WnUVfLlRTB5gXx+9/tmt7vRHccs1wZpby9NNaI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Preparations for nexthop objects support
 - part 2/2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160572960734.10823.8140794873131277624.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 20:00:07 +0000
References: <20201117174704.291990-1-idosch@idosch.org>
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Nov 2020 19:46:55 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set contains the second round of preparations towards nexthop
> objects support in mlxsw. Follow up patches can be found here [1].
> 
> The patches are mostly small and trivial and contain non-functional
> changes aimed at making it easier to integrate nexthop objects with
> mlxsw.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mlxsw: spectrum_router: Fix wrong kfree() in error path
    https://git.kernel.org/netdev/net-next/c/fbf805bf1fcd
  - [net-next,2/9] mlxsw: spectrum_router: Set ifindex for IPv4 nexthops
    https://git.kernel.org/netdev/net-next/c/ff8a24182acc
  - [net-next,3/9] mlxsw: spectrum_router: Pass ifindex to mlxsw_sp_ipip_entry_find_by_decap()
    https://git.kernel.org/netdev/net-next/c/c68e248d538b
  - [net-next,4/9] mlxsw: spectrum_router: Set FIB entry's type after creating nexthop group
    https://git.kernel.org/netdev/net-next/c/5c9a3b24518c
  - [net-next,5/9] mlxsw: spectrum_router: Set FIB entry's type based on nexthop group
    https://git.kernel.org/netdev/net-next/c/c0351b7c25ff
  - [net-next,6/9] mlxsw: spectrum_router: Re-order mlxsw_sp_nexthop6_group_get()
    https://git.kernel.org/netdev/net-next/c/5b9954e1e7b8
  - [net-next,7/9] mlxsw: spectrum_router: Only clear offload indication from valid IPv6 FIB info
    https://git.kernel.org/netdev/net-next/c/a9a711a3f78b
  - [net-next,8/9] mlxsw: spectrum_router: Add an indication if a nexthop group can be destroyed
    https://git.kernel.org/netdev/net-next/c/2efca2bfba99
  - [net-next,9/9] mlxsw: spectrum_router: Allow returning errors from mlxsw_sp_nexthop_group_refresh()
    https://git.kernel.org/netdev/net-next/c/e3ddfb45bacd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


