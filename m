Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD232F4323
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbhAMEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbhAMEau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D4E3223133;
        Wed, 13 Jan 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610512209;
        bh=T0Y7fwW8tgG+otKLLykpO5J1sCcN+F6mZHiypDsWC1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVBPlvMxj75EofdiFTO43RWAZp3qp8Xgc9FV3NTzNUpdqlCpFIQ/p27nADguyrMPk
         zu9lS8o6JOZieBDqvipEt/Kt1+sCNwveP7LAV+hyowMpUlhoAdC85TVoy5Admfp7G5
         JTcWvTu4G7ONy5viBGWCXxPI9RHvu7zKEc/sWZQdU8M9e0A6Y2W24EG8r0TTrRJF/P
         aVPjAulFVWyolcESsLJgLlEM0sfiQWnHwwNAS3RQIjlsFf4yATcoyTLSgMNt5WsgcM
         PwajvcdY7Lw/idIqwM706bMiHlHJE1OmC/qtxMAQtCNL6SqH9XGMJwDaRxcnPu2AnR
         OpdHlQmc6HD/g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id CEF056025A;
        Wed, 13 Jan 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/2] net: dsa: add stats64 support 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051220984.5581.8625610251585628459.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:30:09 +0000
References: <20210111104658.21930-1-o.rempel@pengutronix.de>
In-Reply-To: <20210111104658.21930-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 11:46:56 +0100 you wrote:
> changes v8:
> - stats.no_handler should not be assigned from HW stats
> 
> changes v7:
> - move raw.filtered from rx_errors to rx_dropped counter
> 
> changes v6:
> - move stats64 callback to ethtool section
> - ar9331: diff. fixes
> - ar9331: move stats calculation to the worker
> - ar9331: extend rx/tx error counters
> - use spin lock instead of u64_stats*
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/2] net: dsa: add optional stats64 support
    https://git.kernel.org/netdev/net-next/c/c2ec5f2ecf6a
  - [net-next,v8,2/2] net: dsa: qca: ar9331: export stats64
    https://git.kernel.org/netdev/net-next/c/bf9ce385932b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


