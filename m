Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311A92BBA2B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgKTXaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgKTXaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:30:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605915007;
        bh=/OdfuWA0dcsNQ0Gm9JSbLQAAt3tMTFA0Xy+oevRfxLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xu+67fhIgJNeTieh72xOYNmSBCwKz4UATM3IjG2j3ub7rBLPSOLjF5uDEodqEhdle
         ma8sMNTM1EQ5jfNFk1cyx9KwG6l5ys6HycJF8G61SFchi2bvx9fV8JCbPNTuEHE8MG
         mHnvFterFsJZQNpLa7r+qjACllUo6pQIWl5l9pFA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Add support for nexthop objects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160591500754.24153.13138500123117302827.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 23:30:07 +0000
References: <20201119130848.407918-1-idosch@idosch.org>
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, jiri@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Nov 2020 15:08:40 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set adds support for nexthop objects in mlxsw. Nexthop
> objects are treated as another front-end for programming nexthops, in
> addition to the existing IPv4 and IPv6 front-ends.
> 
> Patch #1 registers a listener to the nexthop notification chain and
> parses the nexthop information into the existing mlxsw data structures
> that are already used by the IPv4 and IPv6 front-ends. Blackhole
> nexthops are currently rejected. Support will be added in a follow-up
> patch set.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_router: Add support for nexthop objects
    https://git.kernel.org/netdev/net-next/c/2a014b200bbd
  - [net-next,2/8] mlxsw: spectrum_router: Enable resolution of nexthop groups from nexthop objects
    https://git.kernel.org/netdev/net-next/c/c25db3a77f61
  - [net-next,3/8] mlxsw: spectrum_router: Allow programming routes with nexthop objects
    https://git.kernel.org/netdev/net-next/c/cdd6cfc54c64
  - [net-next,4/8] selftests: mlxsw: Add nexthop objects configuration tests
    https://git.kernel.org/netdev/net-next/c/20ac8f869053
  - [net-next,5/8] selftests: forwarding: Do not configure nexthop objects twice
    https://git.kernel.org/netdev/net-next/c/ffb721515bf3
  - [net-next,6/8] selftests: forwarding: Test IPv4 routes with IPv6 link-local nexthops
    https://git.kernel.org/netdev/net-next/c/3600f29ad139
  - [net-next,7/8] selftests: forwarding: Add device-only nexthop test
    https://git.kernel.org/netdev/net-next/c/e96fa54bbd90
  - [net-next,8/8] selftests: forwarding: Add multipath tunneling nexthop test
    https://git.kernel.org/netdev/net-next/c/e035146d6560

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


