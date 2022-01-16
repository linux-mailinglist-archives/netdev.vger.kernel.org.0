Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E5248FCC8
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiAPMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 07:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiAPMkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 07:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD8CC061574;
        Sun, 16 Jan 2022 04:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E35D60EB7;
        Sun, 16 Jan 2022 12:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3315C36AE7;
        Sun, 16 Jan 2022 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642336808;
        bh=0M3mNi8vd3Zj2xyIgNHYR+VmiKRhYbTT8j4+kMp55PE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=quOLF+rjuNkKllZfi84JrrkC8m2HGs0TjuyKKDHKMDzNnSHROSrtwp4menJ1bib1F
         /coF/67hAcpE25RvVVPSl0h88XjI33fRM307thiwh8EbrzAcLPg1C/Wq/xaWcPRdeU
         DZp321AjUrrf05+mvVx+IEjj3Dt3it/Bs6O7kRJqGw9rw/8PJN2py2ExXDtUQVb4XK
         lYcwgIXXMkwIV+HqQLi5U44f70B5u/kM3KABI+6xi+Ge76PSnRmqWpnpVMtgXfwUXe
         JsCJFEzHoU0N4XldHp1ki3+7n6MNknw6AzRJVO7IK92qOHx/97fJ+S2Rwddr6omGUa
         GMJCo4sexF5DQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABC7BF60799;
        Sun, 16 Jan 2022 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: Fix hung_task when removing SMC-R devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164233680869.3883.15974762125113238993.git-patchwork-notify@kernel.org>
Date:   Sun, 16 Jan 2022 12:40:08 +0000
References: <1642319022-99525-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1642319022-99525-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        dust.li@linux.alibaba.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 16 Jan 2022 15:43:42 +0800 you wrote:
> A hung_task is observed when removing SMC-R devices. Suppose that
> a link group has two active links(lnk_A, lnk_B) associated with two
> different SMC-R devices(dev_A, dev_B). When dev_A is removed, the
> link group will be removed from smc_lgr_list and added into
> lgr_linkdown_list. lnk_A will be cleared and smcibdev(A)->lnk_cnt
> will reach to zero. However, when dev_B is removed then, the link
> group can't be found in smc_lgr_list and lnk_B won't be cleared,
> making smcibdev->lnk_cnt never reaches zero, which causes a hung_task.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: Fix hung_task when removing SMC-R devices
    https://git.kernel.org/netdev/net/c/56d99e81ecbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


