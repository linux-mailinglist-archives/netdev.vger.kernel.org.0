Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D82E0418
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgLVBvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgLVBvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:51:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E1E7622B3B;
        Tue, 22 Dec 2020 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601854;
        bh=fhDEJKcSp76v5b8A714FLOPeK0bkDcfBNhK4T/8mRwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I1yN3pBicd7o/JDpvyVQYR1qT552fuJ1uDO1MCBMLEZAjI6GwwACBBBZD4BH1Fq7S
         7WrZBuy4c0pGpOmigO/o1LGss4l1H7g9vb72ykH56nh9r5/KTddJc9Ltqr2UgrHdBX
         AcPDk58m2Q9+mdk/KI4JRfuC5kVbcmGUQ88OYfH4Gxv3o36PNj4hqVvVLw3YlpwnVJ
         Ru+RMDNf5VJSpCnEG1VWE1dCg3r9zycyl10XYGtfJSlrdijgAxUmHCBKG9Od2Nof+k
         +ENY12gzfpVuLNsTLVH7WwVPmEBGdUDrXvky6stxgwy3wSRti1QLNfK1bd20c+5jjv
         3PrszQLpBmdAw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D7B9260387;
        Tue, 22 Dec 2020 01:50:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: mvpp2: Fix GoP port 3 Networking Complex Control
 configurations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160860185487.6881.12430244209662770782.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Dec 2020 01:50:54 +0000
References: <1608462149-1702-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608462149-1702-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 20 Dec 2020 13:02:29 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> During GoP port 2 Networking Complex Control mode of operation configurations,
> also GoP port 3 mode of operation was wrongly set.
> Patch removes these configurations.
> 
> Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
> Acked-by: Marcin Wojtas <mw@semihalf.com>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v4] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
    https://git.kernel.org/netdev/net/c/2575bc1aa9d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


