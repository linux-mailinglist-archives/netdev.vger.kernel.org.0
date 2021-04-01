Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8F1352320
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhDAXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhDAXAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 735AA610D0;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318008;
        bh=hDp9DCn3isArVRyAUCFga4V5VN4rt1NJttlC359HQIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EKUPmBSv3eaQYIOmCLhGvQl1GXc/tx2k/cWi5c5jKMhIGOU5WbEvC/WJX0gTeayEk
         3cLoBTJrELS4Ey95jPdwlp6+i/p856HHFwvnHP7V5z4wSid7hbScADio5v8n/m6pwV
         xh87k5s/B1JBcXbopMHl0cZ0/pwoKfqfU15YrYYsnsJaouSN3dCDZqradH9TmgXT04
         OGwraRoDKv5LWz7qeQgOWzAJ4cGE2CY3PTsvaCNFJSlBjX6TkKtj0BwuuD2DA92WBy
         d5YicCSIn+0RtZFtlFkEco8OrgkUzNN5qky6xzmzcR6d8mhxZIs1QJsNka/n0mhvSr
         96j2QchAe/cDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EF72609CD;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: fix memory leak in peak_usb_create_dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731800838.8028.10693283331125703609.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:00:08 +0000
References: <20210401132752.25358-1-paskripkin@gmail.com>
In-Reply-To: <20210401132752.25358-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Apr 2021 16:27:52 +0300 you wrote:
> syzbot reported memory leak in peak_usb.
> The problem was in case of failure after calling
> ->dev_init()[2] in peak_usb_create_dev()[1]. The data
> allocated int dev_init() wasn't freed, so simple
> ->dev_free() call fix this problem.
> 
> backtrace:
>     [<0000000079d6542a>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000079d6542a>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000079d6542a>] pcan_usb_fd_init+0x156/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:868   [2]
>     [<00000000c09f9057>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:851 [inline] [1]
>     [<00000000c09f9057>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:949
> 
> [...]

Here is the summary with links:
  - drivers: net: fix memory leak in peak_usb_create_dev
    https://git.kernel.org/netdev/net/c/a0b96b4a6274

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


