Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83DA2F2437
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391720AbhALAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404266AbhALAUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D6C222C7E;
        Tue, 12 Jan 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410810;
        bh=mOX3a5Y8YOSDqjJZWrAJUslNVzyGaFCsuGxTlWabxfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W0w2djxkBSHi5TcZ/ZWrClIDl0pQkUG1LM5B/nfUlXT7T6BdRjEqWtQGCGpV7LjVw
         nCoWS8PTAy9798tnO3ZowHm3s5UIsZBMufSrkqfZsrkOwaat+1tiuYPerUjeWK1CMu
         9dqsXu8zIGzwF8jxsh9dmJBpwMh98aXMnRQh8wO+UIk+0GFJ3b7GWuz3VsLLMGihk+
         Kgfna+0loZ8rrbrNezc+3KpInc8yD9gSzsrQ5hZwC71+RHPBY6qEnFmgLngWGhLCq+
         kssVBOOxAIVdWkATlWni5251sYBWlnA8DJf4u/TzeB63xroPvfmK2PlfhxIOV+iIpx
         s6HKaSJqSi1BQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2E5746026B;
        Tue, 12 Jan 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/11] Get rid of the switchdev transactional
 model
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041081018.29857.3487050409879010465.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 00:20:10 +0000
References: <20210109000156.1246735-1-olteanv@gmail.com>
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kurt@linutronix.de, hauke@hauke-m.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, linus.walleij@linaro.org,
        vkochan@marvell.com, tchornyi@marvell.com, jiri@nvidia.com,
        idosch@nvidia.com, grygorii.strashko@ti.com, ioana.ciornei@nxp.com,
        ivecera@redhat.com, petrm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat,  9 Jan 2021 02:01:45 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Changes in v4:
> - Fixed build error in dsa_loop and build warning in hellcreek driver.
> - Scheduling the mlxsw SPAN work item regardless of the VLAN add return
>   code, as per Ido's and Petr's request.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,01/11] net: switchdev: remove vid_begin -> vid_end range from VLAN objects
    https://git.kernel.org/netdev/net-next/c/b7a9e0da2d1c
  - [v4,net-next,02/11] net: dsa: mv88e6xxx: deny vid 0 on the CPU port and DSA links too
    https://git.kernel.org/netdev/net-next/c/3e85f580e3fc
  - [v4,net-next,03/11] net: switchdev: remove the transaction structure from port object notifiers
    https://git.kernel.org/netdev/net-next/c/ffb68fc58e96
  - [v4,net-next,04/11] net: switchdev: delete switchdev_port_obj_add_now
    https://git.kernel.org/netdev/net-next/c/cf6def51bade
  - [v4,net-next,05/11] net: switchdev: remove the transaction structure from port attributes
    https://git.kernel.org/netdev/net-next/c/bae33f2b5afe
  - [v4,net-next,06/11] net: dsa: remove the transactional logic from ageing time notifiers
    https://git.kernel.org/netdev/net-next/c/77b61365ecef
  - [v4,net-next,07/11] net: dsa: remove the transactional logic from MDB entries
    https://git.kernel.org/netdev/net-next/c/a52b2da778fc
  - [v4,net-next,08/11] net: dsa: remove the transactional logic from VLAN objects
    https://git.kernel.org/netdev/net-next/c/1958d5815c91
  - [v4,net-next,09/11] net: dsa: remove obsolete comments about switchdev transactions
    https://git.kernel.org/netdev/net-next/c/417b99bf75c3
  - [v4,net-next,10/11] mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
    https://git.kernel.org/netdev/net-next/c/4b400fea76e1
  - [v4,net-next,11/11] net: switchdev: delete the transaction object
    https://git.kernel.org/netdev/net-next/c/8f73cc50ba2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


