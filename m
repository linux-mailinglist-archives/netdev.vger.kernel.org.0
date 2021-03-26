Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2736349D96
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhCZAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhCZAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C34E61A46;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718010;
        bh=fR9yNOxhfJQyzwsifgnAXRByZGkJvYXplItZraflr2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTLaM0AxrhccrWk9X//oXxaE6goKTEP/l/TfWymF4mmrdTzbTVgGuR7e7Uo93ciW3
         MP5kFwgCn4EKii+Ny5kOvZmLElZ0v7NkH227+2GzaviVVId2kB39mzXv2XvRqrfhuJ
         eUcXQalIrjGTiJqr9d2hJAvq4tCnvxVPDnEABKyx778aVnCqVI2Tg1l5NsPSd1LViC
         hFbbitmWA4YI3PC8i83BXlbv79guk3JazG8dXoDpheYfbchrdhnRvE+AHePdpDvl0h
         /T4Jn5RRdXjQvT0hejqpxd88PkEJN++VAqlyBR03Y4BtIYKN26/j4m+1BprDNNiIBb
         ROH/sCqY1+hLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42686609E8;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove rtl_hw_start_8168c_3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671801026.29431.1449841196554853054.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:10 +0000
References: <a09162c7-8e7f-da1f-ea28-f3a425568020@gmail.com>
In-Reply-To: <a09162c7-8e7f-da1f-ea28-f3a425568020@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 10:31:39 +0100 you wrote:
> We can simply use rtl_hw_start_8168c_2() also for chip version 21.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] r8169: remove rtl_hw_start_8168c_3
    https://git.kernel.org/netdev/net-next/c/96ef692841e0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


