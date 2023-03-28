Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7656CBB85
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbjC1JvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjC1Juo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C937682
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC9C60E65
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34639C433EF;
        Tue, 28 Mar 2023 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679997019;
        bh=7fFgILf/h3c8mwH2eiB4ST6qMmwAT2oqJA9MByazeAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fUZyu0jHpMMRTlrgxqIs9T89ZgyYHTlJfllqOZSaoohbk2Tlb+TT7JBFZ3hl+ZcBe
         sQMQbSzDWf7RckqjQKPjF6ptl2JEKLDB94cbwrVM8VaHgP8kxLFXUnGFXALQmixL1v
         ZxmRA68LlD1B+tiueYgZI2vzD1s3C+65idmekEwxMn+JZFPYwT3oS/IklN+vFQJDHn
         7mw78vCrm9CFYOVX2+x+NwV4jhidnIW+PC7nQT1cg5fKqpubIOXAb+3BIZqSNTxHei
         UYACcNWVkY+1636Vxnv31gJgIFZHdDy5IKz37ZXYax4vaiV6QwnkjK2WJE9mgRMHGe
         uZVRK2hc7YZ5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15FD0E4D01A;
        Tue, 28 Mar 2023 09:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] net: mvpp2: rss fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167999701908.28396.17253986050227713973.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 09:50:19 +0000
References: <20230325163903.ofefgus43x66as7i@Svens-MacBookPro.local>
In-Reply-To: <20230325163903.ofefgus43x66as7i@Svens-MacBookPro.local>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net,
        maxime.chevallier@bootlin.com, pabeni@redhat.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 25 Mar 2023 17:39:03 +0100 you wrote:
> This patch series fixes up some rss problems
> in the mvpp2 driver.
> 
> The classifier is missing some fragmentation flags,
> the parser has the QinQ headers switched and
> the PPPoE Layer 4 detecion is not working
> correctly.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] net: mvpp2: classifier flow fix fragmentation flags
    https://git.kernel.org/netdev/net/c/9a251cae51d5
  - [v3,2/3] net: mvpp2: parser fix QinQ
    https://git.kernel.org/netdev/net/c/a587a84813b9
  - [v3,3/3] net: mvpp2: parser fix PPPoE
    https://git.kernel.org/netdev/net/c/031a416c2170

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


