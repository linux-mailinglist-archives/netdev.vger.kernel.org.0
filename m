Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6C45903B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhKVOdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhKVOdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1670860F25;
        Mon, 22 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637591409;
        bh=+ZVnAGc/SByk9ctzoGkc5DSuPqohgzTBc8m8CRhiOjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CqLXPeFpJudD+MTaMGnx7NHvRqKLZQlPi55Uqwbs6OYPD2BPjPTeIALX67wqTutam
         rba79plSVQKgh6PvPHwH1jlg2xEOBILfp/E0qhJQdcFB1Lch8dPtW8RBgtNJSlS4Ss
         3yth4/cfnLUN387wp1xnxu5Y8gPyhn2YSYUqTfb46uoXXomOEKZlaREMZEK7s5zXOC
         g/GgJrx/Ippm32xOE0V6lmgI+GmP/1cePKPV/KBNSjrY8BuRZKHyBRpBniVgHyXWxS
         fCdzg7w6jUmKI/sxx0dCdSzwNg7+Q6iOkVPZ1901pINVp4p92DI3jNUuIa0BqOjoJx
         gVJ7E/qPhyO9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0520E60AA4;
        Mon, 22 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Fix coverity issue 'Uninitialized scalar variable"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759140901.30186.4600107073229273193.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 14:30:09 +0000
References: <20211121145624.GA5334@yacov-PR601-VR603>
In-Reply-To: <20211121145624.GA5334@yacov-PR601-VR603>
To:     Yacov Simhony <ysimhony@gmail.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 17:02:53 +0200 you wrote:
> There are three boolean variable which were not initialized and later
> being used in the code.
> 
> Signed-off-by: Yacov Simhony <ysimhony@gmail.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - Fix coverity issue 'Uninitialized scalar variable"
    https://git.kernel.org/netdev/net-next/c/ac9f66ff04a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


