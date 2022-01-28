Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0249F1A8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242207AbiA1DKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:10:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56124 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiA1DKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C0D61E17
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 436B1C340E7;
        Fri, 28 Jan 2022 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643339412;
        bh=gqa4iZHUHdQefhn8gqTqORmDakB0HRo9jyfE8QOQQ8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fVB6fEDA5+LUVaIdVg7ycF411mncyFvw5a9tXe8xW/V3I2iW8Ep6vYyBcuEW0KhDv
         weBCpaGe9NuGxyVie8PYovI49vZ0yfPwL1wqEqrsbbNKonZSSil/iESaJI5z74eakN
         sgbHWtWztBJ+FaZmwPEq5kyMnMWY7RZR3aEpOTcjA2D887BomPJ4/9PqoKo9jC47+4
         4KqplCro/ZuDMOgJJ7FgklQKMmn6YJnSqsLWuMUjpsKBJjX9TH4DUiMmAFUSH+PQHy
         MrByEvIO5IlUi7JWAPn0QabRgDK0uL9YG1nGPxZyrAnbMYhclz5E3RUlMNsjSJOCnZ
         qTz7bg5ekfnxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C454E5D07E;
        Fri, 28 Jan 2022 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-01-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164333941217.29137.14933929969109931760.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 03:10:12 +0000
References: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 27 Jan 2022 13:52:14 -0800 you wrote:
> Christophe Jaillet removes useless DMA-32 fallback calls from applicable
> Intel drivers and simplifies code as a result of the removal.
> 
> The following are changes since commit e2cf07654efb0fd7bbcb475c6f74be7b5755a8fd:
>   ptp: replace snprintf with sysfs_emit
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ixgb: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/64953720a2ba
  - [net-next,02/10] ixgbe: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/4d361c6fd8d4
  - [net-next,03/10] ixgbevf: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/90b83d013924
  - [net-next,04/10] i40e: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/10ebc5464e40
  - [net-next,05/10] e1000e: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/a34a42d87a08
  - [net-next,06/10] iavf: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/9498d4affd61
  - [net-next,07/10] ice: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/9c3e54a63263
  - [net-next,08/10] igc: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/fea89930f2a1
  - [net-next,09/10] igb: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/f80f4dc3b2c0
  - [net-next,10/10] igbvf: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/ac9178926649

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


