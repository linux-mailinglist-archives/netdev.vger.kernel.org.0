Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AABD3687F6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhDVUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239521AbhDVUap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6902361452;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619123410;
        bh=JukiFRGK6i/THosdXLaBbYLwOgcw1OfMiE7Ov1RoYKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rjOwWHkVpFVMQzLSdqB9bRzjtAZT/6QBEyhKxxTxyzEcnHHc1tvHVvdTxAwYTJ22N
         uX19bWNKJP2zU3lf89RHPQrUz6SVD+3YNLvyxZpTYqPOWkmE6uXmxnRC8RlZxViT+x
         2B165wYnP/2isRE6Ogzp4xYFzLFEUZEsNxnw19ndTU2MT9K898iOuzG7kF8Wp/NJxR
         Kyp53a5KAhP6M26rSI9nzQtrkoEobqEyDmPMABbjvv9v5z4V/HfHyBZ84yGdah+n3u
         7BW7vtS+hoWCqv7HcQTnymSu8O6Tk3FFT27aKrNN7r0vDkpWa0a+HaTzUoL89RD+tW
         CnhGBsk+cneKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 601D460A52;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net-next] net: enetc: fix link error again
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912341038.26269.8574616541173357004.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 20:30:10 +0000
References: <20210422133518.1835403-1-arnd@kernel.org>
In-Reply-To: <20210422133518.1835403-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 15:35:11 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A link time bug that I had fixed before has come back now that
> another sub-module was added to the enetc driver:
> 
> ERROR: modpost: "enetc_ierb_register_pf" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: fix link error again
    https://git.kernel.org/netdev/net-next/c/74c97ea3b61e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


