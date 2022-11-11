Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EC5625518
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiKKIUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiKKIUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA7213CE7;
        Fri, 11 Nov 2022 00:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 417F561E80;
        Fri, 11 Nov 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89E42C433D7;
        Fri, 11 Nov 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668154816;
        bh=H0z/gyJf8Kdl7Ragj8yN9726qsQnh7OwQ4laCsBomPA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cYO3UeuNtcn8uUAEtwLchU82CVyKc4fat54bFG0CWqLX1oah7554Tpg8dSmhhmram
         M518saSIfdtoHA5nXxDxXQCF6t+oQBbFyV+crogdLPbDb8H8o/evwxLogRhsPfCMNi
         tHArM5BbZyFQ18x5Hgqs436sphkrOelsYArvXEbCscooWANDrlkvUjuNz7vFbdqiHv
         OLT5uZlJaALPwzfxZJuhiWeRhthgjnRPGn/69BgTPVLWQRiAfde1GBtVYeu93x779w
         kmka2amA51crkMnXcN189RAqL2hY7krT8Gw7FEpbYOYb6q0HBrBbjXZwn7OokRyrRp
         i+W/nsUiR8L4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65710E270C4;
        Fri, 11 Nov 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166815481641.32563.14048666303133746703.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 08:20:16 +0000
References: <cover.1667687249.git.lorenzo@kernel.org>
In-Reply-To: <cover.1667687249.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Nov 2022 23:36:15 +0100 you wrote:
> Similar to TX counterpart available on MT7622 and MT7986, introduce
> RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
> offload traffic received by wlan nic to the wired interfaces (lan/wan).
> 
> Changes since v3:
> - remove reset property in ethsys dts node
> - rely on readx_poll_timeout in wo mcu code
> - fix typos
> - move wo-ccif binding in soc folder
> - use reserved-memory for wo-dlm
> - improve wo-ccif binding
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/8] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
    https://git.kernel.org/netdev/net-next/c/eed4f1ddad8c
  - [v4,net-next,2/8] dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
    https://git.kernel.org/netdev/net-next/c/ceb82ac2e745
  - [v4,net-next,3/8] net: ethernet: mtk_wed: introduce wed mcu support
    https://git.kernel.org/netdev/net-next/c/cc514101a97e
  - [v4,net-next,4/8] net: ethernet: mtk_wed: introduce wed wo support
    https://git.kernel.org/netdev/net-next/c/799684448e3e
  - [v4,net-next,5/8] net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
    https://git.kernel.org/netdev/net-next/c/084d60ce0c6c
  - [v4,net-next,6/8] net: ethernet: mtk_wed: add configure wed wo support
    https://git.kernel.org/netdev/net-next/c/4c5de09eb0d0
  - [v4,net-next,7/8] net: ethernet: mtk_wed: add rx mib counters
    https://git.kernel.org/netdev/net-next/c/51ef685584e2
  - [v4,net-next,8/8] MAINTAINERS: update MEDIATEK ETHERNET entry
    https://git.kernel.org/netdev/net-next/c/90050f80509c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


