Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC33896B4
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhESTbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231625AbhESTbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0908B610E9;
        Wed, 19 May 2021 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621452612;
        bh=wTll3dBqMbUkgCT0PZ6ZTZMVG1dCUAevXj/SHF0dMjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tVIWJoyKIgMYUS/57vRRhl3HKbnsi4EvdpXna5uCQLVxh2UiluKl8ZBD496J/uuio
         XwDJ6abKP8rliaxQhoJ4WsT3rWdqVx/d66qczbOWXKB8X71b34SoqF+d2DzvMsnebO
         Fzk1LEFg0sYMSZ+1b0jzV64nG8Q2zx7gpjyobpAluGtTrW8SmBVa0/yYweh3v8yC09
         j2LI8zvdSUect4Y0O/hKSC741girSSbpTnQBq4K/AhK81ClB6wT2N4+WAxcEv0lc20
         8NlnIL8+zG75PsIz8dkhDvRZSK49m6M5irylgMXy9Udr0pzyN4T7oK/yj7GiMlzZ+u
         R0cjgMbb9FBTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F061C60CD2;
        Wed, 19 May 2021 19:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/16] {net,
 RDMA}/mlx5: Fix override of log_max_qp by other device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145261197.25646.13415311906442925284.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:30:11 +0000
References: <20210519060523.17875-2-saeed@kernel.org>
In-Reply-To: <20210519060523.17875-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, leonro@nvidia.com, maorg@nvidia.com,
        mbloch@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 18 May 2021 23:05:08 -0700 you wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> mlx5_core_dev holds pointer to static profile, hence when the
> log_max_qp of the profile is override by some device, then it
> effect all other mlx5 devices that share the same profile.
> Fix it by having a profile instance for every mlx5 device.
> 
> [...]

Here is the summary with links:
  - [net,01/16] {net, RDMA}/mlx5: Fix override of log_max_qp by other device
    https://git.kernel.org/netdev/net/c/3410fbcd47dc
  - [net,02/16] net/mlx5e: Fix nullptr in add_vlan_push_action()
    https://git.kernel.org/netdev/net/c/dca59f4a7919
  - [net,03/16] net/mlx5: Set reformat action when needed for termination rules
    https://git.kernel.org/netdev/net/c/442b3d7b671b
  - [net,04/16] net/mlx5: Fix err prints and return when creating termination table
    https://git.kernel.org/netdev/net/c/fca086617af8
  - [net,05/16] net/mlx5: SF, Fix show state inactive when its inactivated
    https://git.kernel.org/netdev/net/c/82041634d96e
  - [net,06/16] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
    https://git.kernel.org/netdev/net/c/fe7738eb3ca3
  - [net,07/16] net/mlx5e: Fix null deref accessing lag dev
    https://git.kernel.org/netdev/net/c/83026d83186b
  - [net,08/16] net/mlx5e: Make sure fib dev exists in fib event
    https://git.kernel.org/netdev/net/c/eb96cc15926f
  - [net,09/16] net/mlx5e: reset XPS on error flow if netdev isn't registered yet
    https://git.kernel.org/netdev/net/c/77ecd10d0a8a
  - [net,10/16] net/mlx5e: Fix multipath lag activation
    https://git.kernel.org/netdev/net/c/97817fcc684e
  - [net,11/16] net/mlx5e: Reject mirroring on source port change encap rules
    https://git.kernel.org/netdev/net/c/7d1a3d08c8a6
  - [net,12/16] net/mlx5e: Fix error path of updating netdev queues
    https://git.kernel.org/netdev/net/c/5e7923acbd86
  - [net,13/16] {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table
    https://git.kernel.org/netdev/net/c/7c9f131f366a
  - [net,14/16] net/mlx5: Don't overwrite HCA capabilities when setting MSI-X count
    https://git.kernel.org/netdev/net/c/75e8564e919f
  - [net,15/16] net/mlx5: Set term table as an unmanaged flow table
    https://git.kernel.org/netdev/net/c/6ff51ab8aa8f
  - [net,16/16] mlx5e: add add missing BH locking around napi_schdule()
    https://git.kernel.org/netdev/net/c/e63052a5dd3c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


