Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E125E79CA
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiIWLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiIWLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E92E6DD2;
        Fri, 23 Sep 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72AD861212;
        Fri, 23 Sep 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDF07C43140;
        Fri, 23 Sep 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663933215;
        bh=n08TmWTnWeLaBfgL2+/BA9JbtQDLVwrUwYpxk0UBKwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZuSu5SGJn3rix/RPGJNEGBjoIUdgfwaErIZdOcuuP3AkGzxK0SrB/dVnaSSe4P/As
         ZBWdCJeGnDwKjHexzFenUPYvcyPjvztlCwGFtSdQ6ZWvgCzLp9Jjj1tpALNKazmctM
         Cxdmh8wHKbRsxNudghW/hUrt9Hd6RnV8r4YfQlArdUNCtUnM8/xFgpjTRJuzRDwC4A
         FlAqNo7ppqca/GhFdzAfBgAs0X3QEEIYSKtQnw8YiGHa6fBLmyTvTLnOWjSV6Sz6Bq
         EpdvrnQH0LflyV3B06pvyt+i5ExQWXRfWP2u3xM5gyX61geRxA3zs/NCpZQNidlyoe
         /phJ080qrSsLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B998DE4D03B;
        Fri, 23 Sep 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: lan966x: Add mqprio and taprio support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393321575.30956.3745059563392195968.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:40:15 +0000
References: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 21 Sep 2022 14:25:34 +0200 you wrote:
> Add support for offloading QoS features with tc command to lan966x. The
> offloaded QoS features are mqprio and taprio.
> 
> v1->v2:
> - fix compilation warning
> - rename lan966x_taprio_enable/disable to lan966x_taprio_add/del
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: lan966x: Add define for number of priority queues NUM_PRIO_QUEUES
    https://git.kernel.org/netdev/net-next/c/644ffce5f1be
  - [net-next,v2,2/4] net: lan966x: Add offload support for mqprio
    https://git.kernel.org/netdev/net-next/c/3c83431f0795
  - [net-next,v2,3/4] net: lan966x: Add registers used by taprio
    https://git.kernel.org/netdev/net-next/c/2a252a0bd2e9
  - [net-next,v2,4/4] net: lan966x: Add offload support for taprio
    https://git.kernel.org/netdev/net-next/c/e462b2717380

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


