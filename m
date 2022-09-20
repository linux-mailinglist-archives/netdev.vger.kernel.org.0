Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B285BEA63
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiITPkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiITPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687B8402FE;
        Tue, 20 Sep 2022 08:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2797626E5;
        Tue, 20 Sep 2022 15:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08016C43144;
        Tue, 20 Sep 2022 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663688417;
        bh=YIRciOcL31CLbwJL3Rs1qEeMQ2LC0KieJ5ByoZ71x0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e6HiPRbc/lwWyQUF6azUSCxkx9ixiMUcQSrSS+eIoQnn9pMvf8I+ZM4BQ7S097vLp
         b2kcBWXlglOtD7deD9wwyWsuqdA7WPDPuHnEdRLk02qYyqMe/1d1R0OpWu5DmsHYiR
         awNj5mKCmRaYHuQcqTvid5mCCmRqu0wYpHjD4y9Klc7h/3VO1Vp5UxLyW3aXcIE6LL
         gTEwghJzr+b8S8unFjiHT9jBvxfNTEJmSoroPnpL76bkTIbDeneaWt903QCyqUaMcJ
         jG5JEnkIEvVXwx4nKmoouG3o2s4XPI1erZTFMrGXxwLouYhttZh/a4eOr1ez0PX0/w
         jZ/FnHjZjhyMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4667E21EE1;
        Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] macb: add zynqmp SGMII dynamic configuration
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368841692.10369.13627897349708750075.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:40:16 +0000
References: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
To:     Pandey@ci.codeaurora.org,
        Radhey Shyam <radhey.shyam.pandey@amd.com>
Cc:     michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, andrew@lunn.ch,
        conor.dooley@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, git@amd.com
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

On Wed, 14 Sep 2022 18:03:14 +0530 you wrote:
> This patchset add firmware and driver support to do SD/GEM dynamic
> configuration. In traditional flow GEM secure space configuration
> is done by FSBL. However in specific usescases like dynamic designs
> where GEM is not enabled in base vivado design, FSBL skips GEM
> initialization and we need a mechanism to configure GEM secure space
> in linux space at runtime.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] firmware: xilinx: add support for sd/gem config
    https://git.kernel.org/netdev/net-next/c/256dea9134c3
  - [v3,net-next,2/2] net: macb: Add zynqmp SGMII dynamic configuration support
    https://git.kernel.org/netdev/net-next/c/32cee7818111

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


