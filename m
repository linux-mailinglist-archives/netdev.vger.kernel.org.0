Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AECD308356
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhA2Bl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2BlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:41:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B512964DFB;
        Fri, 29 Jan 2021 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611884443;
        bh=gn0boGo0i6OhzskA+ZetZ2TKZ34mQ79bYIymS4IgZyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=unZ0WF/3b08K6QFU3ZPAwS7mqU7uGsKgnkU58VuvRmL9bGHRYCKs/gY5kJXqJZR6N
         PrjkjYtexWBSqRp3BxWoJlfIz70J9NZJzagCjD9CD6iv8DaF/j/9EXXYGWMw4Q0QbD
         HkGVnk/fBfAgdTG+TXZSxqRrKFZNY4rbMptCc286/+ZSXuyU92jzAsvAeTi4vMQczP
         GEKzTuysfxVyaB2OuSqLkBsmPuHGprUjU1Og5Ubjk9sBJIKNmb/rM9RcJ9XD/XeX8u
         pkmzQaZFSFNskwI+fsja1t6rbRQvHCz07SZz9Mfr+O/Dfjm7RKSWM94cLPhdz4WXQq
         sUIPzgcEHsspg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0B9F60ABF;
        Fri, 29 Jan 2021 01:40:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V10 01/14] devlink: Prepare code to fill multiple port
 function attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188444365.28226.8858255043128755888.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 01:40:43 +0000
References: <20210122193658.282884-2-saeed@kernel.org>
In-Reply-To: <20210122193658.282884-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, parav@nvidia.com, jiri@nvidia.com,
        vuhuong@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 22 Jan 2021 11:36:45 -0800 you wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Prepare code to fill zero or more port function optional attributes.
> Subsequent patch makes use of this to fill more port function
> attributes.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V10,01/14] devlink: Prepare code to fill multiple port function attributes
    https://git.kernel.org/netdev/net-next/c/1230d94820c9
  - [net-next,V10,02/14] devlink: Introduce PCI SF port flavour and port attribute
    https://git.kernel.org/netdev/net-next/c/b8288837ef6b
  - [net-next,V10,03/14] devlink: Support add and delete devlink port
    https://git.kernel.org/netdev/net-next/c/cd76dcd68d96
  - [net-next,V10,04/14] devlink: Support get and set state of port function
    https://git.kernel.org/netdev/net-next/c/a556dded9c23
  - [net-next,V10,05/14] net/mlx5: Introduce vhca state event notifier
    https://git.kernel.org/netdev/net-next/c/f3196bb0f14c
  - [net-next,V10,06/14] net/mlx5: SF, Add auxiliary device support
    https://git.kernel.org/netdev/net-next/c/90d010b8634b
  - [net-next,V10,07/14] net/mlx5: SF, Add auxiliary device driver
    https://git.kernel.org/netdev/net-next/c/1958fc2f0712
  - [net-next,V10,08/14] net/mlx5: E-switch, Prepare eswitch to handle SF vport
    https://git.kernel.org/netdev/net-next/c/d7f33a457bee
  - [net-next,V10,09/14] net/mlx5: E-switch, Add eswitch helpers for SF vport
    https://git.kernel.org/netdev/net-next/c/d970812b91d0
  - [net-next,V10,10/14] net/mlx5: SF, Add port add delete functionality
    https://git.kernel.org/netdev/net-next/c/8f0105418668
  - [net-next,V10,11/14] net/mlx5: SF, Port function state change support
    https://git.kernel.org/netdev/net-next/c/6a3273217469
  - [net-next,V10,12/14] devlink: Add devlink port documentation
    https://git.kernel.org/netdev/net-next/c/c736111cf8d5
  - [net-next,V10,13/14] devlink: Extend devlink port documentation for subfunctions
    https://git.kernel.org/netdev/net-next/c/6474ce7ecd80
  - [net-next,V10,14/14] net/mlx5: Add devlink subfunction port documentation
    https://git.kernel.org/netdev/net-next/c/142d93d12dc1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


