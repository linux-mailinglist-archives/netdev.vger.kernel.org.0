Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21540322498
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhBWDUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhBWDUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 28F7860C3D;
        Tue, 23 Feb 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614050409;
        bh=3mco/nmxZhGO4nSlNaHUVKL9/laVDET5oCK8N9DMqTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TisfqqKQtu0iSXtgjxsL42Xr/UcI5vhK7SmqGJqdV0bZq7XVV88OWi7Mwovew7G9Y
         E6UCIF0yLT1ydR1Jge8lO3VoMHuLz43yWW6J7u3umirgjnG+doeAluwqy3UMfG2HUN
         7CGYCoOutY+g3phkiQNu7z78V0NnAa9cDTFxqABBOMifzpZmWlPmLVH7CG06G2Ck6m
         HG+WysnfIykjMGJhVOIj8XUwqFYRLP2T/FqODqatqjHK8T7b+Ea9/Pwoq2hUY1ZzyA
         YEC7W0OWtb4PYrXIx9HoANBd8mBvhlHCREZ1qjScKimjST7OTSZc3DpgLfh6BpDiv5
         4EUWOcrNJCzKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1997E60A16;
        Tue, 23 Feb 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4_core: Add missed mlx4_free_cmd_mailbox()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161405040910.12674.6208700420414007006.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 03:20:09 +0000
References: <20210221143559.390277-1-hslester96@gmail.com>
In-Reply-To: <20210221143559.390277-1-hslester96@gmail.com>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        ogerlitz@mellanox.com, jackm@dev.mellanox.co.il,
        monis@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 21 Feb 2021 22:35:59 +0800 you wrote:
> mlx4_do_mirror_rule() forgets to call mlx4_free_cmd_mailbox() to
> free the memory region allocated by mlx4_alloc_cmd_mailbox() before
> an exit.
> Add the missed call to fix it.
> 
> Fixes: 78efed275117 ("net/mlx4_core: Support mirroring VF DMFS rules on both ports")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> 
> [...]

Here is the summary with links:
  - net/mlx4_core: Add missed mlx4_free_cmd_mailbox()
    https://git.kernel.org/netdev/net/c/8eb65fda4a6d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


