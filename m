Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1490E515CF8
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239427AbiD3Mnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiD3Mnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B02AE65;
        Sat, 30 Apr 2022 05:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F02EDB82A2E;
        Sat, 30 Apr 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B540C385B2;
        Sat, 30 Apr 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651322411;
        bh=njCu1m65rgEbSSl42vrsYLV37nwXG8vVV8ydc6/uDAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JwVJn04JhGl5yJc2D6ynBkz4iSkU5M67izN/N+IjywKnrYpDl3TH7YGv9UwClvkMd
         E4NHdYyLFey3ddPMEmNb5J8gMyj0o8b7jch4bq+sy8QFxlZ9z/kRMQvvUr/0XueCVC
         KGEenujeNDAq7ma2U36x0T08y8VYEntUTaOeTlq3CC9rz/BLQlwU4evYKBlUUh34xT
         HekcE/sMkUyh/8UIR1Nh1A5LMY9IQJGlphUrKwK8ER2j0RicYcG3a3wrwck3j+zu/b
         AD9/P37iPZE7/iYwXKZ5s2B/ISxvuIMoMWZc+P1ENZlgvDnyd1uABx2WDYnzm1/kqR
         mPnyduTzmKSeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7622CF03841;
        Sat, 30 Apr 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 0/1] net: ethernet: ocelot: remove num_stats
 initializer requirement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132241148.25919.3888627591098441730.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 12:40:11 +0000
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
In-Reply-To: <20220429213036.3482333-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 14:30:35 -0700 you wrote:
> The ocelot_stats_layout structure array is common with other chips,
> specifically the VSC7512. It can only be controlled externally (SPI,
> PCIe...)
> 
> During the VSC7512 / Felix driver development, it was noticed that
> this array can be shared with the Ocelot driver. As with other arrays
> shared between the VSC7514 and VSC7512, it makes sense to define them in
> drivers/net/ethernet/mscc/vsc7514_regs.c, while declaring them in
> include/soc/mscc/vsc7514_regs.h
> 
> [...]

Here is the summary with links:
  - [v1,net-next,1/1] net: ethernet: ocelot: remove the need for num_stats initializer
    https://git.kernel.org/netdev/net-next/c/2f187bfa6f35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


