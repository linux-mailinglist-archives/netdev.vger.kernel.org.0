Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F4D54C15B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242719AbiFOFuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiFOFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCE01F2F5;
        Tue, 14 Jun 2022 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40E7A6177D;
        Wed, 15 Jun 2022 05:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C129C3411B;
        Wed, 15 Jun 2022 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655272214;
        bh=uOJq8k0K/tF8dz3zOSCS8OJ30XH24V4q7h1yz7qmYrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YxlEJkVjxxO1vcO+UDoS/GMfo30Aez0eDAgfLxRFHrWrnfIKGHxOjuTC+ts0JSuv/
         JC6xz8GULaJ8HF3wmvuwH6a5UNvooOu5fdoqZo7WN8e/yNlb2oM6Z3JEbNWDiADHNo
         jTFaRNyVSF3GkuUiz0zvg+yOFfV3SLFheOIjo3Sv34/tb7QcmTVgifE3YLcoerFKGd
         d3MU7DJV76AtmnIVr+0nGNxo8eOHbL8I25D7/r4zoweST3J0ElVZedruKwfHHapVQt
         rRLqzDEY/Nxiu6yirzMGkdQeOI4BoIiOrapcHhCE8TdJ1EaHntbmo1zOzBEe0BlTp8
         SvJ8MighoX47A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F678E56ADF;
        Wed, 15 Jun 2022 05:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/6] Support mt7531 on BPI-R2 Pro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165527221445.3487.2646030857898317567.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 05:50:14 +0000
References: <20220610170541.8643-1-linux@fw-web.de>
In-Reply-To: <20220610170541.8643-1-linux@fw-web.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, matthias.bgg@gmail.com,
        heiko@sntech.de, sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        dqfext@gmail.com, pgwipeout@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gerg@kernel.org,
        opensource@vdorst.com, mchehab+samsung@kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Jun 2022 19:05:35 +0200 you wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> This Series add Support for the mt7531 switch on Bananapi R2 Pro board.
> 
> This board uses port5 of the switch to conect to the gmac0 of the
> rk3568 SoC.
> 
> [...]

Here is the summary with links:
  - [v4,1/6] dt-bindings: net: dsa: convert binding for mediatek switches
    https://git.kernel.org/netdev/net-next/c/e0dda3119741
  - [v4,2/6] net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
    https://git.kernel.org/netdev/net-next/c/a9c317417c27
  - [v4,3/6] net: dsa: mt7530: rework mt753[01]_setup
    https://git.kernel.org/netdev/net-next/c/6e19bc26cccd
  - [v4,4/6] net: dsa: mt7530: get cpu-port via dp->cpu_dp instead of constant
    https://git.kernel.org/netdev/net-next/c/1f9a6abecf53
  - [v4,5/6] dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
    https://git.kernel.org/netdev/net-next/c/ae07485d7a1d
  - [v4,6/6] arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board
    https://git.kernel.org/netdev/net-next/c/c1804463e5c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


