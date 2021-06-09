Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7473A1E73
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFIVCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhFIVB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1B18613F4;
        Wed,  9 Jun 2021 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623272404;
        bh=FgoOZ145iGuztEDcAS1DOKeNLtPDq63t/xmAmiXd6MA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ok7nATquXeDq0Kan7t3aMRMFBRHHEMcwlExxFBxTsMoCu5jx4NfEl6pZ2b8cNAHpm
         8B+BGm/jbb8B+hVN0vH2eCMIJz3d9SCo0r0hMaxGv9CxYo7HiIo/Ji+GsuTXw3VYM7
         xEclgTm7LsKyUglyzLY1bXh4uOyTsCMffGN/PX3FkoSAMlEjRJ72pdDCBw8fQrXiJb
         iznRSl3GA9TWZmm0sYYrrFC7zL5m5AN9ZVNR/IfBH4GBSGQ3+1jpgbGi9BJQed/rGV
         CI32Va2+f2LSplVOQEutZhjCrtxn6HepTJV/+++tiiwxOoIwNidXyiYBokt5jWEJMN
         BJOligHarrBMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC55C60A0C;
        Wed,  9 Jun 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ravb: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327240396.12172.12312965022822916098.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:00:03 +0000
References: <20210609012444.3301411-1-yangyingliang@huawei.com>
In-Reply-To: <20210609012444.3301411-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 09:24:44 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ravb: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/e89a2cdb1cca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


