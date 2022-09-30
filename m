Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583455F09D6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiI3LRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiI3LQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:16:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC89A7228;
        Fri, 30 Sep 2022 04:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3821DCE24CD;
        Fri, 30 Sep 2022 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62C0FC433D7;
        Fri, 30 Sep 2022 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664535617;
        bh=A1VlmBks7Q6/XSUEg+ijZ59ILJPGN/96FVPihsuhx5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EPnN/kIgrTs7JjxqPKJTSARH+5KVU69JrDCJQq5DCqGhvs1WrT3FoSWGnu1kD1J4e
         wDT6gKO72I8TdjCX+3oir32uslqQvxYFJnHrGk06byHAGCkriPUPGosDeGW90f5pKC
         3y+aSpNSgPrbfS6Uai7zqVQB7tERxGxrVjeTEMwx8lK6gXG+SX+jX02GFndcIzbnNe
         Ryq1DyU7h71fPHb0lBxKGMpK6Oom0IFeDdBojjLIKPE050RFl727Y+oeYV705JaYmZ
         kdj9Eomo/UYjPFn8GqtMS7vH2ctwDuDGsrUCJtkiOMya//6MWdR03o1oE2KWdYqXR8
         u91ZVH8+7gLmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45FC1E49FA5;
        Fri, 30 Sep 2022 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/6] tsnep: multi queue support and some other
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453561728.12525.13335744248938169663.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:00:17 +0000
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 27 Sep 2022 21:58:36 +0200 you wrote:
> Add support for additional TX/RX queues along with RX flow classification
> support.
> 
> Binding is extended to allow additional interrupts for additional TX/RX
> queues. Also dma-coherent is allowed as minor improvement.
> 
> RX path optimisation is done by using page pool as preparations for future
> XDP support.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] dt-bindings: net: tsnep: Allow dma-coherent
    https://git.kernel.org/netdev/net-next/c/ff46c610abd6
  - [net-next,v4,2/6] dt-bindings: net: tsnep: Allow additional interrupts
    https://git.kernel.org/netdev/net-next/c/60e1b494ef88
  - [net-next,v4,3/6] tsnep: Move interrupt from device to queue
    (no matching commit)
  - [net-next,v4,4/6] tsnep: Support multiple TX/RX queue pairs
    https://git.kernel.org/netdev/net-next/c/762031375d5c
  - [net-next,v4,5/6] tsnep: Add EtherType RX flow classification support
    https://git.kernel.org/netdev/net-next/c/308ce1426509
  - [net-next,v4,6/6] tsnep: Use page pool for RX
    https://git.kernel.org/netdev/net-next/c/bb837a37db8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


