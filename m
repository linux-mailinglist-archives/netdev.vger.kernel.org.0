Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C265C4CEB45
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 12:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiCFLlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 06:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiCFLlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 06:41:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2692C2DD61;
        Sun,  6 Mar 2022 03:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86D2B80E9B;
        Sun,  6 Mar 2022 11:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66DBEC340F6;
        Sun,  6 Mar 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646566812;
        bh=PgIDjiXS3jPm1Uyh8pshBF6ujP1eNer3IsNOc2zGjkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nUu85HHoNVpcHoWpJ9ZRyrqaL9vH4dIUQwIDkg6W/JY/LaIy+INMsgRj0cBtI9ltW
         Qg75NO2OINJYt/G35yhTpOw8e8LZogcVOhhNDbKk/qqVL5NznUamn0yl8LGbf4chfu
         qe4ksblLAHKvyD60+nZK5VbFKqkSxPn1drqNDTa35hpOmbFUTUdDI/Of7pe3f2mLSz
         jo71IJBbDavFIr6rP3Edguk6TsUoAunXVvMQEYvwSX+g3LvZDHNymG9qtBP2xnh1fB
         p5KNloL9JI22BX+rvhENT9EtPpRY5xvE2ZgKDTr1l3fMB/vdKKOPulQa6nPAEMKdqX
         QZKZZ74ftdeEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48387E8DD5B;
        Sun,  6 Mar 2022 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: Convert user to netif_rx(), part 2.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164656681229.19389.10107852428753621109.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Mar 2022 11:40:12 +0000
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
In-Reply-To: <20220305221252.3063812-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tglx@linutronix.de, amitkarwar@gmail.com, andrew@lunn.ch,
        aspriel@gmail.com, brcm80211-dev-list.pdl@broadcom.com,
        chi-hsien.lin@infineon.com, chung-hsien.hsu@infineon.com,
        franky.lin@broadcom.com, ganapathi017@gmail.com,
        hante.meuleman@broadcom.com, hkallweit1@gmail.com,
        jk@codeconstruct.com.au, johannes@sipsolutions.net,
        kvalo@kernel.org, libertas-dev@lists.infradead.org,
        linux-can@vger.kernel.org, linux-wireless@vger.kernel.org,
        mkl@pengutronix.de, matt@codeconstruct.com.au,
        merez@codeaurora.org, socketcan@hartkopp.net,
        radu-nicolae.pirea@oss.nxp.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, SHA-cyfmac-dev-list@infineon.com,
        sharvari.harisangam@nxp.com, wil6210@qti.qualcomm.com,
        wg@grandegger.com, wright.feng@infineon.com, huxinming820@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 23:12:44 +0100 you wrote:
> This is the second batch of converting netif_rx_ni() caller to
> netif_rx(). The change making this possible is net-next and
> netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
> order to remove netif_rx_ni().
> 
> The brcmfmac changes are slilghtly larger because the inirq parameter
> can be removed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: phy: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/a3d73e15909b
  - [net-next,2/8] can: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/00f4a0afb7ea
  - [net-next,3/8] mctp: serial: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/b903117b4868
  - [net-next,4/8] slip/plip: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/e77975e02b59
  - [net-next,5/8] wireless: Atheros: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/1cd2ef9fcb67
  - [net-next,6/8] wireless: brcmfmac: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/b381728e7e28
  - [net-next,7/8] wireless: Marvell: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/afb6d39f3292
  - [net-next,8/8] wireless: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/f9834dbdd322

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


