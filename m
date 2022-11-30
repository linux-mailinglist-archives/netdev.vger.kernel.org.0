Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B07B63CE68
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiK3EkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiK3EkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2F25A6CE;
        Tue, 29 Nov 2022 20:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DBA4B819FF;
        Wed, 30 Nov 2022 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DEB2C433D6;
        Wed, 30 Nov 2022 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669783217;
        bh=ZNKh4Is0Y7XVydHlvpOSrsFh0+555NoYYyztIowis+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MKQY8+malkOWJk0HP7MrjEeGovp3rQ53TMvhgNk3Q0libkmgLA15cB5/JBqVyxY2w
         PMEDIc/7B5Xn4naMtEyGifDXRVx32HhxDi/aVXcHVPam4ctO4bixwKWhPskE7P3nDL
         uz6NhrSD8MNLsGK2SzvsC02h5P77Q5dmNJMoxt8JwyUTssPaGwZyXKtgPZq5mlGYU2
         exJ5N5LhIh50dNcwrOSZ+VjMe19IARMQ9DF9Za1hqD23YC9bZ20DSCiuN/JB2bJ4cV
         wNOXEqVUmN0qOmu0FEDqugMJ1EXUT2dX9fAkONwFt6d8rx7fMvBpw18WOlVN7XKtgA
         Bb0Fw/1JRSJOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21B6DE21EF2;
        Wed, 30 Nov 2022 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: pcs: altera-tse: simplify and clean-up the
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166978321713.408.17819608476180622589.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Nov 2022 04:40:17 +0000
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        andrew@lunn.ch, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski@linaro.org, devicetree@vger.kernel.org
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

On Fri, 25 Nov 2022 14:17:58 +0100 you wrote:
> Hello everyone,
> 
> This small series does a bit of code cleanup in the altera TSE pcs
> driver, removong unused register definitions, handling 1000BaseX speed
> configuration correctly according to the datasheet, and making use of
> proper poll_timeout helpers.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: pcs: altera-tse: use read_poll_timeout to wait for reset
    https://git.kernel.org/netdev/net-next/c/d1a0ff5ff9ef
  - [net-next,2/3] net: pcs: altera-tse: don't set the speed for 1000BaseX
    https://git.kernel.org/netdev/net-next/c/b4a7bf9f5bb8
  - [net-next,3/3] net: pcs: altera-tse: remove unnecessary register definitions
    https://git.kernel.org/netdev/net-next/c/befd851de295

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


