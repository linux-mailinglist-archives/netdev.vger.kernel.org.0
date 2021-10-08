Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A80426CC3
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbhJHOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhJHOcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2140A60EB6;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633703408;
        bh=fqIeDLM3wJXmmjW00D37xiVyZzBxKlhoh+zsj0Ob7gw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JbN/yVDlkdYmL3oNiAqFXNnMDTIKZ+ECk53xL86JOjeU70LKj6+IYtBB/iEShQCIF
         r/KzZUy5vZbwAex4i4jjULVTZtSdlUKkfdxUl/PSthrvfvFg5rwhb83MG6BFq2s3o3
         Ej/8412peM11mHYPqOpgD56fz3xQbtlwwpyUqNGpWATkPXJRzoTCcD09gBE0XHgGqG
         /lBcN7fzJawyO78ctV7p3iHgL7CKE4XHAhzLk4eJMBeyzhrJDP2v4+dvNfrp7adHUw
         JlWhMhnwEPpW1n/aJsFaYV1eDwRJwKGI87wHbjNvgpAz8o40AEt/wzYjFm8DMM7I0K
         T/aflUdLR+Hug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15A5060A23;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: ensure the type of mdio devices match
 mdio drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370340808.9336.17613256864498488691.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:30:08 +0000
References: <E1mYTMt-001hFb-Rl@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mYTMt-001hFb-Rl@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 07 Oct 2021 14:23:27 +0100 you wrote:
> On the MDIO bus, we have PHYLIB devices and drivers, and we have non-
> PHYLIB devices and drivers. PHYLIB devices are MDIO devices that are
> wrapped with a struct phy_device.
> 
> Trying to bind a MDIO device with a PHYLIB driver results in out-of-
> bounds accesses as we attempt to access struct phy_device members. So,
> let's prevent this by ensuring that the type of the MDIO device
> (indicated by the MDIO_DEVICE_FLAG_PHY flag) matches the type of the
> MDIO driver (indicated by the MDIO_DEVICE_IS_PHY flag.)
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: ensure the type of mdio devices match mdio drivers
    https://git.kernel.org/netdev/net-next/c/94114d90037f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


