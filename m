Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492142C4861
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgKYTaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbgKYTaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:30:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606332606;
        bh=VCtMEMbk2zq8crYPfPMyi3OOuFrdjug2j3sNnw3urSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EkMn8QGd5yaAwHYcdxbvqz3RMVMMa2SGN9Qb22a6x4kpGSClrek9E/80DEyfY8MtN
         yT7wA7Bon3BWhx06GYLheetQHM+yQClRY5F3UGqmVN0V9CH+FcFhSWr1zH2m70szf3
         pO5IghDr5OIHM8UwTkjiIr5UyIMcNhnAIvI6ZfiM=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: addrlabel: fix possible memory leak in
 ip6addrlbl_net_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160633260596.3402.9642901681926921497.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 19:30:05 +0000
References: <20201124071728.8385-1-wanghai38@huawei.com>
In-Reply-To: <20201124071728.8385-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Nov 2020 15:17:28 +0800 you wrote:
> kmemleak report a memory leak as follows:
> 
> unreferenced object 0xffff8880059c6a00 (size 64):
>   comm "ip", pid 23696, jiffies 4296590183 (age 1755.384s)
>   hex dump (first 32 bytes):
>     20 01 00 10 00 00 00 00 00 00 00 00 00 00 00 00   ...............
>     1c 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00  ................
>   backtrace:
>     [<00000000aa4e7a87>] ip6addrlbl_add+0x90/0xbb0
>     [<0000000070b8d7f1>] ip6addrlbl_net_init+0x109/0x170
>     [<000000006a9ca9d4>] ops_init+0xa8/0x3c0
>     [<000000002da57bf2>] setup_net+0x2de/0x7e0
>     [<000000004e52d573>] copy_net_ns+0x27d/0x530
>     [<00000000b07ae2b4>] create_new_namespaces+0x382/0xa30
>     [<000000003b76d36f>] unshare_nsproxy_namespaces+0xa1/0x1d0
>     [<0000000030653721>] ksys_unshare+0x3a4/0x780
>     [<0000000007e82e40>] __x64_sys_unshare+0x2d/0x40
>     [<0000000031a10c08>] do_syscall_64+0x33/0x40
>     [<0000000099df30e7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init
    https://git.kernel.org/netdev/net/c/e255e11e66da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


