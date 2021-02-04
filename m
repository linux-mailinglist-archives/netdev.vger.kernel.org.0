Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A054A30E8B3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhBDAlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234158AbhBDAkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A0BB164F6A;
        Thu,  4 Feb 2021 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612399206;
        bh=7KT0nKwSZ3Yg3lZtbd8rwlie3OCVRJWDCy2oOT2/k3c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DSr3BvRT2nn3di1mE5uarUbY+9AnbzwG6LCntijvY8XQFd7YSqOGttpSBJ6SejBZ0
         17NiNtftkrelRUKEL9kWJUrdIHk7ViMgF0+FY/hEtZ30rIqbGvjcsYm3Jm2JTDcRpj
         nUKqIlK1zt6nnZA+lyPCinHM3diYXp7bX8288rarKNse5KpERYPbl/+C8zjc/fJs3m
         DBJ4K4zok1BBPNqJ2nNGm0qo4PmsdtT3lUOjlR6x1j/XAINuDdx0TxTDlKvCBddhXI
         8YssgXEmz8Crc+MjbYn40L71f+pyuxSbCBTtreRLsVf3gE9BAPgToloGPdBLKaykNE
         EPB9OFCFnFziw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91444609EB;
        Thu,  4 Feb 2021 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/qrtr: restrict user-controlled length in
 qrtr_tun_write_iter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161239920659.23511.13237805866635175575.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 00:40:06 +0000
References: <20210202092059.1361381-1-snovitoll@gmail.com>
In-Reply-To: <20210202092059.1361381-1-snovitoll@gmail.com>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 15:20:59 +0600 you wrote:
> syzbot found WARNING in qrtr_tun_write_iter [1] when write_iter length
> exceeds KMALLOC_MAX_SIZE causing order >= MAX_ORDER condition.
> 
> Additionally, there is no check for 0 length write.
> 
> [1]
> WARNING: mm/page_alloc.c:5011
> [..]
> Call Trace:
>  alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>  alloc_pages include/linux/gfp.h:547 [inline]
>  kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
>  kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
>  kmalloc include/linux/slab.h:557 [inline]
>  kzalloc include/linux/slab.h:682 [inline]
>  qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
>  call_write_iter include/linux/fs.h:1901 [inline]
> 
> [...]

Here is the summary with links:
  - net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()
    https://git.kernel.org/netdev/net/c/2a80c1581237

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


