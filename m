Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58463DEAF1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhHCKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234674AbhHCKaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6038960F58;
        Tue,  3 Aug 2021 10:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627986608;
        bh=S8z0AAZfPFJXlbyou4+G8ZqAuKRTyfPtxQDegjtgtU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Heu4hJj9TXwb6g9DYTAkX9F126gne2m6jOD4lz6Ju4EKDJ0Eec0MYm4DCowTZLYLD
         TrXhY4DbqLia+aNck2JPhbfkJxVk5M3J0aXimC8bIxXJ8tRAPaOTSF2t6UkNlQ5AjO
         xnPRqP0v//tvXZwkEThdWRbt2X9CtRf0C+t3uUlXiQwB5nO21Fbmwx1rPIMECBXKWQ
         pvsBnNPWacmd0PNRs/EvKgaG0rtLcNRjO9XZ419Ppr5KPvTR7f0Vo+Jd+ifti07giL
         JScWqblCayBWaPE/inHRoI9eMPiJBkKS0/rqY/OZWxoxMenxCM5v+8tIva/muDX7Go
         /JQGWNeqSfABQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5231B60075;
        Tue,  3 Aug 2021 10:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5e: Use a new initializer to build uniform
 indir table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798660833.25993.7472655445790478959.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 10:30:08 +0000
References: <20210803022853.106973-2-saeed@kernel.org>
In-Reply-To: <20210803022853.106973-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maximmi@nvidia.com, tariqt@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 19:28:38 -0700 you wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> Replace mlx5e_build_default_indir_rqt with a new initializer of struct
> mlx5e_rss_params_indir that works directly with the struct, rather than
> its internals.
> 
> The new initializer is called mlx5e_rss_params_indir_init_uniform, which
> also reflects the purpose (uniform spreading) better.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5e: Use a new initializer to build uniform indir table
    https://git.kernel.org/netdev/net-next/c/43befe99bc62
  - [net-next,02/16] net/mlx5e: Introduce mlx5e_channels API to get RQNs
    https://git.kernel.org/netdev/net-next/c/e6e01b5fdc28
  - [net-next,03/16] net/mlx5e: Hide all implementation details of mlx5e_rx_res
    https://git.kernel.org/netdev/net-next/c/43ec0f41fa73
  - [net-next,04/16] net/mlx5e: Allocate the array of channels according to the real max_nch
    https://git.kernel.org/netdev/net-next/c/3ac90dec3a01
  - [net-next,05/16] net/mlx5e: Rename traffic type enums
    https://git.kernel.org/netdev/net-next/c/d443c6f684d3
  - [net-next,06/16] net/mlx5e: Rename some related TTC args and functions
    https://git.kernel.org/netdev/net-next/c/5fba089e960c
  - [net-next,07/16] net/mlx5e: Decouple TTC logic from mlx5e
    https://git.kernel.org/netdev/net-next/c/bc29764ed9a2
  - [net-next,08/16] net/mlx5: Move TTC logic to fs_ttc
    https://git.kernel.org/netdev/net-next/c/371cf74e78f3
  - [net-next,09/16] net/mlx5: Embed mlx5_ttc_table
    https://git.kernel.org/netdev/net-next/c/f4b45940e9b9
  - [net-next,10/16] net/mlx5e: Remove redundant tc act includes
    https://git.kernel.org/netdev/net-next/c/696ceeb203c7
  - [net-next,11/16] net/mlx5e: Remove redundant filter_dev arg from parse_tc_fdb_actions()
    https://git.kernel.org/netdev/net-next/c/70f8019e7b56
  - [net-next,12/16] net/mlx5e: Remove redundant cap check for flow counter
    https://git.kernel.org/netdev/net-next/c/950b4df9fba9
  - [net-next,13/16] net/mlx5e: Remove redundant parse_attr arg
    https://git.kernel.org/netdev/net-next/c/c6cfe1137f88
  - [net-next,14/16] net/mlx5e: Remove redundant assignment of counter to null
    https://git.kernel.org/netdev/net-next/c/97a8d29ae9d2
  - [net-next,15/16] net/mlx5e: Return -EOPNOTSUPP if more relevant when parsing tc actions
    https://git.kernel.org/netdev/net-next/c/25f150f4bbe9
  - [net-next,16/16] net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()
    https://git.kernel.org/netdev/net-next/c/bcd68c04c769

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


