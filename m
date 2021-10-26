Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7FB43B28D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhJZMmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhJZMmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 459B360EDF;
        Tue, 26 Oct 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635252008;
        bh=xkTQOylYcj9nvPY/ZTa1b/hUaYAnDHPi91wpXaEr3+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aKirPYrybtX6tnYRszdJvSqizMg0NsZqF26TtMgmJuv75GMz5KsSk1S57BI4qx4TR
         jei8fmoulpxzEWMyP/AiSQ6jmzlyQwHrJRjKdFv1aunY2oW2W1Yn264UJt10ZOTetl
         v7dGRqVA8TQT27uycWiovI8K9WbPviFhFZr8pR99IWV5YE/qe0iSHhqvs9vnBBFQNA
         P1yKSR+GATp+qwr8JocKHtz919ZAxqg9j9wYSMYFSGGWlZ0fdInVO6steLEQbbaMRb
         aOYhu2ZMVneKv9aPbSOydjuER3/8Ie2wePgqLLaOyttnYmR+Him2PUT0uyqKnk0H8c
         kkJo1oe9inTAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 36BF7600DF;
        Tue, 26 Oct 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Support multiple RIF MAC prefixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525200821.3464.6443306435613313634.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:40:08 +0000
References: <20211026094225.1265320-1-idosch@idosch.org>
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 12:42:16 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, mlxsw enforces that all the netdevs used as router interfaces
> (RIFs) have the same MAC prefix (e.g., same 38 MSBs in Spectrum-1).
> Otherwise, an error is returned to user space with extack. This patchset
> relaxes the limitation through the use of RIF MAC profiles.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mlxsw: reg: Add MAC profile ID field to RITR register
    https://git.kernel.org/netdev/net-next/c/d25d7fc31ed2
  - [net-next,2/9] mlxsw: resources: Add resource identifier for RIF MAC profiles
    https://git.kernel.org/netdev/net-next/c/a8428e5045d7
  - [net-next,3/9] mlxsw: spectrum_router: Propagate extack further
    https://git.kernel.org/netdev/net-next/c/26029225d992
  - [net-next,4/9] mlxsw: spectrum_router: Add RIF MAC profiles support
    https://git.kernel.org/netdev/net-next/c/605d25cd782a
  - [net-next,5/9] mlxsw: spectrum_router: Expose RIF MAC profiles to devlink resource
    https://git.kernel.org/netdev/net-next/c/1c375ffb2efa
  - [net-next,6/9] selftests: mlxsw: Add a scale test for RIF MAC profiles
    https://git.kernel.org/netdev/net-next/c/152f98e7c5cb
  - [net-next,7/9] selftests: mlxsw: Add forwarding test for RIF MAC profiles
    https://git.kernel.org/netdev/net-next/c/a10b7bacde60
  - [net-next,8/9] selftests: Add an occupancy test for RIF MAC profiles
    https://git.kernel.org/netdev/net-next/c/20d446db6144
  - [net-next,9/9] selftests: mlxsw: Remove deprecated test cases
    https://git.kernel.org/netdev/net-next/c/c24dbf3d4f88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


