Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D94111B9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhITJNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236820AbhITJLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70DD4610F9;
        Mon, 20 Sep 2021 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632129011;
        bh=iiBHOnWdxnx2/aPPv3IhuZMddGrOHrwuThCwhWSmCgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tx+B1rXF5ixQ6rETWrNdyeMowgBB4cP/rACpfMqem5a6O4CuLocE+NRe60GSoDofE
         2CuMwGXBN1DdzpHVOekLrzGscMLImsLxdMKxP8vESAsrsCSROy3xQS/z3taUDjFCsM
         it9WojwD6fVUy1V2PPbXjBCkViaKJ4h+Bt770cP3lDhn0FCHv2AZ6WBKAJXs18Okny
         1tx3cuuXsgkfk/YD9AhnE24mBvLBSoGVzro3vh/ReS8XbhykPqZH4N6Ku5je2+7gZj
         D2/tv3quYZ5lRmVChumnPkhy8I3TTDSwoxq7lWXCLgSP8G6H/lVQzry9JJDzt0XRP/
         Dt/LxwrHw3FHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B63260A53;
        Mon, 20 Sep 2021 09:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/6] net: wwan: iosm: fw flashing & cd collection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163212901143.27858.1001521725257769247.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 09:10:11 +0000
References: <20210919172424.25764-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210919172424.25764-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 19 Sep 2021 22:54:24 +0530 you wrote:
> This patch series brings-in support for M.2 7560 Device firmware flashing &
> coredump collection using devlink.
> - Driver Registers with Devlink framework.
> - Register devlink params callback for configuring device params
>   required in flashing or coredump flow.
> - Implements devlink ops flash_update callback that programs modem
>   firmware.
> - Creates region & snapshot required for device coredump log collection.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/6] net: wwan: iosm: devlink registration
    https://git.kernel.org/netdev/net-next/c/4dcd183fbd67
  - [V2,net-next,2/6] net: wwan: iosm: fw flashing support
    https://git.kernel.org/netdev/net-next/c/b55734745568
  - [V2,net-next,3/6] net: wwan: iosm: coredump collection support
    https://git.kernel.org/netdev/net-next/c/09e7b002ff67
  - [V2,net-next,4/6] net: wwan: iosm: transport layer support for fw flashing/cd
    https://git.kernel.org/netdev/net-next/c/8d9be0634181
  - [V2,net-next,5/6] net: wwan: iosm: devlink fw flashing & cd collection documentation
    https://git.kernel.org/netdev/net-next/c/64302024bce5
  - [V2,net-next,6/6] net: wwan: iosm: fw flashing & cd collection infrastructure changes
    https://git.kernel.org/netdev/net-next/c/607d574aba6e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


