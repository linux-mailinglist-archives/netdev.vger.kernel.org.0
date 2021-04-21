Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53C5367225
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245106AbhDUSAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243404AbhDUSAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B8D161430;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619028009;
        bh=buIETy7upFK6TSCnCgQODs3dE6WQrFdngdO1AaxIK/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KDF0cDaaukux2XsqEWbKSLwPawGg81OnCqFbCyOQiLPwBZXYyWbuQd3G3N+gx/lgE
         XQ+kq/VbUlRNQmWl/l0IHaaap4CYGQb+sIKknOIS5V4yskcEHEPjqXdU/UzkKzdJhQ
         BnwV3CjoCd07giMkPhCSr6LiHFbzRHPAhuiWFan92UvXDRL2LieIUUJnl29oPS9Q0e
         K6bTp+q3dUyDK6z1QfpmlDB52Qz8xrHgXJYTR43Zr7cKIapdbJ7ViiogS+6liUxReg
         T/19wPcNKR0ToC5g9Ehzw3sLn/UVHEGmJAKLSAJ/JCenueY9hUiWgleHbvwuWpDddu
         LidrZFEDEAWRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9037960A52;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of frames
 are received
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:00:09 +0000
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 13:52:46 +0900 you wrote:
> When a lot of frames were received in the short term, the driver
> caused a stuck of receiving until a new frame was received. For example,
> the following command from other device could cause this issue.
> 
>     $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>
> 
> The previous code always cleared the interrupt flag of RX but checks
> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
> ravb_rx() in the next time until a new RX frame was received if
> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
> regardless the interrupt flags condition.
> 
> [...]

Here is the summary with links:
  - net: renesas: ravb: Fix a stuck issue when a lot of frames are received
    https://git.kernel.org/netdev/net/c/5718458b092b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


