Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26B148767F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbiAGLaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347109AbiAGLaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57002C061245
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 134AEB8259E
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0470C36AE9;
        Fri,  7 Jan 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641555015;
        bh=ufLipBcBrhteF/D52aGYaiquT7DpF7Enak8+5JA4xLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YcM7awk0oYEJXSOueDkv5+yqRdp5P+Px2IUGi5MfqgWdpOwhoRz2eQSzfjdkLqozO
         Q9ozcher63iG9FAzpnBZMJRy89uYsKJvwPBAnAM+CBC9GC6rrcO4KJz5cdRoOGNfLK
         DZldhDHnIyJ8L+FhlEBBBDDtVhH5KlWMj8ADZKdOKfWWDCjdkIFmvV9oQp+r9hBS9m
         5ukf1Bi5/kgsTTQQTmQxRN+zISOLy58f3+HtkVi5FKiH7MrBpPf5fwvlxcwQ7mkDFg
         RkeYMPK0sBzE1jG7XIlDn2VzjbuH0KrPOWSS+kA2qN0B0JGfxXnixqq2TGZQTV6rJf
         dxcw8adkXfrmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6B36F7940A;
        Fri,  7 Jan 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] net/mlx5: mlx5e_hv_vhca_stats_create return
 type to void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164155501567.4388.2310170680415325850.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 11:30:15 +0000
References: <20220107002956.74849-2-saeed@kernel.org>
In-Reply-To: <20220107002956.74849-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, wangqing@vivo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu,  6 Jan 2022 16:29:42 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Callers of this functions ignore its return value, as reported by
> Wang Qing, in one of the return paths, it returns positive values.
> 
> Since return value is ignored anyways, void out the return type of the
> function.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: mlx5e_hv_vhca_stats_create return type to void
    https://git.kernel.org/netdev/net-next/c/20f80ffcedfa
  - [net-next,02/15] net/mlx5: Introduce control IRQ request API
    https://git.kernel.org/netdev/net-next/c/5256a46bf538
  - [net-next,03/15] net/mlx5: Move affinity assignment into irq_request
    https://git.kernel.org/netdev/net-next/c/30c6afa735db
  - [net-next,04/15] net/mlx5: Split irq_pool_affinity logic to new file
    https://git.kernel.org/netdev/net-next/c/424544df97b0
  - [net-next,05/15] net/mlx5: Introduce API for bulk request and release of IRQs
    https://git.kernel.org/netdev/net-next/c/79b60ca83b6f
  - [net-next,06/15] net/mlx5: SF, Use all available cpu for setting cpu affinity
    https://git.kernel.org/netdev/net-next/c/061f5b23588a
  - [net-next,07/15] net/mlx5: Update log_max_qp value to FW max capability
    https://git.kernel.org/netdev/net-next/c/f79a609ea6bf
  - [net-next,08/15] net/mlx5e: Expose FEC counters via ethtool
    https://git.kernel.org/netdev/net-next/c/0a1498ebfa55
  - [net-next,09/15] net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager
    https://git.kernel.org/netdev/net-next/c/7846665d3504
  - [net-next,10/15] net/mlx5e: Fix feature check per profile
    https://git.kernel.org/netdev/net-next/c/bc2a7b5c6b37
  - [net-next,11/15] net/mlx5e: Move HW-GRO and CQE compression check to fix features flow
    https://git.kernel.org/netdev/net-next/c/b5f42903704f
  - [net-next,12/15] net/mlx5e: Refactor set_pflag_cqe_based_moder
    https://git.kernel.org/netdev/net-next/c/be23511eb5c4
  - [net-next,13/15] net/mlx5e: TC, Remove redundant error logging
    https://git.kernel.org/netdev/net-next/c/68511b48bfbe
  - [net-next,14/15] net/mlx5e: Add recovery flow in case of error CQE
    https://git.kernel.org/netdev/net-next/c/5dd29f40b25f
  - [net-next,15/15] Documentation: devlink: mlx5.rst: Fix htmldoc build warning
    https://git.kernel.org/netdev/net-next/c/745a13061aa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


