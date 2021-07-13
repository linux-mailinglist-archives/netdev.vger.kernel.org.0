Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48E23C7513
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhGMQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhGMQmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 12:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7EFD4610C7;
        Tue, 13 Jul 2021 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626194403;
        bh=ki0oeBNnSLFegSfVYbgsCVGuNcxarRlyxgTXEpV1XCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lwQkGK43ddLjd17zV4CjDhoQ32mglSyr0RaT6CPW9ndNPWSnFV34druFrzrnUSjCf
         IsANkS7wYv5+ZbUpfPra3bC7uoNB9Tr/H532AMrufciFM1v75Jy0lTuJDRSo4i6CxR
         iJ7h2/BOpi62JbT9SESZ5crPBKJoaWVqLYM2S6fi3wWHxz0Tc5XVz7OGNn6E7+TVrr
         X8gXYyVkHBjZZAdpBKUoGfTvFtGU8C8UCWp4Mvl6pR2st4NkGTAvUKX/Mq6wehfqeg
         B6S/2Xh8vTC+O50Ee8GnpfJWQIDz26Tbaeut6nkkP6L+PtOxxSgt+Zu3K0LrQGdjFh
         O7knjE6ownt2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 744CF60A4D;
        Tue, 13 Jul 2021 16:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: fix address learning getting disabled
 on the CPU port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162619440347.1289.14656334584968316795.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Jul 2021 16:40:03 +0000
References: <20210713093719.940375-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210713093719.940375-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Jul 2021 12:37:19 +0300 you wrote:
> In May 2019 when commit 640f763f98c2 ("net: dsa: sja1105: Add support
> for Spanning Tree Protocol") was introduced, the comment that "STP does
> not get called for the CPU port" was true. This changed after commit
> 0394a63acfe2 ("net: dsa: enable and disable all ports") in August 2019
> and went largely unnoticed, because the sja1105_bridge_stp_state_set()
> method did nothing different compared to the static setup done by
> sja1105_init_mac_settings().
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sja1105: fix address learning getting disabled on the CPU port
    https://git.kernel.org/netdev/net/c/b0b33b048dcf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


