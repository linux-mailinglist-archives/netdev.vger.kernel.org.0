Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329134F26C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhC3Uu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhC3UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E315619CF;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617137411;
        bh=GI4KQ8lay/mSc+XlSrqiE3NjLGG9qt3ap/wiLnoKTng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WrBNHRq/EfbxzVbFpCh1sq+ghvMLD3+No0m4vLNhtQX9+5qwvzNVwt10hIQJJQ8ze
         Tk4yzaizRlSzXL0e+RAza1yhsYio5kkmx5mhLItCUpxbSR82n3P3ZKy+duK3m1AW7Q
         1dEA00Bz5atqT8pgwFYdqevUdYwcrEnFNcSJPET7HPEf8ylUuRnoPMNLezAgp2veBF
         Ew0AKXEyNY59b1TBqaNZ2k7hiUkpJ1x8Jp5eBDE6k2c5ErHl/ZIaaWfUKX6DIQbmEF
         jnCJrMeI858rO2uMCTQ72OvDAqHOe6vV5ZsY+NIaeHmb7prQCeNHZVuQMWgXrCbS5K
         O628E4og4PsjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 28A1560A56;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: mhi: remove pointless conditional before
 kfree_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713741116.14455.7263428972111235685.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:50:11 +0000
References: <20210330125539.1049093-1-yangyingliang@huawei.com>
In-Reply-To: <20210330125539.1049093-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 20:55:39 +0800 you wrote:
> It already has null pointer check in kfree_skb(),
> remove pointless pointer check before kfree_skb().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/mhi/net.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [-next] net: mhi: remove pointless conditional before kfree_skb()
    https://git.kernel.org/netdev/net-next/c/cda1893e9f7c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


