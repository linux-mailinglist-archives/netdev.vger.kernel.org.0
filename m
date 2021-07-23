Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66723D3E03
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhGWQTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230064AbhGWQTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E581660E98;
        Fri, 23 Jul 2021 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059604;
        bh=h1WxRqe4Rb9K/gFjGg5RajjxIQUAgc0YmojtJ2166MI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pGT3/W1/AaUVUHe5AyGn4OCQBgwTz6qVloQ5nZSfF/cvfq8vXtrJEmnFCQNNTYT3l
         DNncRq3NPGq9uMdAyDFxnwePHCA7EClOaJIBrXFzA5wz0SJxl9M0xBqusuHcLeqy0I
         xj4aeByFql2ZuBg2fE3OATMVFHlFoJvsRnqcvz3VAyLzCeWRkxXaidIWNV5hNiewem
         5LKCJKCzgglN8rI7GUJgkb2LBhhlJpgmW+YXSj1sijJpDAXd55SxiOmF43LAi+xU7Y
         tioK7M4QzsVZHwXr+wAfieLVKG2HTwS12B9fkgzhmNahz24lpbHOl6tFWzuBJ3T6WV
         TlXkN7OoEbq3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA08A60976;
        Fri, 23 Jul 2021 17:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: Remove unused including <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705960488.25754.4752826923995126994.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 17:00:04 +0000
References: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     lxu@maxlinear.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 18:38:27 +0800 you wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> Eliminate the follow versioncheck warning:
> 
> ./drivers/net/phy/mxl-gpy.c: 9 linux/version.h not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: phy: Remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/94a994d2b2b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


