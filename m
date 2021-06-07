Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60DC39E8E5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFGVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABD7961249;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=4z/AslLn3f/gITeRL9KnWXwmJBaZk+/io0xMbJF81BA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iqSCB6bmXPU2CX1RQR3oosaFk/tH/+blUG3Tlz7Ammhwp35TQW9EX51ZCKwmfTNIz
         pBr+1m5V9N2/Rt2iAhqPGudF9r/W4KshyKVW7kJ58yvnU1I04YS+HEB86sKDJbIBv0
         pWDybcGPtU88zm3r2stwdy0P5HNQ6cFvf1C+8Qu9ZMRNdYNtlyJx2tbDD1JZEUckXz
         mLuGwCA1zBdAD55Adw1Pmv+TT0ibshRAvdn2qu8bWICKh8wxdaAEl+xMlmNmnf5A/O
         ChW7oe7dhdvs6UrgNmdPlaUw0xB6ydSzk2Q94X6D+f61hG2gKW73y5Zb9dYzoBs6kU
         ezVt+sPOv/JdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96D2360BE2;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: micrel: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020561.31357.16602877036237708781.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607145521.4009702-1-yangyingliang@huawei.com>
In-Reply-To: <20210607145521.4009702-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 22:55:21 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/micrel/ks8842.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: micrel: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/20f1932e2282

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


