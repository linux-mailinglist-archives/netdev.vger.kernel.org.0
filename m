Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1825841948D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhI0Mvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhI0Mvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7006C6103B;
        Mon, 27 Sep 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632747007;
        bh=RfMVVEYwLXlJQtifQatE0TKLghd7f3jEIb1iS8M5hOc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhXWF+naTgNAHBKCQoATPuKBsnT6GHZWC+hM2l5XkWIOgXpUxlwLx3oC2xYnO2hu2
         hgdaNgjiZRusPayTpaXk6a6Hot7bKhy0uzGuOmLE5YTzf43MAqLSKe9c+Ovt7/XYUX
         BAtnZiA2lyhNidkJf5k5avFdH0Otc2wRSTA7wrI1UgbuDnMvRfi3qPBLce3IZy8HXo
         gINtblBT5PWtmHDW1IfmVHp6t3xZ8yfLtWlLr1FikLdD5mr0aYy+rdG2yVPRabF1UJ
         u70AnMXFQ8xEKllMJgDb2cjfhB5GxkMEEjR0+KF/fPrxxfFQ6dkCjqwJNLbyTwsQi+
         45luCf55/1toA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6393B609CF;
        Mon, 27 Sep 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: enhance GPY115 loopback disable function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274700740.11108.17763520319125595730.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:50:07 +0000
References: <20210927070302.27956-1-lxu@maxlinear.com>
In-Reply-To: <20210927070302.27956-1-lxu@maxlinear.com>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        vee.khee.wong@linux.intel.com, linux@armlinux.org.uk,
        hmehrtens@maxlinear.com, tmohren@maxlinear.com,
        mohammad.athari.ismail@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 15:03:02 +0800 you wrote:
> GPY115 need reset PHY when it comes out from loopback mode if the firmware
> version number (lower 8 bits) is equal to or below 0x76.
> 
> Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---
> v2 changes:
>   Remove wrong comment.
>   Use genphy_soft_reset instead of modifying MII_BMCR register to trigger PHY reset.
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: enhance GPY115 loopback disable function
    https://git.kernel.org/netdev/net/c/3b1b6e82fb5e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


