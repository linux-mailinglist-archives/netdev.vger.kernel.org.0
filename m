Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E617431D2EC
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhBPXA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhBPXAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 18:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8432364E7C;
        Tue, 16 Feb 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613516409;
        bh=bE5OIedoHeCxppUvRDPjNpROSKM6Y/nSf8GltA3Giz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h+jQA7LgwHOixIR9PfSVC1HcNkvu6M/ggn/cj7v2YcFkuVB7+hNDLOEhWr8kPcfa4
         qNo6OAbXilIKFlUHRRS59GbKI+KINwwisNYKvqfzOPpzFJnoJpeRhvubz6VlP1FR3d
         iCAuYZx32L3VmickoadkgxRXDK0paFn/xk9aBwPrA+xLwdmPJTwZ4op3mAJNTWFinF
         49qb7sPwKJzW56QdAbB4qkGdaa5Bsp0vOAiGsSo10ftvGX18/mi/rmhLd5f3l0WvMd
         5OGFwOJ3A8EG9EsddVuIQE52Gdgz5g/tjkYpCUVNDEv5/Fgb4Jaw4S/DX0wxLZTKhP
         dFnm01Rr5SyEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 702DB60A0D;
        Tue, 16 Feb 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/8] bridge: mrp: Extend br_mrp_switchdev_*
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351640945.9841.8930466212434176971.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:00:09 +0000
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        ivecera@redhat.com, nikolay@nvidia.com, roopa@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        rasmus.villemoes@prevas.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 22:41:57 +0100 you wrote:
> This patch series extends MRP switchdev to allow the SW to have a better
> understanding if the HW can implement the MRP functionality or it needs
> to help the HW to run it. There are 3 cases:
> - when HW can't implement at all the functionality.
> - when HW can implement a part of the functionality but needs the SW
>   implement the rest. For example if it can't detect when it stops
>   receiving MRP Test frames but it can copy the MRP frames to CPU to
>   allow the SW to determine this.  Another example is generating the MRP
>   Test frames. If HW can't do that then the SW is used as backup.
> - when HW can implement completely the functionality.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] switchdev: mrp: Remove CONFIG_BRIDGE_MRP
    https://git.kernel.org/netdev/net-next/c/405be6b46b70
  - [net-next,v4,2/8] switchdev: mrp: Extend ring_role_mrp and in_role_mrp
    https://git.kernel.org/netdev/net-next/c/c513efa20c52
  - [net-next,v4,3/8] bridge: mrp: Add 'enum br_mrp_hw_support'
    https://git.kernel.org/netdev/net-next/c/e1bd99d07e61
  - [net-next,v4,4/8] bridge: mrp: Extend br_mrp_switchdev to detect better the errors
    https://git.kernel.org/netdev/net-next/c/1a3ddb0b7516
  - [net-next,v4,5/8] bridge: mrp: Update br_mrp to use new return values of br_mrp_switchdev
    https://git.kernel.org/netdev/net-next/c/cd605d455a44
  - [net-next,v4,6/8] net: mscc: ocelot: Add support for MRP
    https://git.kernel.org/netdev/net-next/c/d8ea7ff3995e
  - [net-next,v4,7/8] net: dsa: add MRP support
    https://git.kernel.org/netdev/net-next/c/c595c4330da0
  - [net-next,v4,8/8] net: dsa: felix: Add support for MRP
    https://git.kernel.org/netdev/net-next/c/a026c50b599f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


