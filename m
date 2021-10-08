Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1209426E16
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbhJHPwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243184AbhJHPwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 11:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3032760FD7;
        Fri,  8 Oct 2021 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633708208;
        bh=8YljNfK07lu5DFWWAUqu8t6i1onWE6mM/m4+LSMgQVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sygko7Qp9D8xKU3yIulyMelxYq21lU9o3jd+aib+3Ia86fjd5xHbNCY8rqRX7w0ME
         OrZN4IpVL/oNiDwS7vXrls7kkA4dXDYSIRmgzfE6HkgO/g2doj0/coeSFBY9tP1ZqT
         exgZ4WuIJPkbuJ/47xtKKzZ7lPAvCM67dX2dfQGjSBXl5RqkxAS0EStshELrgrt8dc
         GcghMcHkSSbzF0izO1PgnfCBriQioVoM3itIleiXHOVaE9pNURX+kLX3I0rHx2CkY/
         g3oOm3pjDfbKDt7OMziDFyd6nKiApghHc6HZTtGfbFuMdRxxOFLCs/gQcao8qjLCT4
         npCtfnSnp4Fyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D05560A44;
        Fri,  8 Oct 2021 15:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] selftests: forwarding: Add ip6gre tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370820811.13259.9982834788649436032.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 15:50:08 +0000
References: <20211008131241.85038-1-idosch@idosch.org>
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 16:12:33 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset adds forwarding selftests for ip6gre. The tests can be run
> with veth pairs or with physical loopbacks.
> 
> Patch #1 adds a new config option to determine if 'skip_sw' / 'skip_hw'
> flags are used when installing tc filters. By default, it is not set
> which means the flags are not used. 'skip_sw' is useful to ensure
> traffic is forwarded by the hardware data path.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] testing: selftests: forwarding.config.sample: Add tc flag
    https://git.kernel.org/netdev/net-next/c/45d45e5323a9
  - [net-next,2/8] testing: selftests: tc_common: Add tc_check_at_least_x_packets()
    https://git.kernel.org/netdev/net-next/c/c08d227290f6
  - [net-next,3/8] selftests: forwarding: Add IPv6 GRE flat tests
    https://git.kernel.org/netdev/net-next/c/7df29960fa65
  - [net-next,4/8] selftests: forwarding: Add IPv6 GRE hierarchical tests
    https://git.kernel.org/netdev/net-next/c/4b3d967b5cb9
  - [net-next,5/8] selftests: mlxsw: devlink_trap_tunnel_ipip6: Add test case for IPv6 decap_error
    https://git.kernel.org/netdev/net-next/c/4bb6cce00a2b
  - [net-next,6/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Align topology drawing correctly
    https://git.kernel.org/netdev/net-next/c/c473f723f97a
  - [net-next,7/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Remove code duplication
    https://git.kernel.org/netdev/net-next/c/8bb0ebd52238
  - [net-next,8/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Send a full-length key
    https://git.kernel.org/netdev/net-next/c/7f63cdde5030

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


