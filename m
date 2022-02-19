Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9C4BC94E
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbiBSQag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:30:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBSQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:30:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774F81B7628;
        Sat, 19 Feb 2022 08:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B67460B8A;
        Sat, 19 Feb 2022 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B667AC340EF;
        Sat, 19 Feb 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288210;
        bh=nke2SWnrNZAdC6IH4hrZojRETFCYw/NdikKhOHuyGu4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FhPiZWz1e8GbaWXluix0vgQmou1r6sCJSnvhYMI8texbAKVDIsZvWXeCRnHlAxQKv
         yW/KGh2SJT2LEUiJlUQCHpQmze6HaQW5SRccX0mNIfXPAwxBTHKms3Y/znU8CtLov5
         Mx3BOCsEPl8ns43qquVfptVU423aaQilgAhFC38BTIP4ARGL3AmykUyRHY2h+pjdws
         LSYt3WF0Kc54E1xVuu+20wvgRyZpnkgF223Pu6t9+foMNRlksrMrL5JGvX8U0pddwu
         CU+jCiFEQ2OxPWY3EIBB9zMosLGtb4aPf/s4/d56y63UO/bBzCmnyyLsaARJPUtIKO
         4RI/erRX441Mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98BBDE7BB18;
        Sat, 19 Feb 2022 16:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: microchip: fix bridging with more than two member
 ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528821062.2939.12714039069880000598.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:30:10 +0000
References: <DB7PR08MB3867F92FD096A79EAD736021B5379@DB7PR08MB3867.eurprd08.prod.outlook.com>
In-Reply-To: <DB7PR08MB3867F92FD096A79EAD736021B5379@DB7PR08MB3867.eurprd08.prod.outlook.com>
To:     =?utf-8?q?Svenning_S=C3=B8rensen_=3Csss=40secomea=2Ecom=3E?=@ci.codeaurora.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 11:27:01 +0000 you wrote:
> Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> plugged a packet leak between ports that were members of different bridges.
> Unfortunately, this broke another use case, namely that of more than two
> ports that are members of the same bridge.
> 
> After that commit, when a port is added to a bridge, hardware bridging
> between other member ports of that bridge will be cleared, preventing
> packet exchange between them.
> 
> [...]

Here is the summary with links:
  - net: dsa: microchip: fix bridging with more than two member ports
    https://git.kernel.org/netdev/net/c/3d00827a90db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


