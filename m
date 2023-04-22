Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3256EB94E
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDVNUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 09:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjDVNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 09:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E76B6;
        Sat, 22 Apr 2023 06:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE49360B1B;
        Sat, 22 Apr 2023 13:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 193C2C4339B;
        Sat, 22 Apr 2023 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682169620;
        bh=rNqJt/U2DV7UKK5IXLG+r8263C65IuFuKNAfZWXNhuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MARTSRX7DCUmlPFHgkUi4Bvzba/MLqwBXnFyqT5hRKrs9o/bn+eHf3iG7h9jI3sN+
         8ccZTuA2SAuZt/0vIcB6amWZe93lTSfX5zww/Ep1MUO9RPFK8+eLZ5r4U4Jfwp0nP5
         473Nszs8PSoEML1VCh2Ec9tKUiPau6dcyuUg0H3arDNUClujouVTQKSHKlcaCDwJHV
         fvHOEELQ0eDtiCwarmibZE3F3eOFhaSjftTpdWyS+t+eMXvk/0Irrtu2xr4aO0uzvZ
         w4l17hhDORxaYz8xFRdb4G5BX69mv+GjR3wS1R0csYJdM8BLYg8VQjZaOZRF18Dqzz
         LpFIY53l2ElFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAAB6E270DA;
        Sat, 22 Apr 2023 13:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] net: ethernet: mtk_eth_soc: use WO firmware for MT7981
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168216961994.26753.10467952224917211812.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 13:20:19 +0000
References: <cover.1681994362.git.daniel@makrotopia.org>
In-Reply-To: <cover.1681994362.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Apr 2023 17:04:02 +0100 you wrote:
> In order to support wireless offloading on MT7981 we need to load the
> appropriate firmware. Recognize MT7981 by introducing a new DT compatible
> and load mt7981_wo.bin if it is set.
> 
> Changes since v1:
>  * retain alphabetic order in dt-bindings
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: net: mediatek: add WED RX binding for MT7981 eth driver
    https://git.kernel.org/netdev/net/c/cf88231d9739
  - [v2,2/2] net: ethernet: mtk_eth_soc: use WO firmware for MT7981
    https://git.kernel.org/netdev/net/c/86ce0d09e424

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


