Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C303D1F98
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhGVHTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230501AbhGVHT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F0DE461289;
        Thu, 22 Jul 2021 08:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626940805;
        bh=yXm17fe0Q9qFGYQ4k8RZI7XanHxmG2UGDusqEM5eIZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XcitYS6KAzDmtMes+v7tGuytWnQowFLyYjU60lgeA10ya0LuhLeYh81l/jG0WMskz
         PSE/f22KvKPivtuA8TNdhktmqanYCRUgRcR37wOsGxNcYRaufhoNjDrBEVOY+Ui6fM
         cvYX58XYT9iiEUr5AeNKLZyD3b2cidPC6ei0yP0mQH9rFkR471Mx/5PT/FzpangW5P
         Puft0Y/PiD8zqCFBSp4Nqi5w/l/oqpmsgSMPGSb3kZjl2C5E3MbmLTGUb4/N+yIVXt
         AQd3GaHuVyiI2eBQaTuB0kPfWK9yUnKeOTkVFSf2rMegjLKmdA4CGrMxWMd9zTL1zW
         OVweqlpVld2bA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E5CE560C09;
        Thu, 22 Jul 2021 08:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: selftests: add MTU test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694080493.21125.3490963326532033566.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 08:00:04 +0000
References: <20210722073427.26537-1-o.rempel@pengutronix.de>
In-Reply-To: <20210722073427.26537-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, fugang.duan@nxp.com,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, festevam@gmail.com, david@protonic.nl,
        linux@armlinux.org.uk, philippe.schenker@toradex.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 09:34:27 +0200 you wrote:
> Test if we actually can send/receive packets with MTU size. This kind of
> issue was detected on ASIX HW with bogus EEPROM.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  net/core/selftests.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Here is the summary with links:
  - [net-next,v1,1/1] net: selftests: add MTU test
    https://git.kernel.org/netdev/net-next/c/802a76affb09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


