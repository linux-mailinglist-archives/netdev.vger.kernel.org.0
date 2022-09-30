Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6CB5F0B66
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiI3MK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiI3MKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A706DFBA;
        Fri, 30 Sep 2022 05:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33504B82895;
        Fri, 30 Sep 2022 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D849EC43470;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664539817;
        bh=Wr9kLRkpR89dsJoFBQYKEU+VDLeRWEFtjxk7UOSaQIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GcJf0GR0bU7IOZnZi7DJA0OYE7pugV3SZD7osq3e1LC6SmOBOTHvkLfAeJCPzLlgx
         KaTFe6EdbWne43W1pVCDxguRGzeOWcWzXp9kHBkXk01T0jtbXh8OeMT5HJQKU65+O8
         oTUTeoYh+3oJiGjD59jnwW6YYT2+1E4mSMouo3JgkOFivkYMOC5sfpEAqUYJsw7s8L
         9xgtby86T/5oa8QS2BxD42CvKbV7dm68RkBPO4vm7N4G4vCf28sndMHz5N2Dyq5dKV
         NakcWPPqJMDKn/HEe5LYQofpCghNUUGNMzaE6wYonKF58FS/16483IbroiegSrCJ2h
         U0E9Hm3LnlDuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6DD5C395DA;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/4]  Mediatek ethernet patches for mt8188
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453981774.22292.11611575581235201348.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:10:17 +0000
References: <20220929014758.12099-1-jianguo.zhang@mediatek.com>
In-Reply-To: <20220929014758.12099-1-jianguo.zhang@mediatek.com>
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, matthias.bgg@gmail.com,
        biao.huang@mediatek.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 29 Sep 2022 09:47:54 +0800 you wrote:
> Changes in v7:
> 
> v7:
> 1) Add 'Reviewed-by: AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com>' info in commit message of
> patch 'dt-bindings: net: snps,dwmac: add new property snps,clk-csr',
> 'arm64: dts: mediatek: mt2712e: Update the name of property 'clk_csr''
> and 'net: stmmac: add a parse for new property 'snps,clk-csr''.
> 
> [...]

Here is the summary with links:
  - [v7,1/4] dt-bindings: net: mediatek-dwmac: add support for mt8188
    https://git.kernel.org/netdev/net-next/c/c827b7a3fed5
  - [v7,2/4] dt-bindings: net: snps,dwmac: add new property snps,clk-csr
    https://git.kernel.org/netdev/net-next/c/22ba1afdec08
  - [v7,3/4] arm64: dts: mediatek: mt2712e: Update the name of property 'clk_csr'
    https://git.kernel.org/netdev/net-next/c/7871785ce92d
  - [v7,4/4] net: stmmac: add a parse for new property 'snps,clk-csr'
    https://git.kernel.org/netdev/net-next/c/83936ea8d8ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


