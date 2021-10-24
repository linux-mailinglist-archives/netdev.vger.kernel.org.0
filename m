Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC24388DE
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhJXMm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhJXMm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20C7E60F46;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079207;
        bh=uGP3LmzkYq67dd3v96nK4s87J11YBL7AtQFFFF7ZRhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o8XN0lT8gTmy11/TB7kQe4wJysZx2moTq2bzLg8/DSfYhB4cfqCrEaBDLVYv9bGt6
         quOLCUVZTn0qeKlMTK4xJmqj2ABBZmVFl96P9S15IoF6GbHWUq6eKv+5i/9YeY5eDX
         2RxHgooCS29Qo7n47AnXdW6G+wqLpPpQkaL6UMAsAmW2aeUYDOoh2LAgYALMMirt/T
         XE1XzSC5fpedlFT5dpyhtwxJ/2taccF9kf6yWFTkj1AjVVaNXISiVTNYDKFfar2gwx
         KUVvP+hXL1yRyKdx4QivxbwzmHUYIM0NMgiuBmTOj1T0O9z05RLvFoTKkgQQB9cYG7
         /TNVTCB7epwXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1334B60A21;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Fix driver crash when
 lan743x_pm_resume fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507920707.28969.15646010045695299411.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:40:07 +0000
References: <20211022151353.89908-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211022151353.89908-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 11:13:53 -0400 you wrote:
> The driver needs to clean up and return when the initialization fails on resume.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
    https://git.kernel.org/netdev/net/c/d6423d2ec39c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


