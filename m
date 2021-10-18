Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FAB431A42
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhJRNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhJRNCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DE80610A1;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634562007;
        bh=TyABXvjFHR4c2UlsVu5uX+e1NuSYvKAC1PLNjn/nrqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FYEjgva+liBLvwyqd8Qtu6KmK8u6XTd70Mopzqz8ZFEh8zKUrrcWqHp62pBhcFAQw
         C1iBqwSzsU/4gWDC1FycJpKyUQXfxb9I9m2YNhCy416a14LNjFGC2DoTEO5cn5IBaT
         PghRNvzOHogkRqokRoHP49LBzrCCSMoBffUWm94wIzClmMFuBivOlIbAjBeVsORxny
         OfzzoQ5uhOEUC32kFJDCDT8OlRmXONQfQvhhM+dT+QbUGhSlkHND36xcDpze6xrJit
         TrFMY4L9jPYoC+y7ldpm+iZkiJvwnIoide6bthfomydZYNP6o+kFBixzEazb4eoTxc
         kVxjPKedyVcNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CD6760A2E;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cavium: Return negative value when pci_alloc_irq_vectors()
 fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456200731.664.6465777662296342442.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 13:00:07 +0000
References: <1634523382-31553-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1634523382-31553-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 02:16:22 +0000 you wrote:
> During the process of driver probing, the probe function should return < 0
> for failure, otherwise, the kernel will treat value > 0 as success.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>  drivers/net/ethernet/cavium/thunder/nic_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - cavium: Return negative value when pci_alloc_irq_vectors() fails
    https://git.kernel.org/netdev/net/c/b2cddb44bddc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


