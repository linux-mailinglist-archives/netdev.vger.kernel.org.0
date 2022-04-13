Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C44FF592
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiDMLWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiDMLWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:22:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9502181C;
        Wed, 13 Apr 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30BFB82245;
        Wed, 13 Apr 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7912AC385A9;
        Wed, 13 Apr 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649848812;
        bh=8h7YR5DLlW61LbK41Fvd2WIxCYm4jM/wS0fXOSB/H2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OKBuNS5b9DBuJ+UjPwktOZov/BI3/zCXR+Gp8z36OidHDdtDVjiL2tP+inaJ4SGX3
         3VP/5a2Hdh11rLAfD7VebG0Sy3eZ8B4/t3BDhP8MM9rr69l6Ya9E/Np1aYac+GHrG6
         4oL1mviR4rVUhEfzzi62F3LRGGDKE3p1zXCX6Fsv7n3hMANfBYsHAS1bPUYj7DfQkS
         tMBTlb3/NPj8SAZE9Fisj5tAKavvxacCY/OpZVlEFxxBhV3Q43xsiTjYIihmsTC3Xa
         grzwHXBkV4ZTsVm4oSNfOeVJrpdhGOi/o/nWogwtIzkNpqSpLVaA2q7VlKIN7YLw/4
         0OTHRq+R/km9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C87DE8DD67;
        Wed, 13 Apr 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: use standard property
 for cci-control-port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984881237.9861.16235738192833195906.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:20:12 +0000
References: <40598de79a6317fdd3a44dfe29ce4223e1e0d3ed.1649671814.git.lorenzo@kernel.org>
In-Reply-To: <40598de79a6317fdd3a44dfe29ce4223e1e0d3ed.1649671814.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh@kernel.org, devicetree@vger.kernel.org, nbd@nbd.name
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
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Apr 2022 12:13:25 +0200 you wrote:
> Rely on standard cci-control-port property to identify CCI port
> reference.
> Update mt7622 dts binding.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  arch/arm64/boot/dts/mediatek/mt7622.dtsi    | 2 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: use standard property for cci-control-port
    https://git.kernel.org/netdev/net-next/c/4263f77a5144

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


