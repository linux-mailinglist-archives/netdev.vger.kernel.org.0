Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A29E3CFC89
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbhGTOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239997AbhGTNup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48421611F2;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=4p+QxNNh4r8BADOiHK2ZvGF6/S1vfZZMsEZthRmkVrk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WUPtR5Tvhg/R/WUCQ7zvOJTBFgBo2A6/s57ZNDCQGkbqK4jpHXxDrZwFlzn9WV9Ax
         Vnb1WFWPYg27B42D6LLb6p7kV6D3G0Jgu1sMhD48soaOe3m+To7L91uiWvlt7Zo+iI
         sT6ci92i6kDqw5V+5TbtMv4xAxJjg/P48WQt6ttehCy08W852H83Mk/59AoDGR4HI2
         VYPMyiZteZA65AEvT74sD53+P8WHtGE/DFAeK4MaFLoQldWGkPWNSRrgVulsjLd4+f
         95D26krf0vvpQE+sYJtq2RNkWIkgVkbseVTuqBySQDfntObdNfNj0OH02X9qOxT5i3
         +1sjAOsP2nPMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DBFD60A0B;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: at803x: simplify custom phy id matching
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140624.23944.7109103583528687805.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 14:33:49 +0100 you wrote:
> The at803x driver contains a function, at803x_match_phy_id(), which
> tests whether the PHY ID matches the value passed, comparing phy_id
> with phydev->phy_id and testing all bits that in the driver's mask.
> 
> This is the same test that is used to match the driver, with phy_id
> replaced with the driver specified ID, phydev->drv->phy_id.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: at803x: simplify custom phy id matching
    https://git.kernel.org/netdev/net-next/c/8887ca5474bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


