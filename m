Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34B346E38
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhCXAUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231488AbhCXAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 114B1619E5;
        Wed, 24 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616545210;
        bh=pvFSCsQteMKLG3j5p3RTkF/r3M1yio3aIx38XqSSOrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=alNT8FG9L3nstDrO5pxDyUeU2Vm992Rka3A6SbwLjoTgDCcSNCWpwSqhxUlfHAH4g
         sA7xaz01LhieqFYUKxk8S0uOaw5Q8gw3a0ctnBh5UhUNSR7t4zLzeAIaGxK2vdjf5N
         All+uzbYMQTGrf/bNyPm9SsT9LTmfhgRTwiAl5xpfGRa/RRqOSXIdlPStJQqiPbKrt
         2lnjqz+9E8mLtB4ioNYkV4MgskmnvoNvYg8OORvFC+Z0vaDGAHg+ryOumPMerO4jqf
         nXSPPzeawkzVVm3LRGgE3DB42yDJESu4giX+++WNi/3YO2qEkRe1zNgqI836Z9Op4L
         IVCTnnUk4fxcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0135660A3E;
        Wed, 24 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: indir_table.h is included twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161654521000.13502.90773102608216924.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 00:20:10 +0000
References: <20210323020013.138697-1-wanjiabing@vivo.com>
In-Reply-To: <20210323020013.138697-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 10:00:12 +0800 you wrote:
> indir_table.h has been included at line 41, so remove
> the duplicate one at line 43.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: ethernet: indir_table.h is included twice
    https://git.kernel.org/netdev/net-next/c/ea6c8635d5d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


