Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4EE2AA7F3
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgKGUuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGUuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604782205;
        bh=BifApJotwPCCxjhlvyHhDdYr+iDvzxfEmDg35E3yRjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNeqboVmB1MDysTxxdBgmU4F972W/MFmiODCEGTtEDkl903EllrRakNtmLAg3aaYe
         J0o9ivxLiTrqBpsBqz1OuFwh3bkhKbhc9pX236/M0+zpM52xFMle1jdpzMW53ITWop
         qvGMfFa2eg1F3OPM16/w3NwFu4vMtLyTGPYHp5TI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2 1/7] net/mlx5e: Fix modify header actions memory leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160478220555.18540.2570979913500058948.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 20:50:05 +0000
References: <20201105202129.23644-2-saeedm@nvidia.com>
In-Reply-To: <20201105202129.23644-2-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        maord@nvidia.com, paulb@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 5 Nov 2020 12:21:23 -0800 you wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> Modify header actions are allocated during parse tc actions and only
> freed during the flow creation, however, on error flow the allocated
> memory is wrongly unfreed.
> 
> Fix this by calling dealloc_mod_hdr_actions in __mlx5e_add_fdb_flow
> and mlx5e_add_nic_flow error flow.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] net/mlx5e: Fix modify header actions memory leak
    https://git.kernel.org/netdev/net/c/e68e28b4a9d7
  - [net,v2,2/7] net/mlx5e: Protect encap route dev from concurrent release
    https://git.kernel.org/netdev/net/c/78c906e430b1
  - [net,v2,3/7] net/mlx5e: Use spin_lock_bh for async_icosq_lock
    https://git.kernel.org/netdev/net/c/f42139ba4979
  - [net,v2,4/7] net/mlx5: Fix deletion of duplicate rules
    https://git.kernel.org/netdev/net/c/465e7baab6d9
  - [net,v2,5/7] net/mlx5: E-switch, Avoid extack error log for disabled vport
    https://git.kernel.org/netdev/net/c/ae3585944560
  - [net,v2,6/7] net/mlx5e: Fix VXLAN synchronization after function reload
    https://git.kernel.org/netdev/net/c/c5eb51adf06b
  - [net,v2,7/7] net/mlx5e: Fix incorrect access of RCU-protected xdp_prog
    https://git.kernel.org/netdev/net/c/1a50cf9a67ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


