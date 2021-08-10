Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0E3E5607
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhHJIyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235508AbhHJIyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C4F561058;
        Tue, 10 Aug 2021 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628585631;
        bh=fTecUtLJSM4QYldB3CTzKGgGWlQq/Gs+OrDTcRpjRXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSajZMQqgUSKycNpSL1iiLvlAIx4Qdt6FQFcC61DzgvNGnOt99aqJnu3wp7jmGAr/
         WbYNtnb2HrYzey88ye1YghQHpW7LrqHW5I7YuSb/tT6z/cMp6kNKVv7zS9c9I6Nehf
         XZXyAn6+nxLW9UPYlKFZg1vqha5o1wtYYEtxUqnNF+14m8ue9ZA1vTeuZ3PmZofPey
         BHGRRwzN0qnrPQ/psIZDOnKxsLbHSL7mXYcZwH08XtaXCpnNAchogxXxAooKRRbG6E
         QiFmcxlhTNaNxvIFIrfi1Sbiry0jDmk+QO502AYHG3yDmYlU/t81VgE3mhCbEI4NBB
         b7X7fOx5qDVkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20B8C60A2A;
        Tue, 10 Aug 2021 08:53:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5: Don't skip subfunction cleanup in case of error
 in module init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162858563112.16672.9755758908190077434.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 08:53:51 +0000
References: <20210810035923.345745-2-saeed@kernel.org>
In-Reply-To: <20210810035923.345745-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        leonro@nvidia.com, tariqt@nvidia.com, parav@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  9 Aug 2021 20:59:12 -0700 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Clean SF resources if mlx5 eth failed to initialize.
> 
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5: Don't skip subfunction cleanup in case of error in module init
    https://git.kernel.org/netdev/net/c/c633e799641c
  - [net,02/12] net/mlx5: DR, Add fail on error check on decap
    https://git.kernel.org/netdev/net/c/d3875924dae6
  - [net,03/12] net/mlx5e: Avoid creating tunnel headers for local route
    https://git.kernel.org/netdev/net/c/c623c95afa56
  - [net,04/12] net/mlx5: Bridge, fix ageing time
    https://git.kernel.org/netdev/net/c/6d8680da2e98
  - [net,05/12] net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free
    https://git.kernel.org/netdev/net/c/8ba3e4c85825
  - [net,06/12] net/mlx5: Block switchdev mode while devlink traps are active
    https://git.kernel.org/netdev/net/c/c85a6b8feb16
  - [net,07/12] net/mlx5: Fix order of functions in mlx5_irq_detach_nb()
    https://git.kernel.org/netdev/net/c/3c8946e0e284
  - [net,08/12] net/mlx5: Set all field of mlx5_irq before inserting it to the xarray
    https://git.kernel.org/netdev/net/c/5957cc557dc5
  - [net,09/12] net/mlx5: Destroy pool->mutex
    https://git.kernel.org/netdev/net/c/ba317e832d45
  - [net,10/12] net/mlx5e: TC, Fix error handling memory leak
    https://git.kernel.org/netdev/net/c/88bbd7b2369a
  - [net,11/12] net/mlx5: Synchronize correct IRQ when destroying CQ
    https://git.kernel.org/netdev/net/c/563476ae0c5e
  - [net,12/12] net/mlx5: Fix return value from tracer initialization
    https://git.kernel.org/netdev/net/c/bd37c2888cca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


