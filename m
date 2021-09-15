Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F16F40CF45
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 00:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhIOWV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 18:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231969AbhIOWV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 18:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B39C960F13;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631744407;
        bh=k4v+ilBRTstt1QfEeMRafhbgscKQHL4dKAyAUwoFX4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aCQtU9VLeCQNQrySE7JLYclbgw+kUvQosSwmdl7vSkYLG4ZxHdHQorwCYgEll2ivN
         NDQPWfMFDgQsL9bUQsVZ5hp5bLH04lmaavSkCSe6Tl0VD8PRbA9CCuZZVA40PQKO/B
         awJsknibLJTD47OfDdgu9Cb7IPVTk3iJncj/dlMOf9XtMSDxExGB4c71R+TNx+jCsm
         JQJnjxj9mIYve9rFr7crRS8cVTDdf48c82uKNL9lWdz4lFlOIbcaEeMBomGP7+gLqe
         Q5Cn5yVnnkgkExn4lZ+lGoPQER9+EruubSh/TuUONxXlCsk00DseEQQwYgIAt7yLGw
         V2HVYpFwtjCJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A02E760A9C;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] Revert "net: phy: Uniform PHY driver access"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163174440765.30266.10751515542533510401.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 22:20:07 +0000
References: <20210914140515.2311548-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210914140515.2311548-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        gerhard@engleder-embedded.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 14 Sep 2021 17:05:15 +0300 you wrote:
> This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6, which did
> more than it said on the box, and not only it replaced to_phy_driver
> with phydev->drv, but it also removed the "!drv" check, without actually
> explaining why that is fine.
> 
> That patch in fact breaks suspend/resume on any system which has PHY
> devices with no drivers bound.
> 
> [...]

Here is the summary with links:
  - [v2,net] Revert "net: phy: Uniform PHY driver access"
    https://git.kernel.org/netdev/net/c/301de697d869

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


