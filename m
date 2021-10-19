Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126244334B4
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhJSLc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235239AbhJSLcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5843561373;
        Tue, 19 Oct 2021 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634643042;
        bh=vzvOh7UVdMqtogR2nREaav5+IOkgY2L0KaZ8HzkJizM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aYrQeGTjp/2fClogkExTbXhCZDQDPTdURp7z0qicn/74ePal5njQB0/0EZHkYBrRk
         pV3ngTjWrTd+Z41URRIGQ4Vhc0RAhWbZqx4pkLbCxxtw2DC0TbFilWaqfGRfnzoYto
         4ZT9cIte68Kcq1OhiwMftPDAbWj/F46UT6X4zEDDixtj0YB75irXePb3Vg7A4APEmK
         /94gTmT6eplPcPeXCfoqIR81aZM+L0wWqcRK9R9QoDPQ5IHxd1GT/iExCOl49/FOCz
         2d5/FYGL5/OZ5GIsUXItBoEHhTJKbzsqbIFlUKpPU4bKOxuimnBzBSzuKu1KIewlde
         51q4IDnkk2ECQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 521B0609D8;
        Tue, 19 Oct 2021 11:30:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/13] net/mlx5: Support partial TTC rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464304233.15678.6328587199933642750.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:30:42 +0000
References: <20211019032047.55660-2-saeed@kernel.org>
In-Reply-To: <20211019032047.55660-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maorg@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon, 18 Oct 2021 20:20:35 -0700 you wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Add bitmasks to ttc_params to indicate if rule is valid or not.
> It will allow to create TTC table with support only in part of the
> traffic types.
> In later patches which introduce the steering based LAG port selection,
> TTC will be created with only part of the rules according to the hash
> type.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net/mlx5: Support partial TTC rules
    https://git.kernel.org/netdev/net-next/c/4c71ce50d2fe
  - [net-next,02/13] net/mlx5: Introduce port selection namespace
    https://git.kernel.org/netdev/net-next/c/425a563acb1d
  - [net-next,03/13] net/mlx5: Add support to create match definer
    https://git.kernel.org/netdev/net-next/c/e7e2519e3632
  - [net-next,04/13] net/mlx5: Introduce new uplink destination type
    https://git.kernel.org/netdev/net-next/c/58a606dba708
  - [net-next,05/13] net/mlx5: Lag, move lag files into directory
    https://git.kernel.org/netdev/net-next/c/3d677735d3b7
  - [net-next,06/13] net/mlx5: Lag, set LAG traffic type mapping
    https://git.kernel.org/netdev/net-next/c/1065e0015dd7
  - [net-next,07/13] net/mlx5: Lag, set match mask according to the traffic type bitmap
    https://git.kernel.org/netdev/net-next/c/e465550b38ed
  - [net-next,08/13] net/mlx5: Lag, add support to create definers for LAG
    https://git.kernel.org/netdev/net-next/c/dc48516ec7d3
  - [net-next,09/13] net/mlx5: Lag, add support to create TTC tables for LAG port selection
    https://git.kernel.org/netdev/net-next/c/8e25a2bc6687
  - [net-next,10/13] net/mlx5: Lag, add support to create/destroy/modify port selection
    https://git.kernel.org/netdev/net-next/c/b7267869e923
  - [net-next,11/13] net/mlx5: Lag, use steering to select the affinity port in LAG
    https://git.kernel.org/netdev/net-next/c/da6b0bb0fc73
  - [net-next,12/13] net/mlx5: E-Switch, Use dynamic alloc for dest array
    https://git.kernel.org/netdev/net-next/c/408881627ff0
  - [net-next,13/13] net/mlx5: E-Switch, Increase supported number of forward destinations to 32
    https://git.kernel.org/netdev/net-next/c/d40bfeddacd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


