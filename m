Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A75E6430
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiIVNvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiIVNug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:50:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCF064D3;
        Thu, 22 Sep 2022 06:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CBE3B836F4;
        Thu, 22 Sep 2022 13:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AC12C433C1;
        Thu, 22 Sep 2022 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663854619;
        bh=baQKDRUVQgv1x/LBw1tm4rEGxWMZKXfz70Pb4TfnkgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lvk521ZohHjjza20sQknVKi2/M8j9CA0L9vilLw45jb1EF12fQg3/vj8RmDpa3y4c
         6KhV0zIzoeeURqOqPgFRo4K5f+PTjJgvZ2WAxzw4zYBcvsCU7XS2wS6IpKcdAkSoIx
         koGLoKr9MILhuWulnptqVXzERhPudWdqkGWy5GSt1YQc0ydEU+bcuu/pF9CAjlwUws
         4anojZiJSywE5jEhK7Ibu0LRHczsDErfMewfR6PNts6itDOKm+U3KbrRFWBhs1hYvQ
         Q7bYjRmWrD92QOcl5fBrFuQzjfuIhTXqkzwIg3+jBRUdiii4DHXLo8FG+NqcNdPkds
         6t7mlPnsFLIBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFB20E4D03D;
        Thu, 22 Sep 2022 13:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/11] Add WED support for MT7986 chipset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385461897.22432.10510208615369821045.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 13:50:18 +0000
References: <cover.1663668203.git.lorenzo@kernel.org>
In-Reply-To: <cover.1663668203.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 20 Sep 2022 12:11:12 +0200 you wrote:
> Similar to MT7622, introduce Wireless Ethernet Dispatch (WED) support
> for MT7986 chipset in order to offload to the hw packet engine traffic
> received from LAN/WAN device to WLAN nic (MT7915E).
> 
> Changes since v2:
> - fix build warnings in patch 9/11
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/11] arm64: dts: mediatek: mt7986: add support for Wireless Ethernet Dispatch
    https://git.kernel.org/netdev/net-next/c/00b9903996b3
  - [v3,net-next,02/11] dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
    https://git.kernel.org/netdev/net-next/c/22ecfce11034
  - [v3,net-next,03/11] net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions in mtk register map
    https://git.kernel.org/netdev/net-next/c/329bce5139cf
  - [v3,net-next,04/11] net: ethernet: mtk_eth_soc: move ppe table hash offset to mtk_soc_data structure
    https://git.kernel.org/netdev/net-next/c/ba2fc48c5e1e
  - [v3,net-next,05/11] net: ethernet: mtk_eth_soc: add the capability to run multiple ppe
    https://git.kernel.org/netdev/net-next/c/4ff1a3fca766
  - [v3,net-next,06/11] net: ethernet: mtk_eth_soc: move wdma_base definitions in mtk register map
    https://git.kernel.org/netdev/net-next/c/0c1d3fb9c2b7
  - [v3,net-next,07/11] net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc
    https://git.kernel.org/netdev/net-next/c/9d8cb4c096ab
  - [v3,net-next,08/11] net: ethernet: mtk_eth_wed: add mtk_wed_configure_irq and mtk_wed_dma_{enable/disable}
    https://git.kernel.org/netdev/net-next/c/cf26df8833cc
  - [v3,net-next,09/11] net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset
    https://git.kernel.org/netdev/net-next/c/de84a090d99a
  - [v3,net-next,10/11] net: ethernet: mtk_eth_wed: add axi bus support
    https://git.kernel.org/netdev/net-next/c/2b2ba3ecb241
  - [v3,net-next,11/11] net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986
    https://git.kernel.org/netdev/net-next/c/03a3180e5c09

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


