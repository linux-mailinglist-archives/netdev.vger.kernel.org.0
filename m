Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866B64851C8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiAELaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiAELaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 06:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79B1C061761;
        Wed,  5 Jan 2022 03:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61EE8616FA;
        Wed,  5 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8EA4C36AED;
        Wed,  5 Jan 2022 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641382211;
        bh=NXnK29rweR4LUQ4VydBhLmhRcLlfzwpZeWKkeIjmW/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=shRNi6YH7cKQuVgeFhNXsSXy0bVLVTBzyEh2u2btgqAJrHbaF27taAWaZHTBWkkKT
         s6M65hCxw5koItsIrrAMIviw7EBsMguC6ulW0xh31TJuOYELh2lEMmXWJtWrSPtn0p
         H+i9PCBPuPG6b9vy0dbpyJgkSWMYJIbrejsAWdVpTLQ3RR98ztI92rc8Si8BmEx4av
         9yxf21ZVSmC+IOHHqmDyrrAeVYz3xBS8zFulMdbiBaW/fJfUnBVXmzEZZT/iWxKD2U
         OPnXqOOMHaA0k/YbeySPMUDtTwpGRTBo1E1ea+OgsxgOAdy4ndHgIwongRJLPUxOEE
         lU0aNjykHz8BQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CD0CF79408;
        Wed,  5 Jan 2022 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v12 0/3] net: ethernet: mtk_eth_soc: refactoring and Clause 45
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164138221163.4307.616203536271666789.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 11:30:11 +0000
References: <YdQ4HzLjpuVW4YFi@makrotopia.org>
In-Reply-To: <YdQ4HzLjpuVW4YFi@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 4 Jan 2022 12:05:51 +0000 you wrote:
> Rework value and type of mdio read and write functions in mtk_eth_soc
> and generally clean up and unify both functions.
> Then add support to access Clause 45 phy registers, using newly
> introduced helper macros added by a patch Russell King has suggested
> in a reply to an earlier version of this series [1].
> 
> All three commits are tested on the Bananapi BPi-R64 board having
> MediaTek MT7531BE DSA gigE switch using clause 22 MDIO and
> Ubiquiti UniFi 6 LR access point having Aquantia AQR112C PHY using
> clause 45 MDIO.
> 
> [...]

Here is the summary with links:
  - [v12,1/3] net: ethernet: mtk_eth_soc: fix return values and refactor MDIO ops
    https://git.kernel.org/netdev/net-next/c/eda80b249df7
  - [v12,2/3] net: mdio: add helpers to extract clause 45 regad and devad fields
    https://git.kernel.org/netdev/net-next/c/c6af53f038aa
  - [v12,3/3] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO access
    https://git.kernel.org/netdev/net-next/c/e2e7f6e29c99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


