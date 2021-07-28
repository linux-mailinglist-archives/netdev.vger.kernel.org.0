Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627473D89C9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhG1IaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhG1IaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 04:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28C3D60FC2;
        Wed, 28 Jul 2021 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627461007;
        bh=3W8nPmdKah7YNRFAt3oGk8yJM/HPZGLcMCeSV55ppEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePxwS+Ut3/CO+IUBH04Cs22Ppj0XupjPwweWtM8x2imqpIb4XjMeg49KWDL0BuAN/
         6EyWYyKR/94JBEOCvvBuRJ/A/I1aTUSbHdIvox2sKfAbrS3y3pJpUhsib8316a8NhK
         X2AZHmMLZlDJHz5ocBmXoG+kgkXERg7fHteAWd78qNQlbfg7JtwZqDy5+Vow0QjvXF
         qQ95yqt41yIqfetsvamZrnNgHxpsPAx+Isnxa64Ai01GxBVbl7n/kN8k41hW+sZ5um
         6mkeVsSb3+gdPn90jH28uXhXYUnBV1OCksAFzPiUIUKvg75CUE5ErjwEUxbFItA+6o
         waQoE6mm1kBAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D028609F7;
        Wed, 28 Jul 2021 08:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5: Fix flow table chaining
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162746100711.27952.7505869598390036355.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 08:30:07 +0000
References: <20210727232050.606896-2-saeed@kernel.org>
In-Reply-To: <20210727232050.606896-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, maorg@nvidia.com, mbloch@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 27 Jul 2021 16:20:39 -0700 you wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Fix a bug when flow table is created in priority that already
> has other flow tables as shown in the below diagram.
> If the new flow table (FT-B) has the lowest level in the priority,
> we need to connect the flow tables from the previous priority (p0)
> to this new table. In addition when this flow table is destroyed
> (FT-B), we need to connect the flow tables from the previous
> priority (p0) to the next level flow table (FT-C) in the same
> priority of the destroyed table (if exists).
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5: Fix flow table chaining
    https://git.kernel.org/netdev/net/c/8b54874ef161
  - [net,02/12] net/mlx5e: Disable Rx ntuple offload for uplink representor
    https://git.kernel.org/netdev/net/c/90b22b9bcd24
  - [net,03/12] net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported
    https://git.kernel.org/netdev/net/c/c671972534c6
  - [net,04/12] net/mlx5: E-Switch, handle devcom events only for ports on the same device
    https://git.kernel.org/netdev/net/c/dd3fddb82780
  - [net,05/12] net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined
    https://git.kernel.org/netdev/net/c/e2351e517068
  - [net,06/12] net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available
    https://git.kernel.org/netdev/net/c/9841d58f3550
  - [net,07/12] net/mlx5e: Consider PTP-RQ when setting RX VLAN stripping
    https://git.kernel.org/netdev/net/c/a759f845d1f7
  - [net,08/12] net/mlx5e: Fix page allocation failure for trap-RQ over SF
    https://git.kernel.org/netdev/net/c/497008e78345
  - [net,09/12] net/mlx5e: Fix page allocation failure for ptp-RQ over SF
    https://git.kernel.org/netdev/net/c/678b1ae1af4a
  - [net,10/12] net/mlx5: Unload device upon firmware fatal error
    https://git.kernel.org/netdev/net/c/7f331bf0f060
  - [net,11/12] net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
    https://git.kernel.org/netdev/net/c/b1c2f6312c50
  - [net,12/12] net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32
    https://git.kernel.org/netdev/net/c/740452e09cf5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


