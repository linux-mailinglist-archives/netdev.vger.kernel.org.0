Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FD340EF2A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 04:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242699AbhIQCVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 22:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhIQCV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 22:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18A3460E09;
        Fri, 17 Sep 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631845208;
        bh=pVlBWoA6s0Fgm/K2H1rYxhE5iu9ThywKGDUuhlaHm9o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KQ+DOkxUgnAzFftqhhiTqywQ8kxDK0cJm1rtsFNd0CcU7P7lsMKyv10ybgA7lvkcY
         7R9cN/Ve/2fnrZE24riotSTysJvogwB4qe2riBebrDpCtRGs1H5xnQkuJKg+Nmd+Zk
         237aTxIdkvULX/iY29n/+66ihITxG3xjacBgKvbo4uUW5LdCFe50z9Q5ELiMKFFgtz
         YVMt4Euav3j4k7HSQHsdbyd5pYnFiPLmknVylw+uAfoNTcPWzEzVUpk/6j7pl9yifg
         rOaEbpIhwO/E6j33Wc2qhC1tQmmD3r6E16OGkxLxMttwpHZ4uvP7fAyZstoQIj211i
         1CgfkdKfafyyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 03C1C609CD;
        Fri, 17 Sep 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: broadcom: Enable 10BaseT DAC early wake
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163184520801.4672.16049058570894189047.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 02:20:08 +0000
References: <20210916212742.1653088-1-f.fainelli@gmail.com>
In-Reply-To: <20210916212742.1653088-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 14:27:41 -0700 you wrote:
> Enable the DAC early wake when then link operates at 10BaseT allows
> power savings in the hundreds of milli Watts by shutting down the
> transmitter. A number of errata have been issued for various Gigabit
> PHYs and the recommendation is to enable both the early and forced DAC
> wake to be on the safe side. This needs to be done dynamically based
> upon the link state, which is why a link_change_notify callback is
> utilized.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: broadcom: Enable 10BaseT DAC early wake
    https://git.kernel.org/netdev/net-next/c/8dc84dcd7f74

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


