Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A975ACEEA
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbiIEJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiIEJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B084A10B;
        Mon,  5 Sep 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D650BB8100B;
        Mon,  5 Sep 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96CFAC433C1;
        Mon,  5 Sep 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662370215;
        bh=dd+/mrbHZ88yW/26hWzIARKyi4u6D6FejGhF568gvu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X4LVxYlHslkmqZOyd+H/2BPpboJh2bxchxqGOWtcmfnIDUMhqpyFvlK6/Lv2O/hSW
         fsTdFtDdNWOlsGY9PD0SRlzkKIwFzYl/SFjBQmRNMT4QvypJpWF1ddAlIXXWBO2dtn
         iiG6ycWG0UaRN6nwcYYnnwgheoyMFFRIqTsjP764I5FdXyaRfTSfdCruqnKf8sWNkP
         8vImTCGcF+c+YEryFL8eEnw2H9rg6iZps1R6WuExOGik0LMSmYS2ZuJMsH/sfuaopn
         4k4Sv6JiO9oHcgVko7G/lXer9e/jqmHqSkjGeYSiKFjXjPk6qz3aQwE8J9625smMYg
         YVL5wAaQ40RCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E6ABC4166E;
        Mon,  5 Sep 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] net: altera: tse: phylink conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166237021551.30175.16863165835854438404.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 09:30:15 +0000
References: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        andrew@lunn.ch, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski@linaro.org, devicetree@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 10:32:00 +0200 you wrote:
> This is V4 of a series converting the Altera TSE driver to phylink,
> introducing a new PCS driver along the way.
> 
> The Altera TSE can be built with a SGMII/1000BaseX PCS, allowing to use
> SFP ports with this MAC, which is the end goal of adding phylink support
> and a proper PCS driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] dt-bindings: net: Convert Altera TSE bindings to yaml
    https://git.kernel.org/netdev/net-next/c/b0155d909690
  - [net-next,v4,2/5] net: altera: tse: cosmetic change to use reverse xmas tree ordering
    https://git.kernel.org/netdev/net-next/c/5adb0ed04535
  - [net-next,v4,3/5] net: pcs: add new PCS driver for altera TSE PCS
    https://git.kernel.org/netdev/net-next/c/4a502cf4d77e
  - [net-next,v4,4/5] net: altera: tse: convert to phylink
    https://git.kernel.org/netdev/net-next/c/fef2998203e1
  - [net-next,v4,5/5] dt-bindings: net: altera: tse: add an optional pcs register range
    https://git.kernel.org/netdev/net-next/c/565f02fc1e5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


