Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF966A92E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 05:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjANEVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 23:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjANEU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 23:20:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75465CF;
        Fri, 13 Jan 2023 20:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3840AB822C3;
        Sat, 14 Jan 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E254BC433D2;
        Sat, 14 Jan 2023 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673670018;
        bh=0dhxVKVYAQCb3I8V/YstF7Gf/H5D9l/vkiCFM10OCHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OMSOfAul4s8g9qt1FUnfo3pZ8uH212gnkdbgTCxGys3iARj92IsifxSXm9SDBoRJ9
         qylKkPxR0CDJtPiy/P1kSNjInaJDmnC4HJRBXvBVy5AfSc2dKokm7QUM6utqMYlnxJ
         Dk5ljJ75xqPsebqC7dxtKLDRcTfkcmb47lN3vQrNdm7ovksTmtidljOGOFALLH6+w3
         ROzNJeZONvNfa0hRRMk7zlCnfURctDnvXzgmd9EqMquu8f92WmLeLdanoVx4+mi8Gx
         jw7FCi9aXjoSyUfGacei0e5FKM7BNISNFMftGCzygZ4XonH6bsKgLvzdmNir70RtsS
         jIXb3+71AjUWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE181C395CA;
        Sat, 14 Jan 2023 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367001777.13418.2773898976513419135.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 04:20:17 +0000
References: <20230111172437.5295-1-anand@edgeble.ai>
In-Reply-To: <20230111172437.5295-1-anand@edgeble.ai>
To:     Anand Moon <anand@edgeble.ai>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, heiko@sntech.de,
        david.wu@rock-chips.com, jagan@edgeble.ai, jbx6244@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Jan 2023 17:24:31 +0000 you wrote:
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> fix below warning
> $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> 		 compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> 
> [...]

Here is the summary with links:
  - [v5,linux-next,1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
    https://git.kernel.org/netdev/net-next/c/e471d83e1fa0
  - [v5,linux-next,3/4] ARM: dts: Add Ethernet GMAC node for RV1126 SoC
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


