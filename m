Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E093E3426
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhHGIkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhHGIkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D5E4F61052;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628325605;
        bh=zlL9JIUIOF7wyXReo/dORhij+k8kFatTXxcOUgAWbho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uGxsF1M9b2pMeUSzSdUKi6JnXO4sTZM47D1pC3MBk2zQfPSVg+kRNh9tifmYBlpFL
         klndjGRTi4WBxStTppP2bE1hbK/9i4Uv73Bfxpw+svsTHsz9sYQc9/XegTh7j8GDsF
         PiYzNhGa+JA1f+NgefkRT/dI0uR9WieEicK+6vVzF7+HnEFUJ/970iNicqT7nvwkiG
         oXwc9k1u9vXU8/Nbh+85Xsgh+3xN0U+ZGOQD/RyGEJEX4L2vdwmG3/gjcLplKTkihQ
         Aam8VeEByf7GtJaZDf+Y//tMaCPFqytKrWnQz4Ex3qUgOYV9ZxhH53nn7/BS4zAiVq
         zH+z/ghTKEHSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C292A60A7C;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix possible deadlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832560579.30769.12000853900536681427.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:40:05 +0000
References: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  6 Aug 2021 12:35:09 +0200 you wrote:
> Lockdep detected possible interrupt unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&mhiwwan->rx_lock);
>                                local_irq_disable();
>                                lock(&mhi_cntrl->pm_lock);
>                                lock(&mhiwwan->rx_lock);
>    <Interrupt>
>      lock(&mhi_cntrl->pm_lock);
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: mhi_wwan_ctrl: Fix possible deadlock
    https://git.kernel.org/netdev/net/c/34737e1320db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


