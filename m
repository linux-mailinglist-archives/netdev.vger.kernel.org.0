Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B88567A0A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiGEWUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiGEWUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D953186F8;
        Tue,  5 Jul 2022 15:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA4461D3A;
        Tue,  5 Jul 2022 22:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34CBFC341C8;
        Tue,  5 Jul 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657059613;
        bh=hO8W+SqlzzWY0MFtfKjDaAWoxPd/3Fuy/QNL1MwRuIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JCf3iPcDRemhVC3u0Q27/2BNmFjpu9gOf0/gcmnejIZw2xdL6dx2bDX6QO8TiUnaC
         O55QGvx0NxQFrbFyZbsIPalOrABMufYV+zG6040DspJ20CyRavsAOtnYRQ+FbgR5EA
         O7K0S6iqBq/syZByyHy2ePJSlephfbStUWzw/DWmI93naV88L8DXpXnpjQT+9ydAQI
         HFNkFVzlp6GTVc2kgrz+dUWG+eKz0uwQ/kY6QPvHrKQHocL8TEJ7NSgmzenBVILa8u
         BsUT8bNRKuD/0kz8GSbaZn7/2+NZqylKQ5x2DGddKFDPVUneVQtkrbW2oH0VHibgxu
         oESy+gYD/nC5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16F3BE45BDB;
        Tue,  5 Jul 2022 22:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: Add missing 'reg'
 property
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165705961309.16452.8847094115538179465.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 22:20:13 +0000
References: <20220701222240.1706272-1-robh@kernel.org>
In-Reply-To: <20220701222240.1706272-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  1 Jul 2022 16:22:40 -0600 you wrote:
> The 'reg' property is missing from the mediatek,mt7530 schema which
> results in the following warning once 'unevaluatedProperties' is fixed:
> 
> Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dtb: switch@0: Unevaluated properties are not allowed ('reg' was unexpected)
> 
> Fixes: e0dda3119741 ("dt-bindings: net: dsa: convert binding for mediatek switches")
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: dsa: mediatek,mt7530: Add missing 'reg' property
    https://git.kernel.org/netdev/net-next/c/3359619a6ea5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


