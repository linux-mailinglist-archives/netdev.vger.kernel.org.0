Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335A66DB85B
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 04:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDHCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 22:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDHCuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 22:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C91D307;
        Fri,  7 Apr 2023 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20921654E8;
        Sat,  8 Apr 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8074BC433A7;
        Sat,  8 Apr 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680922219;
        bh=TM1ojHIWWFPsul7N7OXPNPZ/9bDsamVeJHrNvgQxFjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HoUnAD5KK2fDfR10nrfeRRkGDowR+BZ4VgdGtjhFl1XBCXEE/2CVkCU3fIlFAwB84
         VkZxIxDe1Ov2fWr5xbWgGh8/yGFfABCHpnHmsPl1pExgX1q2VV6dSI1iJ7Kk/y5lNO
         ovqJM6AL1QM/kWr/THdiriErLkXUX5hRxBzj8DG4jE4Zc+l2ukGgWMP2YG2+XDcTKq
         SnKREZ2i4Y4+IGnkWGnXu9Q2KfR0sxGT6j53q0XPmPmKfDWaOwel6Bf9eM8cKMvWhT
         fpYJFKVJ0vcPOVBj6NxG2am3Ux732/w1lGETTutPvYwXHN8QCvJsUuresNH9Vhihyt
         hDnSXqKeXOO7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A1C4C395C5;
        Sat,  8 Apr 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] Add support for J784S4 CPSW9G
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092221942.13259.3463026637249012039.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 02:50:19 +0000
References: <20230404061459.1100519-1-s-vadapalli@ti.com>
In-Reply-To: <20230404061459.1100519-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
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

On Tue, 4 Apr 2023 11:44:56 +0530 you wrote:
> Hello,
> 
> This series adds a new compatible to am65-cpsw driver for the CPSW9G
> instance of the CPSW Ethernet Switch on TI's J784S4 SoC which has 8
> external ports and 1 internal host port.
> 
> The CPSW9G instance supports QSGMII and USXGMII modes for which driver
> support is added.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: ethernet: ti: am65-cpsw: Move mode specific config to mac_config()
    https://git.kernel.org/netdev/net-next/c/ce639b767139
  - [net-next,v3,2/3] net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
    https://git.kernel.org/netdev/net-next/c/4e003d61e795
  - [net-next,v3,3/3] net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G
    https://git.kernel.org/netdev/net-next/c/8e672b560e0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


