Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A948C2FDB1A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbhATUoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbhATUlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:41:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AD403235DD;
        Wed, 20 Jan 2021 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611175219;
        bh=J9gJsDe4PT7BikWljJQxv0oXaAShLH+MI1eVrEhcyKU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GaT1G6JfBOX6/Mn0nhcSNTLbi43lRqbQeE0V4QXDPNCu6WGwy7LnSI8Gh7pll0nvU
         lj/sVzsBPl2RRCcs2ne5VKlbgUxSMZnrZo8/+FmfRvmKJF25JfLw8BiPHYjBvzcuat
         SsryyJD+zY6JZbslLSDyFCWeQ4YnG+9LN7CtjRJbsqJxK107lIo/vEsrLhCRvI2v1R
         TjH4qR4LEN54UD3iPhZwuAn5L+j33ytxamX7J5uxISQJ4+9D6J5pAy0NaiVMz6LgtC
         Wd3qr+lJ97XBduCcKx69S+EnDKy/6F5YdwEzOjMG3iX+o7LPH0X2WhiLqO4qCYKUk7
         q5dUEArIMXG2w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A1F2960192;
        Wed, 20 Jan 2021 20:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/3] can: dev: can_restart: fix use after free bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161117521965.21178.935318491555433677.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 20:40:19 +0000
References: <20210120125202.2187358-2-mkl@pengutronix.de>
In-Reply-To: <20210120125202.2187358-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 13:52:00 +0100 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> After calling netif_rx_ni(skb), dereferencing skb is unsafe.
> Especially, the can_frame cf which aliases skb memory is accessed
> after the netif_rx_ni() in:
>       stats->rx_bytes += cf->len;
> 
> [...]

Here is the summary with links:
  - [net,1/3] can: dev: can_restart: fix use after free bug
    https://git.kernel.org/netdev/net-next/c/03f16c5075b2
  - [net,2/3] can: vxcan: vxcan_xmit: fix use after free bug
    https://git.kernel.org/netdev/net-next/c/75854cad5d80
  - [net,3/3] can: peak_usb: fix use after free bugs
    https://git.kernel.org/netdev/net-next/c/50aca891d7a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


