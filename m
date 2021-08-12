Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD54C3EA29C
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhHLKAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235500AbhHLKAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 06:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EC04D610CD;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762407;
        bh=o6v96xtARkk5f79XrFJT+YYc/w4kE5mNYYofnDiPAyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ArkCpFrPvA8jBfTJAZJ6qlVs4Hwn7yhs0JfRRj0+YDiM93haL0g8TA2aZc81U2veK
         ljoEd2V/fbAsfTLbldBIDBs9x6GW4R0njhTBD0IgQGLKH4XSN5N08VSGuMth6isrW4
         zQpqZZTjG35wPyIgwCnLUWyegrfmWPPMENYiLH4rWruKwPr7ZfEJI/3y7IsJBso2vM
         0Dj9oVcLvXN2qtdu1Qm6eqalG81BkghjA5pRnF5tW6vpM/fZWSZEt60GnMwe7CHhb4
         Cgy/aiJNJB5IqmRkcYURd09Ed8068OI+nSU4bQBNRiP3CNOd9BK8dBc81zhOKQ7SvE
         ClcD7X5swln8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E408360A86;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: phy: nxp-tja11xx: log critical health
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876240692.6902.414629343993954959.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 10:00:06 +0000
References: <20210811063712.19695-1-o.rempel@pengutronix.de>
In-Reply-To: <20210811063712.19695-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jdelvare@suse.com, linux@roeck-us.net,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, marex@denx.de, david@protonic.nl,
        linux-hwmon@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 08:37:12 +0200 you wrote:
> TJA1102 provides interrupt notification for the critical health states
> like overtemperature and undervoltage.
> 
> The overtemperature bit is set if package temperature is beyond 155C°.
> This functionality was tested by heating the package up to 200C°
> 
> The undervoltage bit is set if supply voltage drops beyond some critical
> threshold. Currently not tested.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: phy: nxp-tja11xx: log critical health state
    https://git.kernel.org/netdev/net-next/c/e0ba60509d64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


