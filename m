Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D0943CC79
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhJ0Oml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238962AbhJ0Omf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88E4560F90;
        Wed, 27 Oct 2021 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635345609;
        bh=f580tMC4+91VTTONfGymY/kVPJ6DGDXSJt59J9HzqrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qYISt5sfmCZ2D9UIbVZYI38lbfxf5ARXr7E5iGoFZkXBHvgUn2JzJLnC7i7LdwhtL
         ADiKg6JEktYjN4i5Y2amjD/gDf1hwHDXI2TZSjGv9zESpZkATcveCjYqEtDJnzHx6O
         a4bA4rJGB9CblB161vR4wuH1IgEC4xOrPhDit9kM9uz/CYuEAaMPSevK908Swc6BtN
         POGDbSTVPJWX99lnoqX7ovaDJ3pBo11APjpcQoOQS/CGMo7MllyhJZ59Pqj5rSPnOv
         gJjsXeJJ2ZeznYVY4S5aM0pSAVIb8MKoc7hvdYR8AkSZYZNIM+3AcNjIDXk7Xv1QIs
         3tDja0QOkAZOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D46960A25;
        Wed, 27 Oct 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] Bridge FDB refactoring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163534560950.729.5232614315067836341.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 14:40:09 +0000
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, roopa@nvidia.com, nikolay@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 17:27:35 +0300 you wrote:
> This series refactors the br_fdb.c, br_switchdev.c and switchdev.c files
> to offer the same level of functionality with a bit less code, and to
> clarify the purpose of some functions.
> 
> No functional change intended.
> 
> Vladimir Oltean (8):
>   net: bridge: remove fdb_notify forward declaration
>   net: bridge: remove fdb_insert forward declaration
>   net: bridge: rename fdb_insert to fdb_add_local
>   net: bridge: rename br_fdb_insert to br_fdb_add_local
>   net: bridge: reduce indentation level in fdb_create
>   net: bridge: move br_fdb_replay inside br_switchdev.c
>   net: bridge: create a common function for populating switchdev FDB
>     entries
>   net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: bridge: remove fdb_notify forward declaration
    https://git.kernel.org/netdev/net-next/c/4682048af0c8
  - [net-next,2/8] net: bridge: remove fdb_insert forward declaration
    https://git.kernel.org/netdev/net-next/c/5f94a5e276ae
  - [net-next,3/8] net: bridge: rename fdb_insert to fdb_add_local
    https://git.kernel.org/netdev/net-next/c/4731b6d6b257
  - [net-next,4/8] net: bridge: rename br_fdb_insert to br_fdb_add_local
    https://git.kernel.org/netdev/net-next/c/f6814fdcfe1b
  - [net-next,5/8] net: bridge: reduce indentation level in fdb_create
    https://git.kernel.org/netdev/net-next/c/9574fb558044
  - [net-next,6/8] net: bridge: move br_fdb_replay inside br_switchdev.c
    https://git.kernel.org/netdev/net-next/c/5cda5272a460
  - [net-next,7/8] net: bridge: create a common function for populating switchdev FDB entries
    https://git.kernel.org/netdev/net-next/c/fab9eca88410
  - [net-next,8/8] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
    https://git.kernel.org/netdev/net-next/c/716a30a97a52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


