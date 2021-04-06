Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279C0355F71
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344262AbhDFXaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244103AbhDFXaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61087613C4;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751810;
        bh=CGOWuChaHNkIDx4ir35Rqv2cA1xcKQRLw+phIqPOarI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SBfTDEjJpYEVex9Rmv1dZtOcty5hWa0ZFleujL8XfV+rURVlTrvvlm3yejALolkRB
         9NOxyOw3V34gxFlYwM4KNVAHUoL2orqUbj3tdPtqLqiX2vQ1lN0xAa7jdk/yoOOe60
         7lCqXGnvmGC78nslDUDcH9XabOO+j2PkjHixKd+i3+kpOQrKsGcC6ZpjMzyGYq77Su
         rUAFOv5R/u1tFqh463exVuXCX7glopRsVwqKDDxQhQZnCknsWJ7alUjQSSolf2thNn
         HcugPU9vpgTGzCQiGJuUM+2Bqpt378OjGE7+qX73ItE+f4KTv0O+I9QRd3S86kAbpV
         A8qtfGK9x+QfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55F3860A50;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] usbnet: speed reporting for devices without
 MDIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775181034.15996.11696477162112328110.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:30:10 +0000
References: <20210405231344.1403025-1-grundler@chromium.org>
In-Reply-To: <20210405231344.1403025-1-grundler@chromium.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     oneukum@suse.com, kuba@kernel.org, roland@kernel.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  5 Apr 2021 16:13:40 -0700 you wrote:
> This series introduces support for USB network devices that report
> speed as a part of their protocol, not emulating an MII to be accessed
> over MDIO.
> 
> v2: rebased on recent upstream changes
> v3: incorporated hints on naming and comments
> v4: fix misplaced hunks; reword some commit messages;
>     add same change for cdc_ether
> v4-repost: added "net-next" to subject and Andrew Lunn's Reviewed-by
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] usbnet: add _mii suffix to usbnet_set/get_link_ksettings
    https://git.kernel.org/netdev/net-next/c/77651900cede
  - [net-next,v4,2/4] usbnet: add method for reporting speed without MII
    https://git.kernel.org/netdev/net-next/c/956baa99571b
  - [net-next,v4,3/4] net: cdc_ncm: record speed in status method
    https://git.kernel.org/netdev/net-next/c/eb47c274d8c4
  - [net-next,v4,4/4] net: cdc_ether: record speed in status method
    https://git.kernel.org/netdev/net-next/c/d42ebcbb6353

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


