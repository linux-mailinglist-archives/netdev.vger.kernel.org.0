Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C62D43357B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhJSMMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJSMMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A5D260FD8;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634645408;
        bh=TJZOWZwtN3FZb1eBZNo6qD2cCizRQYUDnujiy2Ji28Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MoNIrVJe/wxJSE5HP9jHvWDTWFp4P7o5ElF8Wkx7XT45lhfg+qcZa2JT9J9CTOVHO
         XY6UZB/xnLb79dwTnx9d49ArP1mD12d1gYZonWE3LsMKcTjR/IKhyOtP7+DzMrCwTl
         dcUiO8iJ4gEMmSCyBAMIOwl8DWptB5fhIO3KawNxDQO3khRyTDAd2WYZCachfb4Exa
         JEowW0nlhbVKxHR7vhR6DxWTcCAus05O8+4EuFb9EaDcItf3x/RQEKK/wU8ksf2jJp
         n1wHHJZg5bpCEIUJN3pV+EX5x98vX2j5E15gWsoBn9iK1YPgDzoTmdfLdidk/EUHVl
         okSV+68ieMc1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6094460A2E;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: Support disabling autonegotiation for
 PCS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464540839.1998.415977997251146521.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:10:08 +0000
References: <E1mcmIc-005LpO-13@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mcmIc-005LpO-13@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 11:24:50 +0100 you wrote:
> From: Robert Hancock <robert.hancock@calian.com>
> 
> The auto-negotiation state in the PCS as set by
> phylink_mii_c22_pcs_config was previously always enabled when the
> driver is configured for in-band autonegotiation, even if
> autonegotiation was disabled on the interface with ethtool. Update the
> code to set the BMCR_ANENABLE bit based on the interface's
> autonegotiation enabled state.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: Support disabling autonegotiation for PCS
    https://git.kernel.org/netdev/net-next/c/92817dad7dcb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


