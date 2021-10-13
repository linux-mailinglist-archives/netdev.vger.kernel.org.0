Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA56A42B0EC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 02:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhJMAWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 20:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhJMAWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 20:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CDC7D60BD3;
        Wed, 13 Oct 2021 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634084407;
        bh=ZCfu3epMVVobfTkmCWalLec03U/dCcWUdJEtgkxdfOc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pc45Vo13hkT4jFpIGN9EKzpr3697hBj5XOiOaY1GcOCrcDzLrCUDt1LlJvhoZEj9R
         pU5yxm5Ub2fzU3X4Bi04v6V+BGcB9XVMDt0D9M14+lKrcOihrUBFRfH1V5x40dKTzS
         C26BF7HcMoBS7fYRgoWJyTRLWc/bwzZSSLAk6XHtEdMx4l1a5eG2CDhJIkIlFO58Eo
         nz6YrRJsvEh56PcgI+P8WQZTbT0TJcj7jjpdkl13Xqr/NhlddpsJEGPTAGayZD2C8U
         qINM/ujD+Yj4lrIDDAw2MvxDLrDLeTStseFgDjqTCG8TIqO2HpLCZ2RspAipo1Ho0M
         KLr+vVgUwJNLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF732609CC;
        Wed, 13 Oct 2021 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/6] devlink reload simplification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163408440777.9622.8852746022639059437.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 00:20:07 +0000
References: <cover.1634044267.git.leonro@nvidia.com>
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        idosch@nvidia.com, mingo@redhat.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, moshe@nvidia.com, netdev@vger.kernel.org,
        saeedm@nvidia.com, salil.mehta@huawei.com, shayd@nvidia.com,
        rostedt@goodmis.org, tariqt@nvidia.com, yisen.zhuang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 16:15:20 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v4:
>  * Removed legacy BUG_ON() in first patch.
>  * Added new patch that moves netdev_to_devlink functions to devlink.c.
>  * Rewrote devlink ops patch to use feature mask.
> v3: https://lore.kernel.org/all/cover.1633589385.git.leonro@nvidia.com
>  * Rewrote third patch to keep static const nature of ops. This is done
>    by extracting reload ops to separate ops structure.
>  * Changed commit message in last patch as was suggested by Ido.
> v2: https://lore.kernel.org/all/cover.1633284302.git.leonro@nvidia.com
>  * Dropped const removal patch
>  * Added new patch to hide struct devlink
>  * Added new patch to annotate devlink API
>  * Implemented copy of all callback in devlink ops
> v1: https://lore.kernel.org/all/cover.1632916329.git.leonro@nvidia.com
>  * Missed removal of extra WARN_ON
>  * Added "ops parameter to macro as Dan suggested.
> v0: https://lore.kernel.org/all/cover.1632909221.git.leonro@nvidia.com
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] devlink: Reduce struct devlink exposure
    https://git.kernel.org/netdev/net-next/c/21314638c9f2
  - [net-next,v4,2/6] devlink: Move netdev_to_devlink helpers to devlink.c
    https://git.kernel.org/netdev/net-next/c/2bc50987dc1f
  - [net-next,v4,3/6] devlink: Annotate devlink API calls
    https://git.kernel.org/netdev/net-next/c/b88f7b1203bf
  - [net-next,v4,4/6] devlink: Allow control devlink ops behavior through feature mask
    https://git.kernel.org/netdev/net-next/c/bd032e35c568
  - [net-next,v4,5/6] net/mlx5: Set devlink reload feature bit for supported devices only
    https://git.kernel.org/netdev/net-next/c/96869f193cfd
  - [net-next,v4,6/6] devlink: Delete reload enable/disable interface
    https://git.kernel.org/netdev/net-next/c/82465bec3e97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


