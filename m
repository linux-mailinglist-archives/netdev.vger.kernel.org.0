Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1A33495C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhCJVA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhCJVAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A8E864FF6;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=8GVPkq0BzaWanl/M2uEB1frzJLgFy9PYA9vuPO4CIK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5m+PUgn2OGR5Oqjt/VgYUMFxCM0Dj42EC4lVL6mhHDW3swFqz9qV6Qr6BM/OCxgP
         LJygy3Marw/LjSshVlUpR1/yk2dzK/Al3/HT7DmIKltKHDOfeJK/gCxFnoVcR3Rhx1
         TwlcKLmg99JnaFpNB97JO5oVtU4DaR5CZcSmYfBHm1IicnoN6dzMsS7brA1cujXcnZ
         wk/AkSvkla6bkWxf5j/0sFO6B3LYLtDXtEJ1RUU4dTEOnTZ6kBEYkIy+vPYiycrldC
         5doeXAO0/FCpJ9hDgBHA239QpWnU+3kjfQWoiQJM9mdNMPPylOAvszcbb42vlAEK82
         UhdW6w6/hEHCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 181A560970;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001309.4631.7123236482456442673.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210310015135.293794-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, andy.shevchenko@gmail.com, davem@davemloft.net,
        axboe@kernel.dk, viro@zeniv.linux.org.uk,
        herbert@gondor.apana.org.au, dong.menglong@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Mar 2021 17:51:35 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The bit mask for MSG_* seems a little confused here. Replace it
> with BIT() to make it clear to understand.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [v4,RESEND,net-next] net: socket: use BIT() for MSG_*
    https://git.kernel.org/netdev/net-next/c/0bb3262c0248

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


