Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878793A7024
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhFNUWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233295AbhFNUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EC986124B;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=g3tGQjOoqa8eRy0+pYfSj9oFL0aVqFwrn6FSoYfKRUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W+4U5nyVLYovk6hpeOjvHO9qqsyvTxO0dBII4b/+/V81K/qFrXDhhKKSm/JvhSBiv
         D/hJ3cqozPbJ0kjU8HsrnQjhG0SODsA19g3oAEJEddUbk2mTvB+8lVKZVcAF2HMul9
         eReqdQn0i0JPBBfTDjECD26yVNQpYgRHL2azplmzfTM4FQksK0IvL3FFlylc/JdnDl
         ZfIrpGFYyXrolMCzwj1cNEJCa4hsWqV5UpOtN5ySkCzVK3q1aKM2MXzDb8qZr9R2w1
         CyKc3N4j7rKjbsdsWuA8oSKd4mmD8ahKNPXbR00Cps3dJ/pYxje1ccojqIaclkxGlr
         OkPCfO1UHEEyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2CF42609E7;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] Marvell Prestera driver implementation of
 devlink functionality.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200617.25455.15935922022828642128.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vadym.kochan@plvision.eu, andrew@lunn.ch, nikolay@nvidia.com,
        idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 16:01:11 +0300 you wrote:
> This patch series implement Prestera Switchdev driver devlink traps,
> that are registered within the driver, as well as extend current devlink
> functionality by adding new hard drop statistics counter, that could be
> retrieved on-demand: the counter shows number of packets that have been
> dropped by the underlying device and haven't been passed to the devlink
> subsystem.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: core: devlink: add dropped stats traps field
    https://git.kernel.org/netdev/net-next/c/ddee9dbc3d7a
  - [net-next,v2,2/7] testing: selftests: net: forwarding: add devlink-required functionality to test (hard) dropped stats field
    https://git.kernel.org/netdev/net-next/c/53f1bd6b2819
  - [net-next,v2,3/7] drivers: net: netdevsim: add devlink trap_drop_counter_get implementation
    https://git.kernel.org/netdev/net-next/c/a7b3527a43fe
  - [net-next,v2,4/7] testing: selftests: drivers: net: netdevsim: devlink: add test case for hard drop statistics
    https://git.kernel.org/netdev/net-next/c/7a4f54798a53
  - [net-next,v2,5/7] net: marvell: prestera: devlink: add traps/groups implementation
    https://git.kernel.org/netdev/net-next/c/0a9003f45e91
  - [net-next,v2,6/7] net: marvell: prestera: devlink: add traps with DROP action
    https://git.kernel.org/netdev/net-next/c/a80cf955c9e5
  - [net-next,v2,7/7] documentation: networking: devlink: add prestera switched driver Documentation
    https://git.kernel.org/netdev/net-next/c/66826c43e63d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


