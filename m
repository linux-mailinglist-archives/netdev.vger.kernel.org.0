Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6996039953A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFBVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhFBVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 438CC613EC;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668206;
        bh=Ok8zVEw+Qf45jYl/oslq70nw8I7NuMhIQOkXPuJMz9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fci9acJn7hX9eb86KKLIP6Vl8vDFdBDPwfBNp4DXUstcGKFZPyNjMYVyOuPzalRdx
         I5KddkOwMj+++RRhTtllRul9khnJH73gfo8yrI/AhGMMEzC8PfjXCGjbcR6584F+cY
         QlqAty8LjtJEH3Hf5L3K51u1cwcacjMofQS+raKlYKK8r6kwti78/nZP1EU7Lw8dz9
         3BJWNT8VAc9iM06OdnR1s7l7Uu2FP8JxGOhURDxMa9RpRXfNzCNyNSmbzdU96os31V
         Z18HLYzDNDnXGVPAg4aEGqFlcNBGt3qiMDxwas87cmg5pKcIe3VXRQrg3qbc/uPaxm
         2epeLbL1uMRpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3863760A39;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] 9p/trans_virtio: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266820622.24657.674222916835053753.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 21:10:06 +0000
References: <20210602065442.104765-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065442.104765-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:54:42 +0800 you wrote:
> reseting  ==> resetting
> alloced  ==> allocated
> accomodate  ==> accommodate
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/9p/trans_virtio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] 9p/trans_virtio: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/8ab1784df651

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


