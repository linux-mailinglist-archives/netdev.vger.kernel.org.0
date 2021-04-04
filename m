Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0763353786
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 10:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhDDIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 04:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDDIuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 04:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FD8B6137A;
        Sun,  4 Apr 2021 08:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617526211;
        bh=dtnjppmrUtixuPj/XhUPnFodwfmdHn4FcsenRIEMa4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qu2Ri8CdtuP6PWgRlaxguhB47SrLjaEnh2kL0Aid5VPyZF/tu0mVUc/MZMhan95Gs
         fEHsxhCOb/69gb3LF6yEsjamVNT39BG476itVkhD0sz8y+tdysMQO+VuCtpwDG2Eis
         HiiQ8cz81+0AaTlBJGBE0/wl3hm0P9ldIbTlVO4/W4KDG+9hVw9PKKHFQpHUCciPDL
         BUkE91H+j2WKvELrivSxCfG5UiFpICXuDjriQkO3hZ8B9H+ZGrx3wi3lVA8MGPd/7I
         3piNiW1LXxwNHb+NaENC1rh07e/f5u8Q7s1UH2H4uV944nLjs1v7u1HCKsJ4+vfiSc
         UIBtbKixlLFLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7164260A00;
        Sun,  4 Apr 2021 08:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5: CT: Add support for matching on ct_state
 inv and rel flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161752621145.8645.13570276514334555985.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Apr 2021 08:50:11 +0000
References: <20210404041954.146958-2-saeed@kernel.org>
In-Reply-To: <20210404041954.146958-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, lariel@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat,  3 Apr 2021 21:19:39 -0700 you wrote:
> From: Ariel Levkovich <lariel@nvidia.com>
> 
> Add support for matching on ct_state inv and rel flags.
> 
> Currently the support is only for match on -inv and -rel.
> Matching on +inv and +rel will be rejected.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5: CT: Add support for matching on ct_state inv and rel flags
    https://git.kernel.org/netdev/net-next/c/116c76c51035
  - [net-next,02/16] net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
    https://git.kernel.org/netdev/net-next/c/cadb129ffdfe
  - [net-next,03/16] net/mlx5: E-Switch, move QoS specific fields to existing qos struct
    https://git.kernel.org/netdev/net-next/c/e591605f801e
  - [net-next,04/16] net/mlx5: Use unsigned int for free_count
    https://git.kernel.org/netdev/net-next/c/c6baac47d9e6
  - [net-next,05/16] net/mlx5: Pack mlx5_rl_entry structure
    https://git.kernel.org/netdev/net-next/c/4c4c0a89abd5
  - [net-next,06/16] net/mlx5: Do not hold mutex while reading table constants
    https://git.kernel.org/netdev/net-next/c/16e74672a21b
  - [net-next,07/16] net/mlx5: Use helpers to allocate and free rl table entries
    https://git.kernel.org/netdev/net-next/c/51ccc9f5f106
  - [net-next,08/16] net/mlx5: Use helper to increment, decrement rate entry refcount
    https://git.kernel.org/netdev/net-next/c/97d85aba2543
  - [net-next,09/16] net/mlx5: Allocate rate limit table when rate is configured
    https://git.kernel.org/netdev/net-next/c/6b30b6d4d36c
  - [net-next,10/16] net/mlx5: Pair mutex_destory with mutex_init for rate limit table
    https://git.kernel.org/netdev/net-next/c/19779f28c96d
  - [net-next,11/16] net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
    https://git.kernel.org/netdev/net-next/c/b47e1056257c
  - [net-next,12/16] net/mlx5: E-Switch, move QoS specific fields to existing qos struct
    https://git.kernel.org/netdev/net-next/c/233dd7d6565e
  - [net-next,13/16] net/mlx5: Use ida_alloc_range() instead of ida_simple_alloc()
    https://git.kernel.org/netdev/net-next/c/8802b8a44ef8
  - [net-next,14/16] net/mlx5e: Reject tc rules which redirect from a VF to itself
    https://git.kernel.org/netdev/net-next/c/bb5696570b0b
  - [net-next,15/16] net/mlx5e: Dynamic alloc arfs table for netdev when needed
    https://git.kernel.org/netdev/net-next/c/f6755b80d693
  - [net-next,16/16] net/mlx5e: Dynamic alloc vlan table for netdev when needed
    https://git.kernel.org/netdev/net-next/c/6783f0a21a3c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


