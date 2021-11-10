Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD6744BA98
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhKJDWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 22:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhKJDWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 22:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 430F361105;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636514407;
        bh=pa9JRkuV0kT9i8ldqh7c8zPlIN/B+oLEIjzyXk3DDzw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiJGNnE7ai9VEHrgKxJr7ggMAYkcY3A5+VV3vZlPsOMNqehu/rtuD4kjzYbqLTr7G
         ly8yayL8EmGSVTn4DvEQAP23lTx5E9HeRm+JAIs9utAfWX0feN2D0j+hDvQgNEp8XT
         w4/SGR/Re7Q9/uH3jmKYNpBtyuFj9ODAW1I2AzH00xXiggny7A1sNRD1nDWPuOu/1v
         R/ffQyIboq/ENXVMZaomIcRjsww6+eS4P5JRFcf+NakGykQBFA3c8R2za0xyoF6qRh
         wLeCIxA2m230Wxui3HUNMoct4ZcMi9Z+G9W139ENMiIMKQKI5VTLNmkgutbeRtYr7n
         NDKv/Ax1tAcaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3736160A49;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] amt: use cancel_delayed_work() instead of
 flush_delayed_work() in amt_fini()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163651440722.9008.10921247850106597510.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 03:20:07 +0000
References: <20211108145340.17208-1-ap420073@gmail.com>
In-Reply-To: <20211108145340.17208-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Nov 2021 14:53:40 +0000 you wrote:
> When the amt module is being removed, it calls flush_delayed_work() to exit
> source_gc_wq. But it wouldn't be exited properly because the
> amt_source_gc_work(), which is the callback function of source_gc_wq
> internally calls mod_delayed_work() again.
> So, amt_source_gc_work() would be called after the amt module is removed.
> Therefore kernel panic would occur.
> In order to avoid it, cancel_delayed_work() should be used instead of
> flush_delayed_work().
> 
> [...]

Here is the summary with links:
  - [net] amt: use cancel_delayed_work() instead of flush_delayed_work() in amt_fini()
    https://git.kernel.org/netdev/net/c/43aa4937994f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


