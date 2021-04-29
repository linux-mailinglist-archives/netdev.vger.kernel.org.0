Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9636F2C1
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhD2XA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhD2XA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 19:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BFE6061468;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619737210;
        bh=ZilS3bhB0076Cz+8DUnKVvGYa5xENtraP9I3PdiPgms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ESxSVRLHzWdiUtM8In9/Dqb+onGH1mTS/Nm2sna+7r2cCvKoLSBnNw+3WqUBDTCNQ
         CALi4ip80XeQOnUOUPjUVwQxwcQzlSk1ZHv5/FncpJqoisquFiDM+Vsl/knNrFQ2c3
         Gcc3E0UrHqpMZj3xH6DMzD4eh0ARBMHTa/xd9WkBcFPKFAeVJVJryoi8n/Mly2BRfQ
         GbDd1J3rj8wYL9nOU3Kwn1JuJVTVNcXizfQpflEo4vbwhCQMIJYUPM1Id6bi5HDxlY
         /eZ+De5oaWrGSvgEAuvTG+FZnMnZofJtYjTx3EHmpVNGb/lCrB4I6ACJoWPtirSvJJ
         FEmp6Wa3uq8iQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B168A60A23;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/3] net: dsa: ksz: ksz8863_smi_probe: fix
 possible NULL pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973721072.25365.2784091124500418024.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 23:00:10 +0000
References: <20210429110833.2181-1-o.rempel@pengutronix.de>
In-Reply-To: <20210429110833.2181-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        colin.king@canonical.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, m.grzeschik@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Apr 2021 13:08:31 +0200 you wrote:
> Fix possible NULL pointer dereference in case devm_kzalloc() failed to
> allocate memory.
> 
> Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/3] net: dsa: ksz: ksz8863_smi_probe: fix possible NULL pointer dereference
    https://git.kernel.org/netdev/net/c/d27f0201b93c
  - [net-next,v1,2/3] net: dsa: ksz: ksz8795_spi_probe: fix possible NULL pointer dereference
    https://git.kernel.org/netdev/net/c/ba46b576a795
  - [net-next,v1,3/3] net: dsa: ksz: ksz8863_smi_probe: set proper return value for ksz_switch_alloc()
    https://git.kernel.org/netdev/net/c/d4eecfb28b96

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


