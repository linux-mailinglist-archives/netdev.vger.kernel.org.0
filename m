Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADB136AA6B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhDZBky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhDZBkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EFAE61154;
        Mon, 26 Apr 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619401210;
        bh=OAx/VX1Eg2i/m7FSX9RBPiBwEWkkomITLl/iDNoM8nc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q919pYMpsx29ChdtkitJrKs10D7uS6LJQbQ+hQ2MJy9BJ8PLXl13G+EnkopVZ4/Yb
         YPjvGNxtCxRhsj+aMWkzQVS/1uXN2OpzZW+va0GnCxC0Lw6yfLiWuE/3e6IM98Vc5V
         VWEcU8F0IGfXmWMbbEf7PAFqK+OoQs95Q04xSqu02f6VRziB+Q7ImHiOErO/pKT1aX
         EvvScO+iuPTSCTQrIKE6hCIZiXplIWxisTU/8FK09hoJxITDG+8A/Cu3Z6FAz8Dxnb
         TKV5gNmgxICg3qkZBwray/h0r4UzdhsnVxt0L2a/ARqz0Iy22n3/6cseuv6ZpdL0cz
         H3eejiTLUWREw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95B9460CE0;
        Mon, 26 Apr 2021 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/11] net/mlx5: E-Switch,
 Return eswitch max ports when eswitch is supported
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940121060.11520.11412171298037876897.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:40:10 +0000
References: <20210424080115.97273-2-saeed@kernel.org>
In-Reply-To: <20210424080115.97273-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        parav@nvidia.com, roid@nvidia.com, vuhuong@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 24 Apr 2021 01:01:05 -0700 you wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> mlx5_eswitch_get_total_vports() doesn't honor MLX5_ESWICH Kconfig flag.
> 
> When MLX5_ESWITCH is disabled, FS layer continues to initialize eswitch
> specific ACL namespaces.
> Instead, start honoring MLX5_ESWITCH flag and perform vport specific
> initialization only when vport count is non zero.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/11] net/mlx5: E-Switch, Return eswitch max ports when eswitch is supported
    https://git.kernel.org/netdev/net-next/c/06ec5acc7747
  - [net-next,V2,02/11] net/mlx5: E-Switch, Prepare to return total vports from eswitch struct
    https://git.kernel.org/netdev/net-next/c/9f8c7100c8f9
  - [net-next,V2,03/11] net/mlx5: E-Switch, Use xarray for vport number to vport and rep mapping
    https://git.kernel.org/netdev/net-next/c/47dd7e609f69
  - [net-next,V2,04/11] net/mlx5: E-Switch, Consider SF ports of host PF
    https://git.kernel.org/netdev/net-next/c/87bd418ea751
  - [net-next,V2,05/11] net/mlx5: SF, Rely on hw table for SF devlink port allocation
    https://git.kernel.org/netdev/net-next/c/1d7979352f9f
  - [net-next,V2,06/11] devlink: Extend SF port attributes to have external attribute
    https://git.kernel.org/netdev/net-next/c/a1ab3e4554b5
  - [net-next,V2,07/11] net/mlx5: SF, Store and use start function id
    https://git.kernel.org/netdev/net-next/c/7e6ccbc18784
  - [net-next,V2,08/11] net/mlx5: SF, Consider own vhca events of SF devices
    https://git.kernel.org/netdev/net-next/c/326c08a02034
  - [net-next,V2,09/11] net/mlx5: SF, Use helpers for allocation and free
    https://git.kernel.org/netdev/net-next/c/01ed9550e8b4
  - [net-next,V2,10/11] net/mlx5: SF, Split mlx5_sf_hw_table into two parts
    https://git.kernel.org/netdev/net-next/c/a3088f87d984
  - [net-next,V2,11/11] net/mlx5: SF, Extend SF table for additional SF id range
    https://git.kernel.org/netdev/net-next/c/f1b9acd3a5e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


