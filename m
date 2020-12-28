Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513372E6BFB
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgL1Wzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgL1Wkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9DE0E2226A;
        Mon, 28 Dec 2020 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609195206;
        bh=LOpW0D/hKl7s2Hevz0EZd1EZMNL9HK6X8L+OXqXX97E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tkzc327BEsdAWc3xBf7vYR2zsfcgDmwT/IfNeDLtAWzrvIhLpWsoQ9FfvT7WVHiE9
         mb/ZUBSbgpZPRKOkE34i0nqsDkYBBx0RpbvTJWQqX1J0bjnrHjek1Uq3Y6DGpaatLl
         IyJSL2bSz5MB1s/Y0bIW3Ot7dH+t6JyPk2ZqpuJNC+2xjcK8x7g6Zn8HU6b5j7x97X
         fvlnvlDc5n/4CMwJytmUJ1rGGerFr9WfniRJ9e0Yad5U5xacgkEw7MWOa/7EqBEjWu
         K6j5V+XnI71IL/crW5Xm/iXSRhh1qIsY6YTsIAMnk0si/v0FxQp+mf5RnmxuAbRzYg
         ghSjaaiHhNNZA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8EFF960591;
        Mon, 28 Dec 2020 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvpp2: fix pkt coalescing int-threshold
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160919520658.5818.13471657001953997070.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Dec 2020 22:40:06 +0000
References: <1608748521-11033-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608748521-11033-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Dec 2020 20:35:21 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> The packet coalescing interrupt threshold has separated registers
> for different aggregated/cpu (sw-thread). The required value should
> be loaded for every thread but not only for 1 current cpu.
> 
> Fixes: 213f428f5056 ("net: mvpp2: add support for TX interrupts and RX queue distribution modes")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] net: mvpp2: fix pkt coalescing int-threshold configuration
    https://git.kernel.org/netdev/net/c/4f374d2c43a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


