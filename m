Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4471F6DA96F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 09:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjDGHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 03:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDGHaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 03:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E28A5B
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 00:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ABDA616C2
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0666BC4339B;
        Fri,  7 Apr 2023 07:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680852618;
        bh=YFp/3nYwK87Rj0t0ft8VUCoQMCrwWVsqvzBmJu0bM34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hhP+69ccmshLgjl4WWqWUDggAvAFhlW0uCv7Qf+QpXI/1+vzOw00OV5IA4SiGzKc2
         l83loLJ9TqGeV77pHkqn/i4ektlw76qdXsSVUySvv0CmlM6+QpT+6R52a4IWm1QfrI
         q5wlGPbz9xxc5WmiLHuSFjSzjMrIPzxd+LF2GN+EwVyrjm8egtYUAFdM94BWgtMavF
         QQdtG6c5oboujO43IRf6naraVkvQxEyqYKGQy4h41VeB2ZeTm2xVtiLFLk5qOrnqsO
         yxr5TpsjBoYmugxxEi47csSaijPg+KnvHYwKw4aEMZca61dQvW+5shRG5MyW2+bUtP
         f9EkLHQ6Vm2OA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1FE7E4F14C;
        Fri,  7 Apr 2023 07:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168085261792.18358.11388432319659381723.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 07:30:17 +0000
References: <20230405151026.23583-1-nbd@nbd.name>
In-Reply-To: <20230405151026.23583-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Apr 2023 17:10:25 +0200 you wrote:
> WED version 2 (on MT7986 and later) can offload flows originating from
> wireless devices.
> In order to make that work, ndo_setup_tc needs to be implemented on the
> netdevs. This adds the required code to offload flows coming in from WED,
> while keeping track of the incoming wed index used for selecting the
> correct PPE device.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/2] net: ethernet: mtk_eth_soc: add code for offloading flows from wlan devices
    https://git.kernel.org/netdev/net-next/c/05f3ab7780b3
  - [v4,net-next,2/2] net: ethernet: mtk_eth_soc: mtk_ppe: prefer newly added l2 flows
    https://git.kernel.org/netdev/net-next/c/e28531143b25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


