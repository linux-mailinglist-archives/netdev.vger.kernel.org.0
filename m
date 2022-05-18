Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E42252B989
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiERMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiERMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BAF14674D;
        Wed, 18 May 2022 05:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E55E96120D;
        Wed, 18 May 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4275EC385AA;
        Wed, 18 May 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875812;
        bh=PBKXH9hR2tq9LotuNLlBKagto2q0hMT3J7cJiE3d5f8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=odYTIl2ar8/8n8Q2gfJq7lbz0fXLixEOAD/Kpjg4onSFutGsNF/lQwHY8dxIfPSmk
         nUqsUbzAPMM2abhG8/y5wHhOqePqUQowWT2/uGZADJbUYiqXAwgAj1KhLGaiIk9EPp
         dR14Bru3rr30y+emln5KKB87M7GPylxCyhFNgvTiwMM9QEtVCUz5K3BDZkjUzR4FyJ
         lJAJ1ez61V+PvoDwbZWSrPrSflq7R1Y7I4EYuqQFsl8h8opmzhj3ryh7ZlS96fztMj
         yfSjrg5McAfPsAY+sNz7yAYeHjRcBPErnZmRwyY0X665Nw0Ti2eF8BxWNPnaeMtwsP
         urnMYmlJIfeQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24723F0392C;
        Wed, 18 May 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] armada-3720-turris-mox and orion-mdio
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287581214.23704.818165167398483936.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:10:12 +0000
References: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        kabel@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 17 May 2022 10:47:59 +1200 you wrote:
> This is a follow up to the change that converted the orion-mdio dt-binding from
> txt to DT schema format. At the time I thought the binding needed
> 'unevaluatedProperties: false' because the core mdio.yaml binding didn't handle
> the DSA switches. In reality it was simply the invalid reg property causing the
> downstream nodes to be unevaluated. Fixing the reg nodes means we can set
> 'unevaluatedProperties: true'
> 
> [...]

Here is the summary with links:
  - [1/2] arm64: dts: armada-3720-turris-mox: Correct reg property for mdio devices
    https://git.kernel.org/netdev/net-next/c/9fd914bb05c2
  - [2/2] dt-bindings: net: marvell,orion-mdio: Set unevaluatedProperties to false
    https://git.kernel.org/netdev/net-next/c/32d0efabeec0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


