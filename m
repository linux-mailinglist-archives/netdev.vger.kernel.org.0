Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2583CF7EA
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhGTJvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237557AbhGTJt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D5486101E;
        Tue, 20 Jul 2021 10:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626777004;
        bh=BM5wkoPMjRKGoktEBVz+5Rr7FRFAatjsayz8taHQU8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VMZY2aPV5hrCbtiYUS939t1TgLXAaXWyoAm5vR2wkmr+qLHuSjiRD1l0zEka6nUfQ
         D2fk/uVhnetZPPpEkYtuujS9drmp6M76fWyyessgtB3oJ//SqJwiVdTLEoqGauYw1X
         ovWi9unfnHI/KMCNtkCkLqlTbMqz2VB32tfNXVOVqNhfPBQD6ohUYPkQCWjqj/jIdd
         2bYqj9HdccOwOG0fKYoXHNogNnX0SxWluO3mb1wDRcjROdH3+rZIThEGNjfT7xTH1q
         S95LD24GlxrN2U/5Dg5+ycZuE2X5KwaDD2T8UlpXh5p/nrojMds/oGETp6sMrCD/Qa
         Gl640BdQJgJ8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 801CD60C09;
        Tue, 20 Jul 2021 10:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: Update MAINTAINERS for MediaTek switch
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162677700451.29107.12570499893022239705.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 10:30:04 +0000
References: <49e1aa8aac58dcbf1b5e036d09b3fa3bbb1d94d0.1626751861.git.landen.chao@mediatek.com>
In-Reply-To: <49e1aa8aac58dcbf1b5e036d09b3fa3bbb1d94d0.1626751861.git.landen.chao@mediatek.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        dqfext@gmail.com, sean.wang@mediatek.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        steven.liu@mediatek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 11:50:07 +0800 you wrote:
> Update maintainers for MediaTek switch driver with Deng Qingfang who has
> contributed many high-quality patches (interrupt, VLAN, GPIO, and etc.)
> and will help maintenance.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Vladimir Oltean <olteanv@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: Update MAINTAINERS for MediaTek switch driver
    https://git.kernel.org/netdev/net/c/6c2d125823ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


