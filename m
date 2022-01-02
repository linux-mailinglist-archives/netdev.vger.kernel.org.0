Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772B7482C93
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 20:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiABTAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 14:00:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59472 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiABTAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 14:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BA2FB80DD8;
        Sun,  2 Jan 2022 19:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1030C36AEE;
        Sun,  2 Jan 2022 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641150012;
        bh=t6gkySw86mij+Rw0QukcxX8x7yBBcD8iE7E5iibMWOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d6Y5cmk7jgkcpxR+F2rZMiypogeZeqxGc8UfZZD5TPAvnsuENs+qRgU3MX5fRoRKX
         UQhlB8a/HaEgURLBcTfRmvRsH2OOK81PqcnCKQcAeMwb9e+fOus2OR5HxaD9WQdKkZ
         zTBVZXXfDpfrvQM5WhaVtukdR+JLqrkT0tNOGswHSF4+awfE7rTi+hsExDDmVuVqTs
         vqZJ6cYz4atd0jkPzQmCsR4XSoydq/oYOAPvyRp+M5yECCQ3dxdOdjtHMt3ADNakdh
         pEMIwsF9rxiCIEfABxOWuql3deSsU1U25HbCkMHUn44Lqz+pZ+gzjktl3d0xA4XE3e
         BPONvH6x9bHWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2CA9C32795;
        Sun,  2 Jan 2022 19:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] lynx pcs interface cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164115001185.21718.4612917729093758759.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 19:00:11 +0000
References: <20211229050310.1153868-1-colin.foster@in-advantage.com>
In-Reply-To: <20211229050310.1153868-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, ioana.ciornei@nxp.com,
        kuba@kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 21:03:05 -0800 you wrote:
> The current Felix driver (and Seville) rely directly on the lynx_pcs
> device. There are other possible PCS interfaces that can be used with
> this hardware, so this should be abstracted from felix. The generic
> phylink_pcs is used instead.
> 
> While going through the code, there were some opportunities to change
> some misleading variable names. Those are included in this patch set.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
    https://git.kernel.org/netdev/net-next/c/e7026f15564f
  - [v2,net-next,2/5] net: dsa: felix: name change for clarity from pcs to mdio_device
    https://git.kernel.org/netdev/net-next/c/61f0d0c304a2
  - [v2,net-next,3/5] net: dsa: seville: name change for clarity from pcs to mdio_device
    https://git.kernel.org/netdev/net-next/c/2c1415e67f93
  - [v2,net-next,4/5] net: ethernet: enetc: name change for clarity from pcs to mdio_device
    https://git.kernel.org/netdev/net-next/c/82cc453753c5
  - [v2,net-next,5/5] net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
    https://git.kernel.org/netdev/net-next/c/0699b3e06f22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


