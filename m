Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0350F3A066D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhFHVwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhFHVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70B67613AE;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623189009;
        bh=1lQSwCTbXG9WgcmTscLTWXGWEEMybDfAUISlTNJPcPM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AZ4ns5N1mhM7rAhavqFA+g3/duOOakEqDMHupRaJOPGa6YMaQ8qxvbBkTXfuOrFs/
         DT8qLQisr96GvLkCKZs0et7gd9z8yrgPfu14NP5c4GagtQ3qt2avRk5E8OZc4Xd/p7
         sk5K+eNfo6a6+CDYSIzyY6kuc8Yij++s1FPr1UcDHkDLCFy9nTRQN/3/SZqNfYr0sM
         L69yuL9ohO7HDjrnIEdTGTuO12pBGVetJED3Auu/frhw1PO13OFGfjAqLN0i1RqaQ5
         EZMVRCOppX471WJVYuc4YB92q/CU6zVh8d0uUWXzRF+Sxk3z3ZD2VtLY2Kk8eg8y5T
         FOAq/sBoY90qA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5CDBB60CD1;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318900937.8715.11614110035580933447.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 21:50:09 +0000
References: <20210608124414.1664294-1-idosch@idosch.org>
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, amcohen@nvidia.com,
        vadimp@nvidia.com, c_mykolak@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 15:44:06 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains various updates for mlxsw. The most significant
> change is the long overdue removal of the abort mechanism in the first
> two patches.
> 
> Patches #1-#2 remove the route abort mechanism. This change is long
> overdue and explained in detail in the commit message.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_router: Remove abort mechanism
    https://git.kernel.org/netdev/net-next/c/a08a61934cfa
  - [net-next,2/8] selftests: router_scale: Do not count failed routes
    https://git.kernel.org/netdev/net-next/c/00190c2b19eb
  - [net-next,3/8] selftests: Clean forgotten resources as part of cleanup()
    https://git.kernel.org/netdev/net-next/c/e67dfb8d15de
  - [net-next,4/8] selftests: devlink_lib: Fix bouncing of netdevsim DEVLINK_DEV
    https://git.kernel.org/netdev/net-next/c/0521a262f043
  - [net-next,5/8] mlxsw: reg: Extend MTMP register with new threshold field
    https://git.kernel.org/netdev/net-next/c/314dbb19f95b
  - [net-next,6/8] mlxsw: core_env: Read module temperature thresholds using MTMP register
    https://git.kernel.org/netdev/net-next/c/befc2048088a
  - [net-next,7/8] mlxsw: thermal: Add function for reading module temperature and thresholds
    https://git.kernel.org/netdev/net-next/c/e57977b34ab5
  - [net-next,8/8] mlxsw: thermal: Read module temperature thresholds using MTMP register
    https://git.kernel.org/netdev/net-next/c/72a64c2fe9d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


