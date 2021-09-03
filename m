Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5AA3FFE61
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 12:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347917AbhICKvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 06:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235081AbhICKvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 06:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55E7160F56;
        Fri,  3 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630666206;
        bh=D9/8kwLI9vV0VvkvqFe/jyZn+lzC9uL3fbwVH9F7LXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i1e2oG9So2Je2WeM0HhL+IHl8iEWTSfY9FcfvAQGKjK9dLHYRPo9iegIczn87H2wA
         B9VxHsR9vL2qZyQJEwW9mAf3ysxvoHYrxMbJbgaY+tYYh2UhmgxJrPqk9OBrXDacOK
         PeqSYQcC1qADSsdW3YyCf8glj7LKA3h+Xg5F7E3V30PKEdKyvH5FXL/khWsf0rmE/5
         hTbFm51RuYf+vj6HPjeSqsh5aLNPrU+TY5OyaPY0/IshgeCg+0ssW+VwDY8Boxpte4
         XIh6aX/I7YszOA9HuFMZdhLO48M3UvI6iq9+7Tu4yMB5DoQD0CBBu/g/3IXcR6O0ND
         cnDtwx/BJCWwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A6A360A3E;
        Fri,  3 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: fix double use of queue-lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066620630.9656.13610846565944656838.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 10:50:06 +0000
References: <20210902163407.60523-1-snelson@pensando.io>
In-Reply-To: <20210902163407.60523-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 09:34:07 -0700 you wrote:
> Deadlock seen in an instance where the hwstamp configuration
> is changed while the driver is running:
> 
> [ 3988.736671]  schedule_preempt_disabled+0xe/0x10
> [ 3988.736676]  __mutex_lock.isra.5+0x276/0x4e0
> [ 3988.736683]  __mutex_lock_slowpath+0x13/0x20
> [ 3988.736687]  ? __mutex_lock_slowpath+0x13/0x20
> [ 3988.736692]  mutex_lock+0x2f/0x40
> [ 3988.736711]  ionic_stop_queues_reconfig+0x16/0x40 [ionic]
> [ 3988.736726]  ionic_reconfigure_queues+0x43e/0xc90 [ionic]
> [ 3988.736738]  ionic_lif_config_hwstamp_rxq_all+0x85/0x90 [ionic]
> [ 3988.736751]  ionic_lif_hwstamp_set_ts_config+0x29c/0x360 [ionic]
> [ 3988.736763]  ionic_lif_hwstamp_set+0x76/0xf0 [ionic]
> [ 3988.736776]  ionic_eth_ioctl+0x33/0x40 [ionic]
> [ 3988.736781]  dev_ifsioc+0x12c/0x420
> [ 3988.736785]  dev_ioctl+0x316/0x720
> 
> [...]

Here is the summary with links:
  - [net] ionic: fix double use of queue-lock
    https://git.kernel.org/netdev/net/c/79a58c06c2d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


