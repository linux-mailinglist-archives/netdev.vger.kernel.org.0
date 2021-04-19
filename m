Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B08E364EA1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhDSXas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232013AbhDSXak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CEAF60FDA;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618875009;
        bh=QavP1sTNt+8jY2rd+ZDjU3e9lFiXK6rt88oRb4zt71s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=epZ0U8dHWuISrPZ0UpW2RjofCpx2l3R1PHgRdQ8eDoCch/iebBbOPv2C3jp8NEzcR
         EjeZsekDJcW8BkhyWECfIuif6NT0CKiWilyfugbcCwAIvFWApKwa366xMvvBgWEM6O
         tZeHtvH6obopz8lXxKBUfPckb7E1Da5J1oBD30bsNwUfnD0gzg8tXZyh5UMsJC8bMD
         wpcU2sgG23qSH4ZthZejWI2aKz9yEDTBvn5uPH7LTkLqqJAeeDyZDKzd4mkvI/D3Lk
         r3FSjUwFr7gcbtMejZ2AVSRAXhiJee7D89toiloKUrC5x7wcGD2dvzgFXdJ73psnUW
         RiCglnH0eSYNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EC6960A2A;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] TJA1103 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887500951.9960.509121442275635477.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:30:09 +0000
References: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 19:13:58 +0300 you wrote:
> Hi,
> 
> This small series adds the TJA1103 PHY driver.
> 
> Changes in v3:
>  - use phy_read_mmd_poll_timeout instead of spin_until_cond
>  - changed the phy name from a generic one to something specific
>  - minor indentation change
> 
> [...]

Here is the summary with links:
  - [v3,1/2] net: phy: add genphy_c45_pma_suspend/resume
    https://git.kernel.org/netdev/net-next/c/da702f34e3cc
  - [v3,2/2] phy: nxp-c45: add driver for tja1103
    https://git.kernel.org/netdev/net-next/c/b050f2f15e04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


