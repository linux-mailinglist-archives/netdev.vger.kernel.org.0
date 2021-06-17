Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEBB3ABBF0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhFQSmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhFQSmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35173613E1;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623955205;
        bh=lUprftC0qd3m/AegXi0FTw+/yFwuDXYDD1+M/LVu9a8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iXKJAA/Oof0ZN7SO0bbAGXGALjkWT07zuDCwH4PQtWb/UFJNvO4mA7g+M36M3eFGC
         tvrilJdNZHjbeaW+ZmShjeFFjaZqEIFMCdv9QOa9eN71Mbwq9JktFEZC+6J12ePo91
         FWKvlrOMuRP9LS0WkRbY9byHs8iQS58SRwciV+si7YHUwPAvgx1M+hb1SdZPvfNvQe
         gxJCbZEoJwJ6OGy4DxUoaDNzaqypmKh1okkRhZFTFxm2EAdKUT/nmHjWjqO7VpsDow
         XZ8tmF8emEgb8uoeZ+W72GrViPaszJqonoymeMY/nDVnWc6fhtEyPyCtnubSRkSqPU
         3i9N3rqAqNHlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2900C60A6C;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/8] net/mlx5: Fix error path for set HCA defaults
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395520516.2276.71617321171522091.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:40:05 +0000
References: <20210616224015.14393-2-saeed@kernel.org>
In-Reply-To: <20210616224015.14393-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, leonro@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com, parav@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 15:40:08 -0700 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In the case of the failure to execute mlx5_core_set_hca_defaults(),
> we used wrong goto label to execute error unwind flow.
> 
> Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/8] net/mlx5: Fix error path for set HCA defaults
    https://git.kernel.org/netdev/net/c/94a4b8414d3e
  - [net,2/8] net/mlx5: Check that driver was probed prior attaching the device
    https://git.kernel.org/netdev/net/c/2058cc9c8041
  - [net,3/8] net/mlx5: E-Switch, Read PF mac address
    https://git.kernel.org/netdev/net/c/bbc8222dc49d
  - [net,4/8] net/mlx5: E-Switch, Allow setting GUID for host PF vport
    https://git.kernel.org/netdev/net/c/ca36fc4d77b3
  - [net,5/8] net/mlx5: SF_DEV, remove SF device on invalid state
    https://git.kernel.org/netdev/net/c/c7d6c19b3bde
  - [net,6/8] net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding
    https://git.kernel.org/netdev/net/c/65fb7d109abe
  - [net,7/8] net/mlx5e: Don't create devices during unload flow
    https://git.kernel.org/netdev/net/c/a5ae8fc9058e
  - [net,8/8] net/mlx5: Reset mkey index on creation
    https://git.kernel.org/netdev/net/c/0232fc2ddcf4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


