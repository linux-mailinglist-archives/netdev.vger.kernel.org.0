Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596C930D201
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhBCDKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhBCDKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 22:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 25F4664F74;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612321812;
        bh=ZuNRMEqHVCgEIVhQrJT8GR3Osiyjq+dayVDEsuj7mps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sijHwVtsaWPVG8ePNiustuIftkK6zYgRqig9uBoWQ+RlRvcaTqLGHW7TzmZfJBUDz
         OnEjvsPN5QJtId+fgOGyux0rI7pIkxRY9c03qrQmE0tH1GOXa/hIbUA5WL8sz16Nr1
         07c1GRAvMMDrns1BND/coKuJp2tUOn6snNjLhjXFbL3Y/4lT1W5IbLi2pQvxkwU6JQ
         nRAf4BXtcd2/lN9Logwf8Cy1eaHjdDGlQaDr9Tk6G9Alw5e2bDUx769+geB6poEAUM
         lDobhORNWQvx40BGqWMXJGpK/6Ci0CQ4t4rJviooSOFywZoKtBEiCM9yjO0giTFY0t
         toFTlvyUI/VKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A829609EA;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: Silence M5272 build warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161232181210.32173.7064834379562903340.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 03:10:12 +0000
References: <20210202130650.865023-1-geert@linux-m68k.org>
In-Reply-To: <20210202130650.865023-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        gerg@linux-m68k.org, linux@roeck-us.net, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 14:06:50 +0100 you wrote:
> If CONFIG_M5272=y:
> 
>     drivers/net/ethernet/freescale/fec_main.c: In function ‘fec_restart’:
>     drivers/net/ethernet/freescale/fec_main.c:948:6: warning: unused variable ‘val’ [-Wunused-variable]
>       948 |  u32 val;
> 	  |      ^~~
>     drivers/net/ethernet/freescale/fec_main.c: In function ‘fec_get_mac’:
>     drivers/net/ethernet/freescale/fec_main.c:1667:28: warning: unused variable ‘pdata’ [-Wunused-variable]
>      1667 |  struct fec_platform_data *pdata = dev_get_platdata(&fep->pdev->dev);
> 	  |                            ^~~~~
> 
> [...]

Here is the summary with links:
  - net: fec: Silence M5272 build warnings
    https://git.kernel.org/netdev/net-next/c/32d1bbb1d609

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


