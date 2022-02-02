Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA534A7322
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbiBBOaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:30:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46438 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiBBOaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A102E61896
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 103E2C340ED;
        Wed,  2 Feb 2022 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643812214;
        bh=hiW5hu2KXtivS3LM8W8yLh7LYmCnVllOEQC7AkvANFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HDdIZD/LkFgRt9YXVIv6yYZHZcd4/snBhXT3vfVZ5mzY9leLfqwWtE3JG9f8AdIJd
         UnBPCLn1HKIKPlGpU1fxtcikdyILgsuA0pPtIQC/XwQucxJI9mG1SAItjklWI3Vxqt
         v1ex0jh7w96a0fZJijuk6ceMwh+9t50dz7PJ05NG96Og6zOK8qrxWHAO0AtK82LK7/
         TUHiZW6VK3HtCDNUfz4LSQ5bnfBuhMI3965OlVdB5ZJ1WCxkD5iHHf70QDuAoqFPuU
         h6qIV2D51X9DFjgd10zzT6NPRdik+yyIpLUVMhFctMB8VplDs/Fm5DJHBzLAnheZg8
         5Zq7wbsi+S7uA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4E4CE5D07E;
        Wed,  2 Feb 2022 14:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/18] net/mlx5: Bridge, take rtnl lock in init error handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164381221392.12939.767094566501593743.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 14:30:13 +0000
References: <20220202050404.100122-2-saeed@kernel.org>
In-Reply-To: <20220202050404.100122-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vladbu@nvidia.com, roid@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue,  1 Feb 2022 21:03:47 -0800 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> The mlx5_esw_bridge_cleanup() is expected to be called with rtnl lock
> taken, which is true for mlx5e_rep_bridge_cleanup() function but not for
> error handling code in mlx5e_rep_bridge_init(). Add missing rtnl
> lock/unlock calls and extend both mlx5_esw_bridge_cleanup() and its dual
> function mlx5_esw_bridge_init() with ASSERT_RTNL() to verify the invariant
> from now on.
> 
> [...]

Here is the summary with links:
  - [net,01/18] net/mlx5: Bridge, take rtnl lock in init error handler
    https://git.kernel.org/netdev/net/c/04f8c12f031f
  - [net,02/18] net/mlx5: Bridge, ensure dev_name is null-terminated
    https://git.kernel.org/netdev/net/c/350d9a823734
  - [net,03/18] net/mlx5e: TC, Reject rules with drop and modify hdr action
    https://git.kernel.org/netdev/net/c/a2446bc77a16
  - [net,04/18] net/mlx5e: Fix module EEPROM query
    https://git.kernel.org/netdev/net/c/4a08a131351e
  - [net,05/18] net/mlx5: Use del_timer_sync in fw reset flow of halting poll
    https://git.kernel.org/netdev/net/c/3c5193a87b0f
  - [net,06/18] net/mlx5e: TC, Reject rules with forward and drop actions
    https://git.kernel.org/netdev/net/c/5623ef8a1188
  - [net,07/18] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
    https://git.kernel.org/netdev/net/c/55b2ca702cfa
  - [net,08/18] net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion
    https://git.kernel.org/netdev/net/c/880b51769190
  - [net,09/18] net/mlx5e: Fix wrong calculation of header index in HW_GRO
    https://git.kernel.org/netdev/net/c/b8d91145ed7c
  - [net,10/18] net/mlx5e: Fix broken SKB allocation in HW-GRO
    https://git.kernel.org/netdev/net/c/7957837b816f
  - [net,11/18] net/mlx5e: Fix handling of wrong devices during bond netevent
    https://git.kernel.org/netdev/net/c/ec41332e02bd
  - [net,12/18] net/mlx5: E-Switch, Fix uninitialized variable modact
    https://git.kernel.org/netdev/net/c/d8e5883d694b
  - [net,13/18] net/mlx5e: Don't treat small ceil values as unlimited in HTB offload
    https://git.kernel.org/netdev/net/c/736dfe4e68b8
  - [net,14/18] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
    https://git.kernel.org/netdev/net/c/5352859b3bfa
  - [net,15/18] net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic
    https://git.kernel.org/netdev/net/c/de47db0cf7f4
  - [net,16/18] net/mlx5e: Avoid implicit modify hdr for decap drop rule
    https://git.kernel.org/netdev/net/c/5b209d1a22af
  - [net,17/18] net/mlx5e: Use struct_group() for memcpy() region
    https://git.kernel.org/netdev/net/c/6d5c900eb641
  - [net,18/18] net/mlx5e: Avoid field-overflowing memcpy()
    https://git.kernel.org/netdev/net/c/ad5185735f7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


