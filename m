Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93B734847B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhCXWUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhCXWUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3954F61A1B;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624409;
        bh=ZKZgnfkdMke28qJ4ulpvPwNeGxnCHXX92AuHDbvYGag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r2tDJioEAL97ugx+QZbc/LgvDIEzf37ohmr5IatQbzaF8xiGv7miUDONzFqIamIxF
         ZJsUEaMtLSIwlGnr526M2OkdCqVEjChf1PxrLVHuYyuKOEFBKzImLUBwSz/X7h4uLf
         6Cfa7jiaYlPjNVXduXRhQ9ZD4Z7Go/rf6BgD3REGoASWaZW+aLrjUaJXcAxUgd+djh
         ECcQTOAFpxx9olkIXB2QN92gQhRJcPuQbU+ootLSsyVXyErZKaOGuAlbOSqt4SZIFH
         /06H5KAn/fXW+GNzze3auM4hc5nlyCYaQVEl+WuGYsNMTMUebif/Y4aTrE2oZRSNwC
         10A1uw4tq6wXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2802960A0E;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2: fix -Wnonnull warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662440915.20293.15686935184502381902.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 22:20:09 +0000
References: <20210323125337.1783611-1-arnd@kernel.org>
In-Reply-To: <20210323125337.1783611-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        cjacob@marvell.com, zyta@marvell.com, colin.king@canonical.com,
        rsaladi2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 13:53:29 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When compile testing this driver on a platform on which probe() is
> known to fail at compile time, gcc warns about the cgx_lmactype_string[]
> array being uninitialized:
> 
> In function 'strncpy',
>     inlined from 'link_status_user_format' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:838:2,
>     inlined from 'cgx_link_change_handler' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:853:2:
> include/linux/fortify-string.h:27:30: error: argument 2 null where non-null expected [-Werror=nonnull]
>    27 | #define __underlying_strncpy __builtin_strncpy
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2: fix -Wnonnull warning
    https://git.kernel.org/netdev/net-next/c/b7fbc88692e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


