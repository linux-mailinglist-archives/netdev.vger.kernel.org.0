Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D941DAE3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351026AbhI3NVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350956AbhI3NVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C6C7619F6;
        Thu, 30 Sep 2021 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008010;
        bh=ZBKP/cy224szzWaC2iWu9Hs89GPkUCQFwthYB12WVI0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HjMAgs5lK1P1XcuYt7XJxh6Z327fc2aQfp4D+oVcK7SM4cv/kADf6pb8qt2bqmsXx
         0zdJNFdGPzUiVD2sVhb9drkCd+TKHfi1RpvQDD9sxJe3ATUKvCnucGzVuJAngn9U7m
         t/oR6e/CA5dZTPgwhnMYrGDs1sE4Vwo8gxeZNx0Rh1LAmwXxVtpUt1Z25T4BduAPtJ
         /Bgq+VRLAth1LyuaPR4zWxdbWCTnnknFw0tpvTWsnwNMtOksbdEvB30uhGw5sHTCHD
         CcNoLajoEey2aWyz7f0Sjtnz600O1lGdmnG4DZaf4/EzcozdTfbnpSx4VefLMmbDet
         X5DYdyUH3SbMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 252F160A9F;
        Thu, 30 Sep 2021 13:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net/mlx4_en: Add XDP_REDIRECT statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300801014.14372.3999896240140577523.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 13:20:10 +0000
References: <20210930023023.245528-1-roysjosh@gmail.com>
In-Reply-To: <20210930023023.245528-1-roysjosh@gmail.com>
To:     Joshua Roys <roysjosh@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, bpf@vger.kernel.org, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 22:30:23 -0400 you wrote:
> Add counters for XDP REDIRECT success and failure. This brings the
> redirect path in line with metrics gathered via the other XDP paths.
> 
> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 8 ++++++++
>  drivers/net/ethernet/mellanox/mlx4/en_port.c    | 4 ++++
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c      | 4 +++-
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    | 2 ++
>  drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h | 4 +++-
>  5 files changed, 20 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net/mlx4_en: Add XDP_REDIRECT statistics
    https://git.kernel.org/netdev/net-next/c/dee3b2d0fa4b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


