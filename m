Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06AD4223E5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhJEKwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhJEKwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 06:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4FB761251;
        Tue,  5 Oct 2021 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633431009;
        bh=UTQJMxlTDh8DFJYWSGzBUnbLGeJaroZVsbsrdTFrmvo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QgG91PzTbbsvKmBi5avX3VkpHt1xGg/9xTcjGA2UuRAa/iGqE5D4B+mu2bdL8DCO4
         uJ2n27vzaT9we3CoBIBMYCeqJ7VHC+DC8jYd+B8x4j5lluRGMMF4WnR29aWIzbY/TU
         jlV4YdGYUCJVdCj0IDMCObXKf9GOXODBcVh1yQnPfJEOK2i3raBVw6tEibWQlZtjTc
         O4avlutCKB/g8EIrLhMMKoOBkfbXcQGRe5ZjPQ7B+xIvl184pkoh/AzSRU37J3xVcn
         kbO3/kUMRlhPYpO87veZmTcxyYD+pfraE26U8cR1RL5/GXWz0J3RC9nzHOC7CGnSgu
         jO5zKmhsY4sRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4CE260A39;
        Tue,  5 Oct 2021 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Specify SQ stats struct for
 mlx5e_open_txqsq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343100980.17486.14062772041812932187.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 10:50:09 +0000
References: <20211005011302.41793-2-saeed@kernel.org>
In-Reply-To: <20211005011302.41793-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  4 Oct 2021 18:12:48 -0700 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Let the caller of mlx5e_open_txqsq() directly pass the SQ stats
> structure pointer.
> This replaces logic involving the qos_queue_group_id parameter,
> and helps generalizing its role in the next patch.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Specify SQ stats struct for mlx5e_open_txqsq()
    https://git.kernel.org/netdev/net-next/c/e0ee6891174c
  - [net-next,02/15] net/mlx5e: Add TX max rate support for MQPRIO channel mode
    https://git.kernel.org/netdev/net-next/c/80743c4f8d34
  - [net-next,03/15] net/mlx5e: TC, Refactor sample offload error flow
    https://git.kernel.org/netdev/net-next/c/61c6f0d19084
  - [net-next,04/15] net/mlx5e: Move mod hdr allocation to a single place
    https://git.kernel.org/netdev/net-next/c/d9581e2fa73f
  - [net-next,05/15] net/mlx5e: Split actions_match_supported() into a sub function
    https://git.kernel.org/netdev/net-next/c/9c1d3511a2c2
  - [net-next,06/15] net/mlx5e: Move parse fdb check into actions_match_supported_fdb()
    https://git.kernel.org/netdev/net-next/c/d4f401d9ab18
  - [net-next,07/15] net/mlx5e: Reserve a value from TC tunnel options mapping
    https://git.kernel.org/netdev/net-next/c/3222efd4b3a3
  - [net-next,08/15] net/mlx5e: Specify out ifindex when looking up encap route
    https://git.kernel.org/netdev/net-next/c/2f8ec867b6c3
  - [net-next,09/15] net/mlx5e: Support accept action
    https://git.kernel.org/netdev/net-next/c/6ba2e2b33df8
  - [net-next,10/15] net/mlx5: Bridge, refactor eswitch instance usage
    https://git.kernel.org/netdev/net-next/c/a1a6e7217eac
  - [net-next,11/15] net/mlx5: Bridge, extract VLAN pop code to dedicated functions
    https://git.kernel.org/netdev/net-next/c/64fc4b358941
  - [net-next,12/15] net/mlx5: Bridge, mark reg_c1 when pushing VLAN
    https://git.kernel.org/netdev/net-next/c/5249001d69a2
  - [net-next,13/15] net/mlx5: Bridge, pop VLAN on egress table miss
    https://git.kernel.org/netdev/net-next/c/575baa92fd46
  - [net-next,14/15] net/mlx5: Shift control IRQ to the last index
    https://git.kernel.org/netdev/net-next/c/3663ad34bc70
  - [net-next,15/15] net/mlx5: Enable single IRQ for PCI Function
    https://git.kernel.org/netdev/net-next/c/f891b7cdbdcd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


