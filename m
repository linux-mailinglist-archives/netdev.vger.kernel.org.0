Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB036629A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhDTXur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhDTXup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 19:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8D41613FA;
        Tue, 20 Apr 2021 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618962612;
        bh=afRMMpQ8WGnlK/tM7rGplYmivXyi+/5E0psIIhN6pvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ic9dc1JjKEWyO5ZsRefC0CB/J8ASOanDI79731ncQumSFyd4L3TBvEdULcR8bZVIj
         HBJNR0nwO608OnsWNDHFszfd+nNu2m8iGp/2kFF6iXIpj26Bi7SJXyZ6ZzGEysxaI9
         LPSEVpkEEOG85ADf1XITtBXEHwKO7U8HXypn2vhh+jyAM3HZ7cQQTNKWi2YHZYbFcA
         2309VN1QIVaTwQfaEi2j/PuW3x9MhyW/bnRzhR3SHj/MjmwN2boaccqCSo0iG/Xxql
         XtjK1hYOov+DTbcDo85k9HFayjzioGv1lBrZOYU8tYu4oQB1gRTkM/vd9QLVBkjwjZ
         Didv2GgfuV+/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B026B60A39;
        Tue, 20 Apr 2021 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: phy: marvell: some HWMON updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896261271.30983.10967084706606089287.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:50:12 +0000
References: <20210420075403.5845-1-kabel@kernel.org>
In-Reply-To: <20210420075403.5845-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        rmk+kernel@armlinux.org.uk, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 09:53:58 +0200 you wrote:
> Here are some updates for Marvell PHY HWMON, mainly
> - refactoring for code deduplication
> - Amethyst PHY support
> 
> Changes since v1:
> - addressed Andrew's comments
> - fixed macro names
>    MII_88E6393_MISC_TEST_SAMPLES_4096 to _2048
>    MII_88E6393_MISC_TEST_SAMPLES_8192 to _4096
>    ...
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: phy: marvell: refactor HWMON OOP style
    https://git.kernel.org/netdev/net-next/c/41d26bf4aba0
  - [net-next,v2,2/5] net: phy: marvell: fix HWMON enable register for 6390
    https://git.kernel.org/netdev/net-next/c/4f920c299d4c
  - [net-next,v2,3/5] net: phy: marvell: use assignment by bitwise AND operator
    https://git.kernel.org/netdev/net-next/c/002181735184
  - [net-next,v2,4/5] net: dsa: mv88e6xxx: simulate Amethyst PHY model number
    https://git.kernel.org/netdev/net-next/c/c5d015b0e097
  - [net-next,v2,5/5] net: phy: marvell: add support for Amethyst internal PHY
    https://git.kernel.org/netdev/net-next/c/a978f7c479ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


