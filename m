Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EB343E2EF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhJ1OCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhJ1OCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A59D161108;
        Thu, 28 Oct 2021 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429609;
        bh=xSP6IzfMgUiB9DvJ3+rpm4YvhRDsPk2r5L5Y+8X8dD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I+PzAMIrhURdfSmAH7//NEGWDWYQ+D7e+RhsHBnfKvztHKaCKF5dGbYxAoJm1drSc
         CMwZsJ3py1n6aKhdT5IK3L586Kg827WIi1tvwj1sIzL1BH9db/FSbRz4UllskrMTFz
         G7HuRF2PsYJxD3dhJ+uX8j9THvleCnLzOtWmblkcHwkTEXn/JTQ91a8bCbC8JliP+q
         Zh9RMC+eM/L0xKZ5yBgTDFiCnZdl6cINmCHIcyFJUo6cOZq8/5xxzokCW8f+QFdw+v
         E0PyX3D/aeTLyiMUN8KbHe6nOLL09MbNJVU6ZEY8UFWd6D4F60wwBRMzwZO8RhxWYh
         05bv+bkbMFzfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A00E2609CC;
        Thu, 28 Oct 2021 14:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Simplify internal devlink params
 implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542960965.12929.14691319462973764006.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 14:00:09 +0000
References: <efec83a9e9479018c324f12c1a99b2a9e3ee29f7.1635427378.git.leonro@nvidia.com>
In-Reply-To: <efec83a9e9479018c324f12c1a99b2a9e3ee29f7.1635427378.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 16:23:21 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Reduce extra indirection from devlink_params_*() API. Such change
> makes it clear that we can drop devlink->lock from these flows, because
> everything is executed when the devlink is not registered yet.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Simplify internal devlink params implementation
    https://git.kernel.org/netdev/net-next/c/ee775b56950f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


