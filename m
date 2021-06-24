Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0053B399A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 01:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhFXXC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 19:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhFXXC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 19:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 75A7C6137D;
        Thu, 24 Jun 2021 23:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624575606;
        bh=1pKMl6v1lQ/RlqQ5s8/YdrNna9rEOulyFNfUgxs3deY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uT5hUTceq2ERVlhBVuY2ES7ns7FVTlW6t7QJpiD/jsCdN93f3GVx8tZMQ8Oj5O0IS
         U66a+xR3DZoA/zKBxZIQb4OJWFMIS26GI7SCpUR0cRJnaD0cdo67KLV2uV7TgxwzR5
         27WMGCFdDK/CK3ljfF2S2Xtk9tekezydZAgTgs3h1CGyq5h10n+EUJwRcxnbG2FgT/
         xD9oDzCQOsqrvwaRM9WOkZ0i9MlrOVMg+RLds3EgowGfsibT7kBxHNabbIU+evq2ZY
         O0VzP/t+jaR2325mTN+s3JlhF/1r03hPcGfE9t+cCXrRfZPWpzftH4cqS9fs5XaU1l
         Sn1j+7VUt/nXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68F9A60952;
        Thu, 24 Jun 2021 23:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: bcmgenet: Add mdio-bcm-unimac soft dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457560642.7534.18047903047924018273.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 23:00:06 +0000
References: <20210624032240.2609-1-jhp@endlessos.org>
In-Reply-To: <20210624032240.2609-1-jhp@endlessos.org>
To:     Jian-Hong Pan <jhp@endlessos.org>
Cc:     f.fainelli@gmail.com, stefan.wahren@i2se.com, opendmb@gmail.com,
        andrew@lunn.ch, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@endlessos.org, linux-rpi-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 11:22:41 +0800 you wrote:
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
  - [v3] net: bcmgenet: Add mdio-bcm-unimac soft dependency
    https://git.kernel.org/netdev/net-next/c/19938bafa7ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


