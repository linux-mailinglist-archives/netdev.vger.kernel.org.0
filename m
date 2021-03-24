Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D347346E47
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhCXAaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233699AbhCXAaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10810619E5;
        Wed, 24 Mar 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616545809;
        bh=Yv6DSkJeCZKdwLbIeklfC/Gkz2mF9S04LMwbHWme2cE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/myjKuz0/JNwkcBgkwq1N7vo6lIdJxts+eINjpgNfdUvoTHjBXkzPNFJB1Oujlwv
         r5gBZzYyws7pMR0fQYKZ5H3sSWy3DFDpZZ1BOAQ6w1IR3A1yFIU7VFVt3tYxVAfi62
         2wTxRjDO3WkvZ+m3AiNCoWX8W6QANNSFD+YnbT78XZp6KtgxNqgt2IfmPOgqsj/UOI
         L3tbFzjMoz4avlO2sDzKx9WIeRXnv8G4F+HaP2eHMDXoDkI9XwEZ6U8XcrIJSMOtGZ
         JaKtPlG8Cw1wqx12+5rZsHLHGuRPwphgvi6XwPMe9M1nCnVCF8sSh3dVwlCE/4phzH
         iXPwBOq37gVXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0251D60A3E;
        Wed, 24 Mar 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: Remove duplicate include of vhca_event.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161654580900.18092.16312775969990333697.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 00:30:09 +0000
References: <20210323020605.139644-1-wanjiabing@vivo.com>
In-Reply-To: <20210323020605.139644-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, parav@nvidia.com, vuhuong@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 10:05:48 +0800 you wrote:
> vhca_event.h has been included at line 4, so remove the
> duplicate one at line 8.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: ethernet: Remove duplicate include of vhca_event.h
    https://git.kernel.org/netdev/net-next/c/4c94fe88cde4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


