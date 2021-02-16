Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250B331D288
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhBPWUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBPWUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A9A6164E10;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613514007;
        bh=YLRr2XMSiVQaZzlM3bifS4+frB2gN3sDW0prTKbsBoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fw9liElLd3JhMid5dUFs+WXsBiAnuEAmbG+8m1zLIZWAu9+y3nSljVJAmbRw1s6v3
         Z+WH4jnv0ItIgZF3btmra7XmKONs5JNj4n5Cdhq0LECqUEXdI5UUz6JuPlHwO/Pbqh
         iSozjnN/6eIUJnOKpiwYeBEjEAVD30ahhWzf+uN2HM8L7i96F5MTJBL8vISD22gIn8
         qKk660OeQp9hOG1yMGu1IpdkNdphjkikPyKhpD06PNwJRxgPx2wU+mVbxyNy0eGKTW
         FLGvYoe9w9uXDKLvwLuW3E301JkiZF8RS85O9MSX46kPlGEFrJ3XjuLB+ZgnxyEZTi
         k7KbO2lc2b+9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A087C609F8;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: marvell: Ensure SGMII auto-negotiation
 is enabled for 88E1111
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351400765.20875.5811971864366981028.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:20:07 +0000
References: <20210216205330.2803064-1-robert.hancock@calian.com>
In-Reply-To: <20210216205330.2803064-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 14:53:30 -0600 you wrote:
> When 88E1111 is operating in SGMII mode, auto-negotiation should be enabled
> on the SGMII side so that the link will come up properly with PCSes which
> normally have auto-negotiation enabled. This is normally the case when the
> PHY defaults to SGMII mode at power-up, however if we switched it from some
> other mode like 1000Base-X, as may happen in some SFP module situations,
> it may not be, particularly for modules which have 1000Base-X
> auto-negotiation defaulting to disabled.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: marvell: Ensure SGMII auto-negotiation is enabled for 88E1111
    https://git.kernel.org/netdev/net-next/c/06b334f08b4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


