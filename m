Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633FC30B58B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBBDAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhBBDAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 22:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B8CB64E9A;
        Tue,  2 Feb 2021 03:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612234809;
        bh=rkpjzgm1LMj8KiRUvZGLZQzRBBLvf7MHGA/QMqHFSyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WcpO+brjNG6xNJVr+KZKKh6kR3Drr3Uwn7V95g1f/vAZvoOOcTGesJfh1qb1FWZdD
         IGWrFqoQ7+JRcOyODTbZYS0W78ckPxuhYvj9dGGDS8L7iJ93JWAUERNuIKiCJSFBZG
         Oxv03ZwXBgff5deA+Myk9aZxOAK6dqZqa9t1QRFt3jacxWmznnKCR+vDttpgCQVLpH
         f8y+fLfUlnC8BDP+syY+Y/7ODoTTKaN2n1Ezv0WbE9srzYsz/BSfeZ5Xi1dfGQeaxO
         xBXGehXLdFHS1i89tj2fQW0hLOh1UDvfCOZ3JEeEMFWFYdxt1bmDTrHSirSXG78QN0
         lvNCRsa42D/tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 284AE609D0;
        Tue,  2 Feb 2021 03:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/11] net/mlx5: DR,
 Fix potential shift wrapping of 32-bit value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223480916.4899.12916800639167242666.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 03:00:09 +0000
References: <20210130022618.317351-2-saeed@kernel.org>
In-Reply-To: <20210130022618.317351-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, leonro@nvidia.com, kliteyn@nvidia.com,
        dan.carpenter@oracle.com, valex@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 29 Jan 2021 18:26:08 -0800 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Fix 32-bit variable shift wrapping in dr_ste_v0_get_miss_addr.
> 
> Fixes: 6b93b400aa88 ("net/mlx5: DR, Move STEv0 setters and getters")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net/mlx5: DR, Fix potential shift wrapping of 32-bit value
    https://git.kernel.org/netdev/net-next/c/bdbc13c204ee
  - [net-next,02/11] net/mlx5: DR, Add match STEv1 structs to ifc
    https://git.kernel.org/netdev/net-next/c/3a77c238909b
  - [net-next,03/11] net/mlx5: DR, Add HW STEv1 match logic
    https://git.kernel.org/netdev/net-next/c/10b694186410
  - [net-next,04/11] net/mlx5: DR, Allow native protocol support for HW STEv1
    https://git.kernel.org/netdev/net-next/c/9f125ced1750
  - [net-next,05/11] net/mlx5: DR, Add STEv1 setters and getters
    https://git.kernel.org/netdev/net-next/c/a6098129c781
  - [net-next,06/11] net/mlx5: DR, Add STEv1 action apply logic
    https://git.kernel.org/netdev/net-next/c/4e856c5db9b4
  - [net-next,07/11] net/mlx5: DR, Add STEv1 modify header logic
    https://git.kernel.org/netdev/net-next/c/c349b4137cfd
  - [net-next,08/11] net/mlx5: DR, Use the right size when writing partial STE into HW
    https://git.kernel.org/netdev/net-next/c/f06d496985f4
  - [net-next,09/11] net/mlx5: DR, Use HW specific logic API when writing STE
    https://git.kernel.org/netdev/net-next/c/4fe45e1d31ef
  - [net-next,10/11] net/mlx5: DR, Copy all 64B whenever replacing STE in the head of miss-list
    https://git.kernel.org/netdev/net-next/c/8fdac12acf32
  - [net-next,11/11] net/mlx5: DR, Allow SW steering for sw_owner_v2 devices
    https://git.kernel.org/netdev/net-next/c/64f45c0fc4c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


