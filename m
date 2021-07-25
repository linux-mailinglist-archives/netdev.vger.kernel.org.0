Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E23D4D0F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhGYJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhGYJaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 05:30:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F66E60725;
        Sun, 25 Jul 2021 10:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627207853;
        bh=DznZekU7W96nK7tplZoslie8uQH/QAkxMN261QPwAYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mYGfqzL32v2bRWmKFTdU0Q+zLx90XcgKQDKkXofc/bdyU2bi8yeLbRQTfPzxo5gnN
         negOoqMVgcV9ryTmiNn0qSaGlpDPtiS9HD9xXkFcI55lBY5fBp+fz8cmcV44lcQ2+f
         JrgLF3qSyLjU4GHqqZNeNKOdZ8dWBab2f4WvWnYFlwdT80Co0WF5pyQ4sHvLJURZMj
         4/gbcZt7hFt2qUoWXoWUN5yynW5krPxef+zuTHNzebIvGjkAprzjpGUVd5JYffaJMq
         tK5PCyJDjjo0g/PgoUFt+BNoDFxUaGT1l76eyAZFg08wWChexD16Ang2O1DObw3649
         J4TzhnKUPN6wg==
Date:   Sun, 25 Jul 2021 13:10:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5: Fix missing return value in
 mlx5_devlink_eswitch_inline_mode_set()
Message-ID: <YP04qUtPsYYOtqP7@unreal>
References: <1626947897-73558-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626947897-73558-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 05:58:16PM +0800, Jiapeng Chong wrote:
> The return value is missing in this code scenario, add the return value
> '0' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
> mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -For the follow advice: https://lore.kernel.org/patchwork/patch/1461601/
> 
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
