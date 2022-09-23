Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978475E7925
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiIWLK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiIWLKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0154FAA4D6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 04:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96895B828D6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5350AC433D6;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663931418;
        bh=ghn8tzhGtrvoRXE0BRumYZPx9Zc/TUeIGa+4s08s+7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VdXYNDo3/7r5d8qh/TmZlPLQM3R3A946cX6ZTyWVqXbjys1rUU7Y6nk9jOKEVAcMs
         4MPW3p5dFnkcP006ewFky17tecdf3o2FPrdkYWYa6BPib4QVM3LAaCO47hhxSrGIlt
         SV6iwMlWzSUtot5DddtEHMi/gCivGadQZbFR8dE33Vq8r3UyueWrGldS8lR2f/iP7h
         0SBQaOqOOK4Jz9aszp4lqudSWNX7hznigWNP65FT2LyTvCujENkxI5oOzd32t0GClJ
         k7QfsNkPNPA/bkfm1GENHcaLGxVKkTUvPSdbQKaR2MSbCPipk34w9KMaV7DVZ/0knW
         wjU5saSovJxBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B90EE50D69;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: dsa: mt7530: add support for in-band link status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393141823.14679.13460162221057201141.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:10:18 +0000
References: <YypZcnkmkS4bWQYs@makrotopia.org>
In-Reply-To: <YypZcnkmkS4bWQYs@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux@armlinux.org.uk, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, p.zabel@pengutronix.de,
        lynxis@fe80.eu
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 21 Sep 2022 01:23:14 +0100 you wrote:
> Read link status from SGMII PCS for in-band managed 2500Base-X and
> 1000Base-X connection on a MAC port of the MT7531. This is needed to
> get the SFP cage working which is connected to SGMII interface of
> port 5 of the MT7531 switch IC on the Bananapi BPi-R3 board.
> While at it also handle an_complete for both the autoneg and the
> non-autoneg codepath.
> 
> [...]

Here is the summary with links:
  - [v4] net: dsa: mt7530: add support for in-band link status
    https://git.kernel.org/netdev/net-next/c/e19de30d2080

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


