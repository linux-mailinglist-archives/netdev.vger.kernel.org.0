Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4003F34F1FB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhC3UKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232259AbhC3UKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DBFBE619C2;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617135017;
        bh=vnIkK7Exo0tz81NedZnEY/sKNIXAnQrvN4SqgSQsdZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kOmMVYCdVoW/NFptV8pJscT/OlNd9CZqX0BdBJ3yFbcdtFOQhZvmd7Kfo+xKoiFKb
         ssnDuZs+d8UirrbYLsOyCSZRwZvQbVC81hqGDCm7OmW5iSuyQ+gGk8kfaM9ZGUKZHv
         +NwkG4eDzXwBEqIfb9Z8ahsdBJxj/0uOwjuxm4Ao7uDlnOrxEmY5Cws3aojDzRXJE8
         HfIwYNfUjs+xeeFyiqJaU71Ca/ugWKgrfXCavRw7EXEAYvmW96nibSz8RMcdZgxbtr
         Qw2YlUNvD7rAiC7by1QcLfsya5adQsJKdL2z1oWrYsnWjWZfq5iHGkXHt8bDBMirrf
         b45DJNMkBVARg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD08B609B5;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/12] net/mlx5e: Add states to PTP channel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713501783.31227.7556262460168073535.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:10:17 +0000
References: <20210330042741.198601-2-saeed@kernel.org>
In-Reply-To: <20210330042741.198601-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ayal@nvidia.com, tariqt@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 21:27:30 -0700 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Add PTP TX state to PTP channel, which indicates the corresponding SQ is
> available. Further patches in the set extend PTP channel to include RQ.
> The PTP channel state will be used for separation and coexistence of RX
> and TX PTP. Enhance conditions to verify the TX PTP state is set.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net/mlx5e: Add states to PTP channel
    https://git.kernel.org/netdev/net-next/c/24c22dd0918b
  - [net-next,02/12] net/mlx5e: Add RQ to PTP channel
    https://git.kernel.org/netdev/net-next/c/a099da8ffcf6
  - [net-next,03/12] net/mlx5e: Add PTP-RX statistics
    https://git.kernel.org/netdev/net-next/c/a28359e922c6
  - [net-next,04/12] net:mlx5e: Add PTP-TIR and PTP-RQT
    https://git.kernel.org/netdev/net-next/c/3adb60b6a3ed
  - [net-next,05/12] net/mlx5e: Refactor RX reporter diagnostics
    https://git.kernel.org/netdev/net-next/c/19cfa36b18d8
  - [net-next,06/12] net/mlx5e: Add PTP RQ to RX reporter
    https://git.kernel.org/netdev/net-next/c/b8fb10939ff4
  - [net-next,07/12] net/mlx5e: Cleanup Flow Steering level
    https://git.kernel.org/netdev/net-next/c/c809cf665e28
  - [net-next,08/12] net/mlx5e: Introduce Flow Steering UDP API
    https://git.kernel.org/netdev/net-next/c/1c80bd684388
  - [net-next,09/12] net/mlx5e: Introduce Flow Steering ANY API
    https://git.kernel.org/netdev/net-next/c/0f575c20bf06
  - [net-next,10/12] net/mlx5e: Add PTP Flow Steering support
    https://git.kernel.org/netdev/net-next/c/e5fe49465d46
  - [net-next,11/12] net/mlx5e: Allow coexistence of CQE compression and HW TS PTP
    https://git.kernel.org/netdev/net-next/c/960fbfe222a4
  - [net-next,12/12] net/mlx5e: Update ethtool setting of CQE compression
    https://git.kernel.org/netdev/net-next/c/885b8cfb161e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


