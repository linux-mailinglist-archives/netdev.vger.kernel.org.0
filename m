Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D5D3D68CE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhGZU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhGZU7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94D3160F8F;
        Mon, 26 Jul 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627335609;
        bh=0OcUf/qYRrzJHqItCjVcVDjKhhmL0+H1QZuACwMHSGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cLzGuxCA7N6Fj/zpfAUohg/Ca5VOV0kjrlyzy4tlS/zxGQe4omtLQNqDfUOdcNOdM
         lb7XskWUm+J+R6/+vAohCUxp9ent0ZsJad2xDYSGy1VR/vLDG0dW6+uAAwJp0Vx4uN
         x+Xgy5//xp16peMT9TLkBmYRLrVMRUbXyUIk0OPConul15k4+YOjIwSHo5aWPhV7A7
         GY+Kx/i0S1Takv1gb9tNpNSqFnTgZM34a4VC+0QZIWIeCkfB29ejgb0dEOWqDhaq8H
         NwuviKVjdjVdpMdDtyvkumTAxqFJdv2wzAgJYgsoPyoGqfST9T5Zy8ABw07DxRVyDR
         3vCC042O4n2sQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8846860972;
        Mon, 26 Jul 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5e: Prohibit inner indir TIRs in IPoIB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733560955.28049.12550604033505103215.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 21:40:09 +0000
References: <20210726165544.389143-2-saeed@kernel.org>
In-Reply-To: <20210726165544.389143-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 09:55:29 -0700 you wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> TIR's rx_hash_field_selector_inner can be enabled only when
> tunneled_offload_en = 1. tunneled_offload_en is filled according to the
> tunneled_offload_en field in struct mlx5e_params, which is false in the
> IPoIB profile. On the other hand, the IPoIB profile passes inner_ttc =
> true to mlx5e_create_indirect_tirs, which potentially allows the latter
> function to attempt to create inner indirect TIRs without having
> tunneled_offload_en set.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5e: Prohibit inner indir TIRs in IPoIB
    https://git.kernel.org/netdev/net-next/c/9c43f3865c2a
  - [net-next,02/16] net/mlx5e: Block LRO if firmware asks for tunneled LRO
    https://git.kernel.org/netdev/net-next/c/26ab7b384525
  - [net-next,03/16] net/mlx5: Take TIR destruction out of the TIR list lock
    https://git.kernel.org/netdev/net-next/c/69994ef3da66
  - [net-next,04/16] net/mlx5e: Check if inner FT is supported outside of create/destroy functions
    https://git.kernel.org/netdev/net-next/c/bc5506a166c3
  - [net-next,05/16] net/mlx5e: Convert RQT to a dedicated object
    https://git.kernel.org/netdev/net-next/c/06e9f13ac5cc
  - [net-next,06/16] net/mlx5e: Move mlx5e_build_rss_params() call to init_rx
    https://git.kernel.org/netdev/net-next/c/4ad31849771a
  - [net-next,07/16] net/mlx5e: Move RX resources to a separate struct
    https://git.kernel.org/netdev/net-next/c/3f22d6c77bb9
  - [net-next,08/16] net/mlx5e: Take RQT out of TIR and group RX resources
    https://git.kernel.org/netdev/net-next/c/0570c1c95817
  - [net-next,09/16] net/mlx5e: Use mlx5e_rqt_get_rqtn to access RQT hardware id
    https://git.kernel.org/netdev/net-next/c/093d4bc1731d
  - [net-next,10/16] net/mlx5e: Remove mlx5e_priv usage from mlx5e_build_*tir_ctx*()
    https://git.kernel.org/netdev/net-next/c/983c9da2b1e1
  - [net-next,11/16] net/mlx5e: Remove lro_param from mlx5e_build_indir_tir_ctx_common()
    https://git.kernel.org/netdev/net-next/c/a402e3a7470d
  - [net-next,12/16] net/mlx5e: Remove mdev from mlx5e_build_indir_tir_ctx_common()
    https://git.kernel.org/netdev/net-next/c/4b3e42eecb1c
  - [net-next,13/16] net/mlx5e: Create struct mlx5e_rss_params_hash
    https://git.kernel.org/netdev/net-next/c/6fe5ff2c7780
  - [net-next,14/16] net/mlx5e: Convert TIR to a dedicated object
    https://git.kernel.org/netdev/net-next/c/a6696735d694
  - [net-next,15/16] net/mlx5e: Move management of indir traffic types to rx_res
    https://git.kernel.org/netdev/net-next/c/65d6b6e5a5da
  - [net-next,16/16] net/mlx5e: Use the new TIR API for kTLS
    https://git.kernel.org/netdev/net-next/c/09f83569189f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


