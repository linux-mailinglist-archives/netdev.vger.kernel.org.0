Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0A41931A
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhI0Lbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233948AbhI0Lby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3211D60F4B;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632742217;
        bh=FPPrMuNhTuC6XbJIAHXfwkFidaaY3eJbZjkSN4yFFcQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bx2WMp1uWZbeld3r07jX57IiX7Gh6i9AixRsYT+P5WrbYxL8IeNKtf+7T907qSz5W
         0lkcC4lGax3ydvy2HYkkLyHpWfkMbiNFrZarkr5sZScc+z+S6vnFQCqO6BI8GuCUez
         0W+Mpy7Cl1lmpsQHK6EphOjTMtahp44o3Xk204bKmPzc8nCse5+YG10bXOzy+vnai/
         ngoV88Rm4BaD3UevPXU95mcpG7v8+FsgyDip5NZd4MaVwiX4AVFgU/QWpCFKi/yxjx
         A+qsSH1Kvs32+8+1woB10rKr+a7mPT3BUqoHk9JoTatpDMDDZBY8kO1Mo4hu+cTyKY
         qUPwlBZ523MHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2707C60A59;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: Fix spelling mistake "maped" -> "mapped"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274221715.5839.10760186986731778013.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:30:17 +0000
References: <20210924223146.142240-1-colin.king@canonical.com>
In-Reply-To: <20210924223146.142240-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 24 Sep 2021 23:31:46 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_err error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/hisilicon/hns_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: hns: Fix spelling mistake "maped" -> "mapped"
    https://git.kernel.org/netdev/net/c/44b6aa2ef69f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


