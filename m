Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDFD3F9870
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbhH0Laz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhH0Lay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 07:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25FD760ED3;
        Fri, 27 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630063806;
        bh=d65t+subOEG3qQewz7dDf3KopTPvKOUXy2MviZdA920=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uL+mDg6tMBzXw1zlmg6ITeHMoKt2DDXUSB6zCXD58Bm2W9avoa5R6lUbu1/5ROqP+
         tWyp+WZBBUe47tFnfWGF1axW9734zkGyJGUCtzpGDBeDOGk2BTg7QSBXhG6hN2slau
         nTGP9o8vIywmyhdIBzj1/ORT/tOIinWgAy2b8OHyLWZOejnsdSdKVZMmTLIdLE6iWk
         vMWiPGjwiYgaQDGIx0H2J/dwMfKMS/K8gwJeGl6JMbg2ZrJ7sMYQQR+CYkFBBfOIHJ
         pE6Wu/6Co5t83qS6fb0YoMkhLqfNG+1tiv+kEcUOEaO58EidWX5OtD6RZfeNt7b1S9
         I5pJz+jTdKcow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18BC660972;
        Fri, 27 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] phy: marvell: phy-mvebu-cp110-comphy: Rename HS-SGMMI to
 2500Base-X
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163006380609.3583.7131431178247172365.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 11:30:06 +0000
References: <20210827092753.2359-1-pali@kernel.org>
In-Reply-To: <20210827092753.2359-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     miquel.raynal@bootlin.com, kishon@ti.com, vkoul@kernel.org,
        rmk+kernel@armlinux.org.uk, andrew@lunn.ch, kabel@kernel.org,
        robh@kernel.org, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 11:27:51 +0200 you wrote:
> Comphy phy mode 0x3 is incorrectly named. It is not SGMII but rather
> 2500Base-X mode which runs at 3.125 Gbps speed.
> 
> Rename macro names and comments to 2500Base-X.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Fixes: eb6a1fcb53e2 ("phy: mvebu-cp110-comphy: Add SMC call support")
> Fixes: c2afb2fef595 ("phy: mvebu-cp110-comphy: Rename the macro handling only Ethernet modes")
> 
> [...]

Here is the summary with links:
  - [1/3] phy: marvell: phy-mvebu-cp110-comphy: Rename HS-SGMMI to 2500Base-X
    https://git.kernel.org/netdev/net-next/c/3f141ad61745
  - [2/3] phy: marvell: phy-mvebu-a3700-comphy: Rename HS-SGMMI to 2500Base-X
    https://git.kernel.org/netdev/net-next/c/b756bbec9cdd
  - [3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove unsupported modes
    https://git.kernel.org/netdev/net-next/c/0c1f5f2a5581

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


