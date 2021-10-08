Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48834426C80
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhJHOMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241238AbhJHOMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CCE6E60F58;
        Fri,  8 Oct 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702207;
        bh=NWCsiNzTatOK4d0636eitoE6az20acaRL5/C3zTZgZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eh1dtJD7BkBkIu4efLYczMcUr+wJ6gqMZEw5fIenscIZjuIpA2ck0lnZGuK+8X2lv
         kJD9sSnx5VKNfQe/m9QroL669fUceSlCnrIq3jemseScUTxphHeb/6/23bJIMiaFNg
         36iJBHkqndsqB0NOiwGEu/1z3asykonWiPR1sQ3i0gEbHDfanDIacLONq3+/CEABM6
         VuVak9MWMwn/JaF6KT81BIseKBGoDZT5rHj6goq6dfDZD1eyBNtzm81F3qBl5MvBp0
         7+eGov0gx2vi5XGGAz3hMgTXPFCPYECpnEMchgPfTsxxfC3gizYYmbz7Re075w4OCr
         jZLNjrh8KzYhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B675460A23;
        Fri,  8 Oct 2021 14:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: dsa: rtl8366rb: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370220774.32461.2145554420644936860.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:10:07 +0000
References: <1633674077-68546-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1633674077-68546-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        linus.walleij@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 14:21:17 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./drivers/net/dsa/rtl8366rb.c:1348:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/dsa/rtl8366rb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: dsa: rtl8366rb: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/339e75f6b9a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


