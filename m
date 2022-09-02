Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07CA5AA6B6
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiIBEAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiIBEAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA7F2CC95
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 21:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4A1AB829D6
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 825F1C433D7;
        Fri,  2 Sep 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091215;
        bh=9wM3yqJ6qiIXP5tNNcx5qKIuZwD6QotTd7pwHtC8wSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lxfUJr7sKpKPiLqrCHYkj1FBH4psiSmSfaz02QmR+2C39Zt8UzQYhmK2gtq0ogiXH
         7i9Tjn1/zhRobUSE69spr0RHe2HFRaGNbZSBo1TtMk8P7s2T8kcGxkZACS+9VHO2Jk
         qAVPWzUdg6zWM22xLjOB1SGwcOsCRsCqEBS0/rvPgW89A4Kodwuzf/M0pVIp/nHu+S
         E3Zaz5PXlcvv6KwBiqVbXlh2NWkvlBjR2cLbPTheRcUJHR/y1azWincx+fMilL/r8x
         MuItnvzllJzT7YaWVQbAsEDjqJOs27mE6HfQ/T/6G071922bP9cZPl30WIngFXiP09
         wNsTjrrrU0chg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FF6FE924E6;
        Fri,  2 Sep 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] selftests: net: dsa: symlink the tc_actions.sh
 test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166209121537.15275.1726010504745396117.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 04:00:15 +0000
References: <20220831170839.931184-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220831170839.931184-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        colin.foster@in-advantage.com, martin.blumenstingl@googlemail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 20:08:39 +0300 you wrote:
> This has been validated on the Ocelot/Felix switch family (NXP LS1028A)
> and should be relevant to any switch driver that offloads the tc-flower
> and/or tc-matchall actions trap, drop, accept, mirred, for which DSA has
> operations.
> 
> TEST: gact drop and ok (skip_hw)                                    [ OK ]
> TEST: mirred egress flower redirect (skip_hw)                       [ OK ]
> TEST: mirred egress flower mirror (skip_hw)                         [ OK ]
> TEST: mirred egress matchall mirror (skip_hw)                       [ OK ]
> TEST: mirred_egress_to_ingress (skip_hw)                            [ OK ]
> TEST: gact drop and ok (skip_sw)                                    [ OK ]
> TEST: mirred egress flower redirect (skip_sw)                       [ OK ]
> TEST: mirred egress flower mirror (skip_sw)                         [ OK ]
> TEST: mirred egress matchall mirror (skip_sw)                       [ OK ]
> TEST: trap (skip_sw)                                                [ OK ]
> TEST: mirred_egress_to_ingress (skip_sw)                            [ OK ]
> 
> [...]

Here is the summary with links:
  - [v2,net-next] selftests: net: dsa: symlink the tc_actions.sh test
    https://git.kernel.org/netdev/net-next/c/1ab3d4175775

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


