Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F3E33E187
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhCPWka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhCPWkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B908E64F3A;
        Tue, 16 Mar 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615934407;
        bh=7Ze08olMH7mJggc5iCGUIXidJGhvC5SOFsLsncbQIXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rkoaOB7Pj1j3Fvba/2/rc8aZl8vaMcV5MUk76NQ6uvIzQFCfhftiLs+wVo3Qcz2fy
         AH/eutfxbG0kG59MvosQXO/CdGD/X6+yZw5zDxwGdRbIYSfpDBxcbpgvKjBb31wh7A
         zVz32uNABiclVbuKL6F/SXsQujsHkPRzwZQ4p1aP0BEwDy4E7wxr6Ok5p8gIZ8N7X1
         u8kiW6w/St/hxzGk9PanfJt6lBA0MhH/TqIDtsk8nnZulESAp09aXczIut9/UKI+xO
         9vV9/2gbGJbKxrexJBhhKhm/jPgkXJYAthugCTWkcSs/aP3ApsCyRwUFS1iroeSIbM
         +nNOLMvBWO3jQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A97FA60A3D;
        Tue, 16 Mar 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: broadcom: BCM4908_ENET should not default to y,
 unconditionally
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593440769.11342.8353249095290612887.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:40:07 +0000
References: <20210316140341.2399108-1-geert+renesas@glider.be>
In-Reply-To: <20210316140341.2399108-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 15:03:41 +0100 you wrote:
> Merely enabling compile-testing should not enable additional code.
> To fix this, restrict the automatic enabling of BCM4908_ENET to
> ARCH_BCM4908.
> 
> Fixes: 4feffeadbcb2e5b1 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [...]

Here is the summary with links:
  - [v2] net: broadcom: BCM4908_ENET should not default to y, unconditionally
    https://git.kernel.org/netdev/net/c/a3bc48321665

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


