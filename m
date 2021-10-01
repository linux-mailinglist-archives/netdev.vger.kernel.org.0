Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BAD41E592
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351113AbhJAAlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238100AbhJAAlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 20:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 59EA561882;
        Fri,  1 Oct 2021 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633048807;
        bh=p0xBDBLpajH0ZQk507ad2Lis7BV+yGtwnsWbV9XSQbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aIXhMJztfXFKMewfo8yXiR2PHsDdLCiA/wye/OQylGGgpOtXEguXH0Q5wRCBzWIwj
         KPE+AV6QWkKK499XV0rOptCzjcqflVVA3DqK1qU5/9VHEgkIdGTvR4o4j1hWO3/Edu
         /DSZb5inkliXMmmYmGSHE8OWbH73V1zqGCRbgwc+03r2/Pfv15UhY+LCktknYYjG3N
         i+GjkIksxFrCJdLJUmelwvByT1a9MTXTSY4dh07cmGmkWpZOSj3IsFvp75VMSakrKl
         ST2x4GISJh9SC8SsjE+KglqF525MwU/DvsUw7vrMZ9Bch8Mqk6FVmvRohJfKKoD1OQ
         DZqvMfwwJfjxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D18B60AA0;
        Fri,  1 Oct 2021 00:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 1/2] Revert "net: mdiobus: Fix memory leak in
 __mdiobus_register"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163304880731.17936.15226510469738244218.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 00:40:07 +0000
References: <f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com>
In-Reply-To: <f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yanfei.xu@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 30 Sep 2021 20:49:42 +0300 you wrote:
> This reverts commit ab609f25d19858513919369ff3d9a63c02cd9e2e.
> 
> This patch is correct in the sense that we _should_ call device_put() in
> case of device_register() failure, but the problem in this code is more
> vast.
> 
> We need to set bus->state to UNMDIOBUS_REGISTERED before calling
> device_register() to correctly release the device in mdiobus_free().
> This patch prevents us from doing it, since in case of device_register()
> failure put_device() will be called 2 times and it will cause UAF or
> something else.
> 
> [...]

Here is the summary with links:
  - [v4,1/2] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
    https://git.kernel.org/netdev/net/c/10eff1f5788b
  - [v4,2/2] phy: mdio: fix memory leak
    https://git.kernel.org/netdev/net/c/ca6e11c337da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


