Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4017A362C25
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhDQAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234856AbhDQAAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80D146115B;
        Sat, 17 Apr 2021 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618617611;
        bh=PqT9uRw16KYDJ3ned6aj7xPnw/pdvOuDER/O1Bwbvp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvz1ttqt+SkE0AgNJOIVclTuqeIp91DxM5I8PsRgqWcoPDDtGimNjK2mvotVo5P0b
         GS0BmVLTyDlZwapuAw7YVs2ndo8z7hvv8spoNGZ5zFo4T2nF7Cj9IdK+QOEYvCuPgm
         EEm1u2m9esjyDa0QbgDXwiTbP6D+EzqC31Q8Ad7FqDc1itkgxGYiMjYtnCdITf/Ajw
         0J7r9B/0776r/NydkZ5ainQZAg20K7OGbskiQfa6Drvf5ThtqcIUhGsJHIhINU0aYH
         E0dDHf5HAppH8jT3S+D1DyI0bsZF9dh3BQtjWXS5om7mwz6RPYD3gA4RyXAPcsald+
         cvhyyUcK+kp7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7598A60A15;
        Sat, 17 Apr 2021 00:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/14] net/mlx5e: Remove non-essential TLS SQ state bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861761147.26880.7063234408230825295.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:00:11 +0000
References: <20210416185430.62584-2-saeed@kernel.org>
In-Reply-To: <20210416185430.62584-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, tariqt@nvidia.com,
        netdev@vger.kernel.org, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 11:54:17 -0700 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Maintaining an SQ state bit to indicate TLS support
> has no real need, a simple and fast test [1] for the SKB is
> almost equally good.
> 
> [1] !skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk)
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net/mlx5e: Remove non-essential TLS SQ state bit
    https://git.kernel.org/netdev/net-next/c/2f014f4016db
  - [net-next,02/14] net/mlx5e: Cleanup unused function parameter
    https://git.kernel.org/netdev/net-next/c/8668587a33b9
  - [net-next,03/14] net/mlx5e: TX, Inline TLS skb check
    https://git.kernel.org/netdev/net-next/c/b6b3ad2175c8
  - [net-next,04/14] net/mlx5e: TX, Inline function mlx5e_tls_handle_tx_wqe()
    https://git.kernel.org/netdev/net-next/c/72f6f2f8d6aa
  - [net-next,05/14] net/mlx5e: kTLS, Add resiliency to RX resync failures
    https://git.kernel.org/netdev/net-next/c/e9ce991bce5b
  - [net-next,06/14] net/mlx5e: Allow mlx5e_safe_switch_channels to work with channels closed
    https://git.kernel.org/netdev/net-next/c/6cad120d9e62
  - [net-next,07/14] net/mlx5e: Use mlx5e_safe_switch_channels when channels are closed
    https://git.kernel.org/netdev/net-next/c/69cc4185dcba
  - [net-next,08/14] net/mlx5e: Refactor on-the-fly configuration changes
    https://git.kernel.org/netdev/net-next/c/b3b886cf965d
  - [net-next,09/14] net/mlx5e: Cleanup safe switch channels API by passing params
    https://git.kernel.org/netdev/net-next/c/94872d4ef9c0
  - [net-next,10/14] net/mlx5: Allocate FC bulk structs with kvzalloc() instead of kzalloc()
    https://git.kernel.org/netdev/net-next/c/5cec6de0ae09
  - [net-next,11/14] net/mlx5: Add register layout to support extended link state
    https://git.kernel.org/netdev/net-next/c/36830159acbe
  - [net-next,12/14] net/mlx5e: Add ethtool extended link state
    https://git.kernel.org/netdev/net-next/c/b3446acb2b9a
  - [net-next,13/14] net/mlx5: Add helper to initialize 1PPS
    https://git.kernel.org/netdev/net-next/c/302522e67c70
  - [net-next,14/14] net/mlx5: Enhance diagnostics info for TX/RX reporters
    https://git.kernel.org/netdev/net-next/c/95742c1cc59d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


