Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920085A75F3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiHaFuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiHaFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA0546DBA;
        Tue, 30 Aug 2022 22:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5608A615F5;
        Wed, 31 Aug 2022 05:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3531C433C1;
        Wed, 31 Aug 2022 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925016;
        bh=YXHgBhq9uJm0uqwtTHVRBEYraMl30fFofoWLHmeqxMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LFhTNNE1YWN8u9rMgxmkfyOF6/sKsiGJ62qH+Ves+Yvuwk6i5pdoPboh8lSrYtJLp
         qrmQdL8j5yvoNOLa558CeZyWZC9PGj5Qi/zVs1T9AMb0xi1AVFzGOGdOadCLT3+yxh
         uUPFOsdbyaXSl01Rj2bnbEKFtKOfM9otPbsyaI04bM68haYXxTuEh4TWxnIfaS5SFj
         16FkhiDZyi6ulvg8+FUw8k7uUqvVhIq2sOQ7YkmoOnPzw+uFm9Z2zs5f/w8chiUv8x
         mx0oG3FNcwdSXvR6DM5ZytD76zi9KYIpCCGqZ+Dz/CaMr6GMxU2UK172h81yV933fr
         joC5ZvXRB4eiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99E4FC4166F;
        Wed, 31 Aug 2022 05:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/6] completely rework mediatek,mt7530 binding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192501662.15694.8114959783518377261.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 05:50:16 +0000
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
In-Reply-To: <20220825082301.409450-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        frank-w@public-files.de, luizluca@gmail.com, sander@svanheule.net,
        daniel@makrotopia.org, erkin.bozoglu@xeront.com,
        sergio.paracuellos@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 11:22:55 +0300 you wrote:
> Hello.
> 
> This patch series brings complete rework of the mediatek,mt7530 binding.
> 
> The binding is checked with "make dt_binding_check
> DT_SCHEMA_FILES=mediatek,mt7530.yaml".
> 
> [...]

Here is the summary with links:
  - [v6,1/6] dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
    https://git.kernel.org/netdev/net-next/c/214537cd8a17
  - [v6,2/6] dt-bindings: net: dsa: mediatek,mt7530: fix description of mediatek,mcm
    https://git.kernel.org/netdev/net-next/c/ba9476f72500
  - [v6,3/6] dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
    https://git.kernel.org/netdev/net-next/c/f565c54e96b6
  - [v6,4/6] dt-bindings: net: dsa: mediatek,mt7530: update examples
    https://git.kernel.org/netdev/net-next/c/c9aece04e01c
  - [v6,5/6] dt-bindings: net: dsa: mediatek,mt7530: define phy-mode per switch
    https://git.kernel.org/netdev/net-next/c/79a16c3b162f
  - [v6,6/6] dt-bindings: net: dsa: mediatek,mt7530: update binding description
    https://git.kernel.org/netdev/net-next/c/cd7e2b97f6ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


