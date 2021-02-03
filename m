Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA130D200
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhBCDKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhBCDKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 22:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1446764F72;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612321812;
        bh=DVAsYtLHaLcMX/14PHFr2NNfXmhYY0D8BRSRrDo5Wjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n0zFNdOD/xTuOwQEvAwqMFw4y5BJxJk4/azHo8JCZYuiW7sbP5V3TKMbL4UO2UFzn
         nPB2qm94xg9Yn99w4b9U2lihk2orwlNj6yrV3gARHFpfSv9qcawoKe91RFQ9x7AzoN
         Y9NY0U2XJP++Vkt0edg0+R6hHIIwvQuMBTUS9aq+uTXlcFzAImm9ADHiVHtXCaBHbt
         OZz+biYpVSYWFt8SsDGFeirsiy+KlGNdt2SGrQbflbdithwXCkkhUVGX3Zk/4iZVWD
         XxLw7h3AJMGNqIfwXXhjOmTUTXVGWUz/iWN2eVipRtSIBq/Zo990jIBmfJ4L3VTaD1
         QmUSO3yZrSo/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0830F609E5;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/14] net/mlx5e: Separate between netdev objects and mlx5e
 profiles initialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161232181202.32173.7472689334752230766.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 03:10:12 +0000
References: <20210202065457.613312-2-saeed@kernel.org>
In-Reply-To: <20210202065457.613312-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        saeedm@nvidia.com, roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 22:54:44 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> 1) Initialize netdevice features and structures on netdevice allocation
>    and outside of the mlx5e profile.
> 
> 2) As now mlx5e netdevice private params will be setup on profile init only
>    after netdevice features are already set, we add  a call to
>    netde_update_features() to resolve any conflict.
>    This is nice since we reuse the fix_features ndo code if a profile
>    wants different default features, instead of duplicating features
>    conflict resolution code on profile initialization.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net/mlx5e: Separate between netdev objects and mlx5e profiles initialization
    https://git.kernel.org/netdev/net-next/c/3ef14e463f6e
  - [net-next,02/14] net/mxl5e: Add change profile method
    https://git.kernel.org/netdev/net-next/c/c4d7eb57687f
  - [net-next,03/14] net/mlx5e: Refactor mlx5e_netdev_init/cleanup to mlx5e_priv_init/cleanup
    https://git.kernel.org/netdev/net-next/c/c9fd1e33e989
  - [net-next,04/14] net/mlx5e: Move netif_carrier_off() out of mlx5e_priv_init()
    https://git.kernel.org/netdev/net-next/c/1227bbc5d09e
  - [net-next,05/14] net/mlx5e: Move set vxlan nic info to profile init
    https://git.kernel.org/netdev/net-next/c/84db66124714
  - [net-next,06/14] net/mlx5e: Avoid false lock depenency warning on tc_ht
    https://git.kernel.org/netdev/net-next/c/9ba33339c043
  - [net-next,07/14] net/mlx5e: Move representor neigh init into profile enable
    https://git.kernel.org/netdev/net-next/c/6b424e13b010
  - [net-next,08/14] net/mlx5e: Enable napi in channel's activation stage
    https://git.kernel.org/netdev/net-next/c/7637e499e219
  - [net-next,09/14] net/mlx5e: Increase indirection RQ table size to 256
    https://git.kernel.org/netdev/net-next/c/1dd55ba2fb70
  - [net-next,10/14] net/mlx5e: remove h from printk format specifier
    https://git.kernel.org/netdev/net-next/c/1d3a3f3bfe3c
  - [net-next,11/14] net/mlx5e: kTLS, Improve TLS RX workqueue scope
    https://git.kernel.org/netdev/net-next/c/26432001b5c4
  - [net-next,12/14] net/mlx5e: accel, remove redundant space
    https://git.kernel.org/netdev/net-next/c/8271e341ed63
  - [net-next,13/14] net/mlx5e: CT: remove useless conversion to PTR_ERR then ERR_PTR
    https://git.kernel.org/netdev/net-next/c/902c02458925
  - [net-next,14/14] net/mlx5: DR, Avoid unnecessary csum recalculation on supporting devices
    https://git.kernel.org/netdev/net-next/c/a283ea1b9716

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


