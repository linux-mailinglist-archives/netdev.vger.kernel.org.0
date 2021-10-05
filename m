Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543454226A8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhJEMcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235009AbhJEMb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0E3961526;
        Tue,  5 Oct 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633437007;
        bh=pnR9mZJVT6do5hzm4WZCkq06CYjoXoxjguwrld9d9ps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WGNQA4ALCaGqimf2dd7FMBbFyHjxBnH1Ankvq4Y2fTbBW6I/0idJa8aQqQ/lAFiNv
         1AAfr+2CjXVv1mgcVE0+nK8ZOOgZvDtWi1YRsTgeoQ1juFU6Q0DfhkuUvsYKOyOxph
         txF5wT72aaU/lbQJOjat+M43GRbhCbg9VH85NBO6/2hhdlt8i3H+rwzO2JZMWWd4VZ
         pKtdLjiauOOZjrPmj148j2JRORjL75Sz1onpJGiz6IEgqnVobL+ekSMJgNfboust1L
         qLbxWAD7rwY3/VApYOnyXa1qGr5SUgMML5mfpdcX8BSqlau7uGojVWnJkWDXyra3+0
         pJ+lEAFDGhBMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C473760A0E;
        Tue,  5 Oct 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mlx4: prep for constant dev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343700780.31035.7456152330471867151.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 12:30:07 +0000
References: <20211004191446.2127522-1-kuba@kernel.org>
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, tariqt@nvidia.com,
        yishaih@nvidia.com, linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  4 Oct 2021 12:14:42 -0700 you wrote:
> This patch converts mlx4 for dev->dev_addr being const. It converts
> to use of common helpers but also removes some seemingly unnecessary
> idiosyncrasies.
> 
> Please review.
> 
> Jakub Kicinski (4):
>   mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
>   mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
>   mlx4: remove custom dev_addr clearing
>   mlx4: constify args for const dev_addr
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
    https://git.kernel.org/netdev/net-next/c/ded6e16b37e4
  - [net-next,2/4] mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
    https://git.kernel.org/netdev/net-next/c/1bb96a07f9a8
  - [net-next,3/4] mlx4: remove custom dev_addr clearing
    https://git.kernel.org/netdev/net-next/c/e04ffd120f3c
  - [net-next,4/4] mlx4: constify args for const dev_addr
    https://git.kernel.org/netdev/net-next/c/ebb1fdb589bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


