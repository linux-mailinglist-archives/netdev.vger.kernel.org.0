Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295EB32938E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhCAV0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237048AbhCAVVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:21:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AFB6601FD;
        Mon,  1 Mar 2021 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614633607;
        bh=fQxQpZKOXT8AStxOrQnYFCaPGe7aeX5Fjq+F9WFr9bQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WOdKm72M9kl5dxMX2iC1p10hkqd0ryy3Sb32v/4X4Y0rDdFvs/GTRxY7YLnY+7qwR
         DIbUv/V3JQFBxRFRo9yoKKwNxNAhKdLfNuuTUeqKi4msrctU8N/PlKImoP3H9U6upj
         4Pp3IGIaS1B173VtnSXmZpgRDIlFITYMUdP4wrVo1koUf59DfNMicU81WtOaKQC86a
         7GaBiQ2g2U0NBYSUtCKc7gkycrJaW+UY/NA+F7PJANjqsPBlSRyUZXyi6xXkMf1gMj
         hs+GSlV8KWWvl0lxH/Jxr2KRhq4umvhnUwQb3YMhemMzyouu6lWd+lEz3BJdTgWWea
         4RaSwhbNW3hpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 725BA60C27;
        Mon,  1 Mar 2021 21:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] net: phy: fix save wrong speed and duplex problem if
 autoneg is on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463360746.8865.12458813702859976119.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:20:07 +0000
References: <1614395158-5294-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1614395158-5294-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        huangguangbin2@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 27 Feb 2021 11:05:58 +0800 you wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> If phy uses generic driver and autoneg is on, enter command
> "ethtool -s eth0 speed 50" will not change phy speed actually, but
> command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
> has been set to 50 and no update later.
> 
> [...]

Here is the summary with links:
  - [V2,net] net: phy: fix save wrong speed and duplex problem if autoneg is on
    https://git.kernel.org/netdev/net/c/d9032dba5a2b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


