Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4733C8F3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhCOWAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhCOWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 18:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FC7C64F51;
        Mon, 15 Mar 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615845608;
        bh=7tgdTzEabZtL8mzAm6d6c5Ue/NzPq0nPcwjwrEGMYCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gseM8a3CVgrV5skraKLy4xkCuvUyRKHzvIz8ceVLpLMUih4Dc1ZaWyGBeeda3BqJM
         RhAs1kRR7DwAtc0qTVbGhp6aMIBMpAAZUMEK0WsjU31VSf6PooiVaIZwN4PlnbX5l4
         YSHCaiQ1vvxgVLiUBnq02x7iaFQpnyVuA6LLALDFD42KqQUAv9vK0u8Oc2I2Rocf65
         UopIsPAda8LT0Fe+ar70oXVBkugPjovVoZBvKvyba8VHDrYpN68sLL57c3/1OZrmF2
         EgqFeKhz4tzrPNIsGrDQm+9PAxoP3KVwo7fvuEig9fiOw8ScGJl4Yap0/fbcQCyfWR
         AdlHW5mEG7ZlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F085660A3D;
        Mon, 15 Mar 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH v4 net-next] net: phy: add Marvell 88X2222 transceiver
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161584560798.15277.8453988145594828208.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 22:00:07 +0000
References: <20210315141924.d4s4glwgbmjqgeer@dhcp-179.ddg>
In-Reply-To: <20210315141924.d4s4glwgbmjqgeer@dhcp-179.ddg>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, fido_max@inbox.ru, robert.hancock@calian.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 17:19:26 +0300 you wrote:
> Add basic support for the Marvell 88X2222 multi-speed ethernet
> transceiver.
> 
> This PHY provides data transmission over fiber-optic as well as Twinax
> copper links. The 88X2222 supports 2 ports of 10GBase-R and 1000Base-X
> on the line-side interface. The host-side interface supports 4 ports of
> 10GBase-R, RXAUI, 1000Base-X and 2 ports of XAUI.
> 
> [...]

Here is the summary with links:
  - [RESEND,v4,net-next] net: phy: add Marvell 88X2222 transceiver support
    https://git.kernel.org/netdev/net-next/c/6e3bac3eba44

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


