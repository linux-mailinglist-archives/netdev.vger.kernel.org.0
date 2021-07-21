Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19AB3D13F0
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhGUPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhGUPj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32F1B6120E;
        Wed, 21 Jul 2021 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626884404;
        bh=yfzktShaenKKY6f/jHgXM1w6yfBfGswrZcWPAb1Van0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G+HnaKHOFELhpbW03YwFECxgOaeUvNOTa8DYOf7Wc0lwVxWy0qFovwp/60VvwKDfN
         tO1cVA6EMLWQPXgY7fVEHtaboNWIb6T+Dp9Z2rZZneib3d5VqIip5C87QYES4FRyKd
         36u49ezHbslvoawc+DjCLbqiPE2l7sSgCCcCk48OHBYCm3s3vV2QpXPlr1dFe9wQ32
         WCeYJatSkOJpwUeOnXgqtCNetxz4uADkA+VDpYRRs3tb3fx0+EGjC1waSI+gVExQwU
         53wQwowezVu+IVkLnbo1AVttB+DQgk84QTk7l+AvnRjyc19hfoeSmneA5DHfTwQ1Vw
         ichVt5Y9xWXbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2595160A0B;
        Wed, 21 Jul 2021 16:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ixp46x: fix ptp build failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688440414.4079.3088744442164036804.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:20:04 +0000
References: <20210721151951.2558679-1-arnd@kernel.org>
In-Reply-To: <20210721151951.2558679-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 17:19:32 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The rework of the ixp46x cpu detection left the network driver in
> a half broken state:
> 
> drivers/net/ethernet/xscale/ptp_ixp46x.c: In function 'ptp_ixp_init':
> drivers/net/ethernet/xscale/ptp_ixp46x.c:290:51: error: 'IXP4XX_TIMESYNC_BASE_VIRT' undeclared (first use in this function)
>   290 |                 (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
>       |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/xscale/ptp_ixp46x.c:290:51: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ethernet/xscale/ptp_ixp46x.c: At top level:
> drivers/net/ethernet/xscale/ptp_ixp46x.c:323:1: error: data definition has no type or storage class [-Werror]
>   323 | module_init(ptp_ixp_init);
> 
> [...]

Here is the summary with links:
  - net: ixp46x: fix ptp build failure
    https://git.kernel.org/netdev/net/c/161dcc024288

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


