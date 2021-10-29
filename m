Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7D43FC6E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJ2Mmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhJ2Mmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 77F2F61175;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511208;
        bh=SyPB6DuAYVSltIJczLWoUIQFn28Qarpiq3i7rTT3rHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mibKVDM22yDycQE6rTFnl1BZhblJzgVHTKQTq9vho0eAfRPn7dRViWEAso6cAjc+w
         DMzX26PA55G73hETDyUrbRWyJTKIClRTH5bAyRKqE9LZNRdc4Z2stJqlXfkJMJNT2U
         0/7kXlb5jzHdsZtNDdoTCEcxp5XM5cJdbFoyOZNBf4PW3w1nr99bppW+esxei6rx+M
         a9RYaymeF9hlbkpbFM5zlPxAwihjKUuKrG4kRRE/Uc6lSOYN+s/WN/Fg6rO1pHwdHE
         h/OpeM6zH67GKAFWpBVJIst21+ol4CZ4WWBSJ5L6Tvi+AJGxxAZCsA5FT+vLoiq9/s
         hHVW//iYesW9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69F4260A6B;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551120842.27055.17696599430815824172.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:40:08 +0000
References: <20211028152105.19467-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211028152105.19467-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 11:21:05 -0400 you wrote:
> Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performance on some platforms.
> Tested on x86 PC with EVB-LAN7430.
> The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved from 817 Mbps to 936 Mbps.
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ethernet: microchip: lan743x: Increase rx ring size to improve rx performance
    https://git.kernel.org/netdev/net-next/c/a1f1627540cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


