Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C8B427A4A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244862AbhJIMwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhJIMwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B30AA60F6C;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633783807;
        bh=BlZ5FUFRpYEhDVQggZJlGdHIAB8b6wcV2Kb6ZE0ZTaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aV93KEKOTzBAub1gInlJ3uC52yiSgRRRJnCZ0vcXar61usmcLr/U5mIs2haR6zXoD
         IT8xJmxQro3vUIZKSN7yF36xvaLoimIs7/wVEku+Zk9O7FIPygUABcT8LiaYwoG6hc
         DoyMoq2aoV3vbfJkmV403zcxTbx3kqk8MHaXWg4zjzl86FdoaoLSjFLQWgSvsC7RX1
         xw+mN1MZlP+LD42YZIWC0wk8dvTMvN0gjayY+YBotfibRlJTrjtwBBXBJxvonomnm+
         0Qrk+FWk5LXR1HeGSmhbQcuGTJY2OnQBgSiw/JBTfZKVsENwxwqXxQBnbbUlsdBTeO
         zn1KCbduh8v2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A63AF60A53;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Do not shutdown PHYs in READY state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163378380767.3217.2047686754756821449.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 12:50:07 +0000
References: <20211008214252.3644175-1-f.fainelli@gmail.com>
In-Reply-To: <20211008214252.3644175-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ioana.ciornei@nxp.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 14:42:52 -0700 you wrote:
> In case a PHY device was probed thus in the PHY_READY state, but not
> configured and with no network device attached yet, we should not be
> trying to shut it down because it has been brought back into reset by
> phy_device_reset() towards the end of phy_probe() and anyway we have not
> configured the PHY yet.
> 
> Fixes: e2f016cf7751 ("net: phy: add a shutdown procedure")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Do not shutdown PHYs in READY state
    https://git.kernel.org/netdev/net/c/f49823939e41

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


