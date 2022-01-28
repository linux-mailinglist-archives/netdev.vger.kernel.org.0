Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B60349FC7A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349520AbiA1PKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50874 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349483AbiA1PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC39DCE26B6
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34D87C340E6;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=bX2YNkrjWuRXPLiBLZBD8X0W6WoBS/44aeChLdjwrrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O1N3BDiAvMIgIV7PZq35NQ4tftT5IMQ01yVRssQKmCYTjpqyclinNFKFxnnEPVoOx
         0EnUPpJ5jRfPvxLJUnXjJ0ma/9SicAUekzbPc9Azfn7rjhpT5OyJ2MIWyT8rHOwuCs
         JVFwC6hNkfEz4wkCnrhJc0FBgwlQOYN2zHYFEaFdf3DwtghT0JIiRQm+yKhT55Ct1u
         V5f7nBKse4XGrytUmo2Oc42g3B+UWxA5BVb3W6iTFskdd67KnUtRfy9vgC/aZD1GEZ
         yAh/3Z0qHE3Yu3lNjINdI3e899U9skd2zcWOA+ACznnrDHcubBAh4qr699IszDZGyl
         wF8dxEY7tLGow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20EB9F60799;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 00/13] net: dsa: realtek: MDIO interface and
 RTL8367S,RTL8367RB-VB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261712.2420.7704268434103008092.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220128060509.13800-1-luizluca@gmail.com>
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 03:04:56 -0300 you wrote:
> The old realtek-smi driver was linking subdrivers into a single
> realtek-smi.ko After this series, each subdriver will be an independent
> module required by either realtek-smi (platform driver) or the new
> realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
> independent, and they might even work side-by-side, although it will be
> difficult to find such device. The subdriver can be individually
> selected but only at buildtime, saving some storage space for custom
> embedded systems.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,01/13] net: dsa: realtek-smi: fix kdoc warnings
    https://git.kernel.org/netdev/net-next/c/0f0c6da03ba3
  - [net-next,v6,02/13] net: dsa: realtek-smi: move to subdirectory
    https://git.kernel.org/netdev/net-next/c/319a70a5fea9
  - [net-next,v6,03/13] net: dsa: realtek: rename realtek_smi to realtek_priv
    https://git.kernel.org/netdev/net-next/c/f5f119077b1c
  - [net-next,v6,04/13] net: dsa: realtek: remove direct calls to realtek-smi
    https://git.kernel.org/netdev/net-next/c/cd645dc556e2
  - [net-next,v6,05/13] net: dsa: realtek: convert subdrivers into modules
    https://git.kernel.org/netdev/net-next/c/765c39a4fafe
  - [net-next,v6,06/13] net: dsa: realtek: add new mdio interface for drivers
    https://git.kernel.org/netdev/net-next/c/aac94001067d
  - [net-next,v6,07/13] net: dsa: realtek: rtl8365mb: rename extport to extint
    https://git.kernel.org/netdev/net-next/c/d18b59f48b31
  - [net-next,v6,08/13] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
    https://git.kernel.org/netdev/net-next/c/c45e0fef9f89
  - [net-next,v6,09/13] net: dsa: realtek: rtl8365mb: use DSA CPU port
    https://git.kernel.org/netdev/net-next/c/7fa8af30ecdf
  - [net-next,v6,10/13] net: dsa: realtek: rtl8365mb: add RTL8367S support
    https://git.kernel.org/netdev/net-next/c/d40f607c181f
  - [net-next,v6,11/13] net: dsa: realtek: rtl8365mb: add RTL8367RB-VB support
    https://git.kernel.org/netdev/net-next/c/84a10aecdcc0
  - [net-next,v6,12/13] net: dsa: realtek: rtl8365mb: allow non-cpu extint ports
    https://git.kernel.org/netdev/net-next/c/6147631c079f
  - [net-next,v6,13/13] net: dsa: realtek: rtl8365mb: fix trap_door > 7
    https://git.kernel.org/netdev/net-next/c/078ae1bdd32d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


