Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9713F437A9F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhJVQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhJVQMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 77FC961163;
        Fri, 22 Oct 2021 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634919007;
        bh=SPlMHyht+w/MLteefYniQ3lbjF7zRKUSnY88v5UDeDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HWLbitFHgifXGTmKpwto5yEyRRYXaoBgZy53n51cB5Ym0uqsyl7QEZuvNQP7Q87D1
         tYrVlI3R0Mo9sn1gcpNp/S4rbGoeGA24es4x5x/Sbw2hshEs75ZCz1PjD0QPDoOgmf
         +yGo42TxYWgJBWdWdm9zrE2BL7FpTDufFSqnxIzVaRx+fkiM5YRLoR2Ii8F+pGggD2
         CO6ys8FALP+uKEDBSVu+t/V1uAn9WNldgX1tsMj/PUE8HAEgkL6SN4D/ED2Gs/1Mvl
         Sl3V4VeA/mFhftQtIlZGji4iGKH4Qzg3pL9a9HXJ8pb7ZC1kw/lCxdoUczxNZ6utoT
         v05M+vvJXmiZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6479E60A2A;
        Fri, 22 Oct 2021 16:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163491900740.27396.7600994383536368181.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 16:10:07 +0000
References: <20211022112436.4c46b5a4@canb.auug.org.au>
In-Reply-To: <20211022112436.4c46b5a4@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, maorg@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Oct 2021 11:24:36 +1100 you wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:71:10: fatal error: lag.h: No such file or directory
>    71 | #include "lag.h"
>       |          ^~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:13:10: fatal error: lag.h: No such file or directory
>    13 | #include "lag.h"
>       |          ^~~~~~~
> 
> [...]

Here is the summary with links:
  - linux-next: build failure after merge of the net-next tree
    https://git.kernel.org/netdev/net-next/c/016c89460d34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


