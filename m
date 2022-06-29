Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F4356007E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiF2Mu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiF2MuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:50:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4602333359;
        Wed, 29 Jun 2022 05:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D140CE26B3;
        Wed, 29 Jun 2022 12:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B5E9C36AEB;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656507020;
        bh=22qbZjl+tGNRO/TXIBShg7yeUCuIna+Zbm1sCVa288s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pmYPMa5AmhgzWtFVALexiat96BVZmsO7B7kq77lmXZmB8fW7x7+9GuVPfNC7iC2Wd
         KRvYFQ4fs0XDAlzIIzta2dBQxi0PF1QPl5VbIQtmSGq5he+8e8Ie09GZgZCqHImwUY
         qaZupQXWStSFj5ZYIHN7Ly98YpjrJZ9qjSpEQW+8+VQCMCr3IDcb6Sc4qg54M1KMtA
         vV5udrfEDEraUr+QwduI1n0ReExOXf47chKlOrjhMzz4cjO5fbqG6Z8XXjyK7w1VXj
         xKJhSdM0po6eafMtrVCPGan9OATjf5+tB8xAyvYnlhdRyb9X6V5T0xuw2yT6dS+Brz
         CAGReuXMW3BQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B39CE49FA0;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 00/10] add more features for mtk-star-emac
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650702016.9231.359699610048975854.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 12:50:20 +0000
References: <20220629031743.22115-1-biao.huang@mediatek.com>
In-Reply-To: <20220629031743.22115-1-biao.huang@mediatek.com>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        brgl@bgdev.pl, fparent@baylibre.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, ot_yinghua.pan@mediatek.com,
        macpaul.lin@mediatek.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Jun 2022 11:17:33 +0800 you wrote:
> Changes in v5:
> 1. correct spin_lock usage which are missed in v4.
> 
> Changes in v4:
> 1. correct the usage of spin_lock/__napi_schedule.
> 2. fix coding style issue as Jakub's comments.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/10] net: ethernet: mtk-star-emac: store bit_clk_div in compat structure
    https://git.kernel.org/netdev/net-next/c/c16cc6a06672
  - [net-next,v5,02/10] net: ethernet: mtk-star-emac: modify IRQ trigger flags
    https://git.kernel.org/netdev/net-next/c/9ccbfdefe716
  - [net-next,v5,03/10] net: ethernet: mtk-star-emac: add support for MT8365 SoC
    https://git.kernel.org/netdev/net-next/c/6cde23b3ace5
  - [net-next,v5,04/10] dt-bindings: net: mtk-star-emac: add support for MT8365
    https://git.kernel.org/netdev/net-next/c/43360697a276
  - [net-next,v5,05/10] net: ethernet: mtk-star-emac: add clock pad selection for RMII
    https://git.kernel.org/netdev/net-next/c/85ef60330d37
  - [net-next,v5,06/10] net: ethernet: mtk-star-emac: add timing adjustment support
    https://git.kernel.org/netdev/net-next/c/769c197b097c
  - [net-next,v5,07/10] dt-bindings: net: mtk-star-emac: add description for new properties
    https://git.kernel.org/netdev/net-next/c/320c49fe31b0
  - [net-next,v5,08/10] net: ethernet: mtk-star-emac: add support for MII interface
    https://git.kernel.org/netdev/net-next/c/0027340a239b
  - [net-next,v5,09/10] net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs
    https://git.kernel.org/netdev/net-next/c/0a8bd81fd6aa
  - [net-next,v5,10/10] net: ethernet: mtk-star-emac: enable half duplex hardware support
    https://git.kernel.org/netdev/net-next/c/02e9ce07d8b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


