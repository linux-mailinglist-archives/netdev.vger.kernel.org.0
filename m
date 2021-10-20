Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1925B434CA3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhJTNw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTNw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EC8A46128E;
        Wed, 20 Oct 2021 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737815;
        bh=EbinZXx73KJ7AL6seHnWmg4Nw19yaI8pz4p0ozIq3IE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qe8ErUKUTx7npJlnGQVvQW+iqyn8+qyXEQNCd9xZqtfOngyZNMb74mUB1RYsptS+h
         6AzmW9jbk0jZr7dyV1BEa6RJi52eG6v8q0+ZFV8FyqJ/P0Rj9EMwjWOwUC+Dbp/lOn
         pioaojfSjnU9rKg8JwuwcXf3rWuYiyPiMCAxAT+iWxUgFozfIjhNphr6E+DSefv/dE
         InhZVNQHLgdhRhmk571mjOhMlS9Vk918v4kk79QqXx7Wk/hRcsn/4KGSBYToZTskUq
         XBDx0wtZXA1rbSIrv4VSstB2IHDwH/fgJ+Y1TWVxPxMbzfA+95R5m4SjFTGuRXyBA+
         j0wGCzglht15g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E700B609D1;
        Wed, 20 Oct 2021 13:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: Fix possible memory leak in ptp_clock_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473781494.13902.12873542605821488682.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:50:14 +0000
References: <20211020081834.2952888-1-yangyingliang@huawei.com>
In-Reply-To: <20211020081834.2952888-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Oct 2021 16:18:34 +0800 you wrote:
> I got memory leak as follows when doing fault injection test:
> 
> unreferenced object 0xffff88800906c618 (size 8):
>   comm "i2c-idt82p33931", pid 4421, jiffies 4294948083 (age 13.188s)
>   hex dump (first 8 bytes):
>     70 74 70 30 00 00 00 00                          ptp0....
>   backtrace:
>     [<00000000312ed458>] __kmalloc_track_caller+0x19f/0x3a0
>     [<0000000079f6e2ff>] kvasprintf+0xb5/0x150
>     [<0000000026aae54f>] kvasprintf_const+0x60/0x190
>     [<00000000f323a5f7>] kobject_set_name_vargs+0x56/0x150
>     [<000000004e35abdd>] dev_set_name+0xc0/0x100
>     [<00000000f20cfe25>] ptp_clock_register+0x9f4/0xd30 [ptp]
>     [<000000008bb9f0de>] idt82p33_probe.cold+0x8b6/0x1561 [ptp_idt82p33]
> 
> [...]

Here is the summary with links:
  - ptp: Fix possible memory leak in ptp_clock_register()
    https://git.kernel.org/netdev/net/c/4225fea1cb28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


