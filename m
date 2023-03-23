Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA51C6C5E39
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCWEvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCWEu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59144C3D;
        Wed, 22 Mar 2023 21:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF676236E;
        Thu, 23 Mar 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 853F2C4339B;
        Thu, 23 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679547019;
        bh=MbvMu3rd50D+yU7oFqgsU4OhL/Yysf7P1eFd49ooYCc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TUQR7GZAGZ8+ux0AWOX70TdKcoZ3Cob3HIsTuXbQcjlvSSxCoLcCPis2cek8RnfBq
         VxzdkoQ+mn6nmzmmnPtSPLs5zaH7aGWtzARVcj+Fm0rehMSTShs77HLgM9dIDs14tK
         24XsQVAcFQoBafzPgVNXojX1P3zKvxFuDHfgySNCP5J+yYEvxYTvAITW8U8q4UZF77
         vq+/akjs7GpxMS7JXFi3hxA/m+OH7I47FlFH3D2N1w7jZ3SZd2lJHexFDKCCJFh5AQ
         7X2MWfxlSW1Qmsbujgtx94k7NqO/S79LTb8y7pRW6Wy+p71ubA29KAnaLveKyTdZ3e
         DfPM6xiTu+GsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64843E61B85;
        Thu, 23 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] net: dsa: b53: configure 6318 and 63268 RGMII ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954701940.19209.2589458532549519819.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 04:50:19 +0000
References: <20230321173359.251778-1-noltari@gmail.com>
In-Reply-To: <20230321173359.251778-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 18:33:55 +0100 you wrote:
> BCM6318 and BCM63268 need special configuration for their RGMII ports, so we
> need to be able to identify them as a special BCM63xx switch.
> In the meantime, let's add some missing BCM63xx SoCs to B53 MMAP device table.
> 
> This should be applied after "net: dsa: b53: add support for BCM63xx RGMIIs":
> https://patchwork.kernel.org/project/netdevbpf/patch/20230319220805.124024-1-noltari@gmail.com/
> 
> [...]

Here is the summary with links:
  - [v2,1/4] dt-bindings: net: dsa: b53: add more 63xx SoCs
    https://git.kernel.org/netdev/net-next/c/3ec5ac3133b5
  - [v2,2/4] net: dsa: b53: mmap: add more 63xx SoCs
    https://git.kernel.org/netdev/net-next/c/a2b212fe5c32
  - [v2,3/4] net: dsa: b53: mmap: allow passing a chip ID
    https://git.kernel.org/netdev/net-next/c/260887c770eb
  - [v2,4/4] net: dsa: b53: add BCM63268 RGMII configuration
    https://git.kernel.org/netdev/net-next/c/594c6c2e3ea2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


