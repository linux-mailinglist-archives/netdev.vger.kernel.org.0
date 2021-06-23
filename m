Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9B3B2209
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFWUwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWUwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1946610C7;
        Wed, 23 Jun 2021 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624481403;
        bh=iGDk3UpxbzKEJYRtb7TXOFgh99KpKpTDu3Cmlx+hgS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qhjs+dsnmtZq7QCrUd81Hsz0iDbcU3tLOGFNPtLB/zWFNHn8kI/KjgCbiftxEt/k3
         SqLf6Z9JrEGuv0x90AOMfCCZZP+wBclE0CvGgD5zLT+NCanorYf+CgkjkvbSkY2pwp
         3q24Tm2XFpFGn2HmMfGqvxldtWgrBCZ/zZcFWGHQOhGsep/p5DJ1Nc7BdnrZEhgrVl
         S/Zc2L0mCuOLJQwGnSxSMl2zAgyfbZ8o17wU+sKKhg+TRKaJpIaH1Lr9+jqfR9Tx2V
         rDB1HZ0c+Ji0pJ3lq4QeoO81me+PteIGN2M0hlqCNUoyfXqEuVjcfUPNRn3bfO4VGQ
         uMbkoiZWHr1zA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9AACC60A53;
        Wed, 23 Jun 2021 20:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 20:50:03 +0000
References: <20210623032802.3377-1-jhp@endlessos.org>
In-Reply-To: <20210623032802.3377-1-jhp@endlessos.org>
To:     Jian-Hong Pan <jhp@endlessos.org>
Cc:     f.fainelli@gmail.com, stefan.wahren@i2se.com, opendmb@gmail.com,
        andrew@lunn.ch, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@endlessos.org, linux-rpi-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Jun 2021 11:28:03 +0800 you wrote:
> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
> GENET fail to attach the PHY as following log:
> 
> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> ...
> could not attach to PHY
> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> uart-pl011 fe201000.serial: no DMA platform data
> libphy: bcmgenet MII bus: probed
> ...
> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> 
> [...]

Here is the summary with links:
  - [v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
    https://git.kernel.org/netdev/net/c/b2ac9800cfe0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


