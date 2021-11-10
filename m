Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529944BA96
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 04:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhKJDWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 22:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhKJDWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 22:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 542AE60FA0;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636514407;
        bh=YXsdFuaoHT44TyxS/x1f/fsmrU51/NwyZi0sM8b6eFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h1wsYSqAyNF7XMTruf+NIXpLUIoWQq84xKun3AOADSOHX5YrMQE1KrL0od/8txFad
         BU1Go8vZS7U0FXPr2E1qx0ByAZ9vfVQpjD6JigH+HWe1lwRqrRNnlGxTmtSS/N1lzH
         StxR15Xbk6w1ookll3Y4k+6J5fGpPo9rl21rSJGHT7qhJJYZs3ZSE/404valPpHw8g
         scNKcCT+cr2OLM5D9mnJLyLnJHkRTAeznaMFQmwMRBwjNr2+v7aej4EfjPW/PqGtxx
         /Nk3PgpdCyFKliMBrRqH5hBIutqXTApXjTJ4y1h/nEOJ3Y8//QTfYnVU/BTNSGjgom
         mASLApJjQcxeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4486260BBF;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on
 ports other than 10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163651440727.9008.9801310887106927787.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 03:20:07 +0000
References: <20211104171747.10509-1-kabel@kernel.org>
In-Reply-To: <20211104171747.10509-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Nov 2021 18:17:47 +0100 you wrote:
> Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
> only 1G.
> 
> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on ports other than 10
    https://git.kernel.org/netdev/net/c/dc2fc9f03c5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


