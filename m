Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF4434C17
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJTNc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhJTNcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A3ABB61390;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634736610;
        bh=XLSDd/WOi6bQYdgykuOBwVSE30SK4md5jwoYHj4WcNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=agMR0mIK3jge+5ToaB+jB9mz/FS1kz69xrNzsKsppGnv625mQGHoKprXoV2TvdX6M
         WcFgxZ+yEAXOZM01HsKwcoha46kE/VsHt16jZezzXVaE7g0HLhTvQ1nMfH58X0rK07
         MRWiFKRmhqTqDyhlq537uFF+ffzQ24OcEin92uKFMvU5S0DSJKAc4G1dpXV2GvaLOf
         7gAJsr/FQeciKeBsNQRgdY+MAqWtAtdOk1J5h2UKD8F9UatwYdIXtrAsICwQXIbYWI
         GVvMgSkM+Tlb2q6hQZOX4BvqsZnHzdExKTca0DCRcykZHYsFYxrv73I8Hbfup8Ce4L
         HCuFri0OE0dAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94B2360A69;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: tidy for loop in setup and add
 cpu port check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473661060.3411.17432101259352940861.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:30:10 +0000
References: <20211019000850.14235-1-ansuelsmth@gmail.com>
In-Reply-To: <20211019000850.14235-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 02:08:50 +0200 you wrote:
> Tidy and organize qca8k setup function from multiple for loop.
> Change for loop in bridge leave/join to scan all port and skip cpu port.
> No functional change intended.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 74 ++++++++++++++++++++++++-----------------
>  1 file changed, 44 insertions(+), 30 deletions(-)

Here is the summary with links:
  - [net-next,v2] net: dsa: qca8k: tidy for loop in setup and add cpu port check
    https://git.kernel.org/netdev/net-next/c/040e926f5813

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


