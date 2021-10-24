Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343164388EB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhJXMw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXMw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DB5160F45;
        Sun, 24 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079808;
        bh=uiOmLM3b53ai3GE8eZ4wkG3yUbrDJt691bFzcbfWnt8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L5Vgm8O7T6fZtPhv+0lQjH5kwTywSyjzAhREHHYzU1WW1AUJzxGJzTGT0ZyXcxpYC
         2BFIjl3vVMHdPGDlQfgjAzyjPEZ77qzSPcUaPLkUAasHkC2mXWmOE9w5ANvtfLxzwv
         UVokdbltfb1fnjvYT/qPsuhX5yXwGlsIJAXcvKPNLgCzqVJZ7Ozpsco5FB++TnO8pB
         uY6fYqQevn9lR0SA0hLSRc+FJo8gn3b2ENyC/FAsEjvtNY02oy+esvc3dYl+BGX7lm
         QObvRlrV2ovsxukEoTnkTKgsLWXpV5RKyTGjGbbPEagZEbAgshv2EFRTa4WKPfWBRU
         Yv/g5f201PPWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F371360A90;
        Sun, 24 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 1/3] net: mdio: Add helper functions for accessing
 MDIO devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507980799.1741.3571164239572057045.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:50:07 +0000
References: <20211022155914.3347672-1-sean.anderson@seco.com>
In-Reply-To: <20211022155914.3347672-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 11:59:12 -0400 you wrote:
> This adds some helpers for accessing non-phy MDIO devices. They are
> analogous to phy_(read|write|modify), except that they take an mdio_device
> and not a phy_device.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This patch was originally submitted as [1].
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: mdio: Add helper functions for accessing MDIO devices
    https://git.kernel.org/netdev/net-next/c/0ebecb2644c8
  - [net-next,v2,2/3] net: phylink: Convert some users of mdiobus_* to mdiodev_*
    https://git.kernel.org/netdev/net-next/c/c8fb89a7a7d1
  - [net-next,v2,3/3] net: Convert more users of mdiobus_* to mdiodev_*
    https://git.kernel.org/netdev/net-next/c/65aa371ea52a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


