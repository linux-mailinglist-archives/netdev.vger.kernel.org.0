Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38E44334B6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhJSLc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235298AbhJSLcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08B8E6135F;
        Tue, 19 Oct 2021 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634643042;
        bh=xqIdb+cfa3D2simEa4uG7BZnO9sCN6BR0wcNLRjDfc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IVG4xcciJJJi/Qi0PsasbtIaP58cWPw1jZv7rjTqZ2kOScg3X7+Zre5aIlKBPJeGt
         ymTdN2CoBmz6Xbon6FLukFTUD+8x1CgpeGSTqp/P61tWI+6wk4W06gF0GZdXO8NiVC
         rCpr2eYSCPzS597X+IUasaQHPe7ok4gLr9AOWAuALrJjQjuCSr2ej4bZlFQ90/bV7i
         UzZ8lpgQZwDewcYajpKhV0IihICfd5mB4bgyhHq9EkGc5NUZolyZLj/UMbOB6rr7Bm
         7Hlo+AzJtSPKepa6WQqI+X+yxLCcXiVwVUTBdQRQw/WCBGMH6dK4Inrtin9eiKtW6m
         TqE5yzF9OAuVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2EC460A2E;
        Tue, 19 Oct 2021 11:30:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Multi-level qdisc offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464304199.15678.1927825736970526500.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:30:41 +0000
References: <20211019080712.705464-1-idosch@idosch.org>
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 11:07:03 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> Currently, mlxsw admits for offload a suitable root qdisc, and its
> children. Thus up to two levels of hierarchy are offloaded. Often, this is
> enough: one can configure TCs with RED and TCs with a shaper on, and can
> even see counters for each TC by looking at a qdisc at a sufficiently
> shallow position.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: sch_tbf: Add a graft command
    https://git.kernel.org/netdev/net-next/c/6b3efbfa4e68
  - [net-next,2/9] mlxsw: spectrum_qdisc: Query tclass / priomap instead of caching it
    https://git.kernel.org/netdev/net-next/c/76ff72a7204f
  - [net-next,3/9] mlxsw: spectrum_qdisc: Extract two helpers for handling future FIFOs
    https://git.kernel.org/netdev/net-next/c/91796f507afc
  - [net-next,4/9] mlxsw: spectrum_qdisc: Destroy children in mlxsw_sp_qdisc_destroy()
    https://git.kernel.org/netdev/net-next/c/65626e075714
  - [net-next,5/9] mlxsw: spectrum_qdisc: Unify graft validation
    https://git.kernel.org/netdev/net-next/c/be7e2a5a58d4
  - [net-next,6/9] mlxsw: spectrum_qdisc: Clean stats recursively when priomap changes
    https://git.kernel.org/netdev/net-next/c/01164dda0a64
  - [net-next,7/9] mlxsw: spectrum_qdisc: Validate qdisc topology
    https://git.kernel.org/netdev/net-next/c/c2792f38caae
  - [net-next,8/9] mlxsw: spectrum_qdisc: Make RED, TBF offloads classful
    https://git.kernel.org/netdev/net-next/c/2a18c08d75ee
  - [net-next,9/9] selftests: mlxsw: Add a test for un/offloadable qdisc trees
    https://git.kernel.org/netdev/net-next/c/29c1eac2e64e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


