Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3552E22B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiETBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344614AbiETBuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F78AE64E1
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFFD9B829D6
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66105C34116;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653011413;
        bh=57sdfmmEXZQvqi+MukSpw+fQm/g+3GqqUoDqhTwJtv0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rV4QPQ1AP39/9UNxAKr2rmjyaUPfX2bQAvuowqA9rrv9A9b+Mnh09cbPSGzcZ02HD
         LuqixV+iTEJDlWbUw5TFitpLKvXwTooyu0hESMDfYzz3IdI2MoQn+KeTIhLOBw4636
         M3svnhE+Zdtd1T+/fVWdg6SPR+NMjBfCQMQwCTlGioe6XnvVR44QdYxvoa0X7260Vo
         rxYXWju+zKIHqX1UJGOrkZQYFpWubYOs8U9vHw1RVqscMEdRH3jEf6r6REclAvkyzr
         uXWkF7WfNVap/juuajDS++axxLlxF07GBuyReDd4bzumX3QHnr+a29C6dHldl0HyJv
         woxSR3vft0HBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42F83E8DBDA;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: don't proceed to out-of-bound write
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301141326.6731.4497591034558946002.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:50:13 +0000
References: <20220519004417.2109886-1-kuba@kernel.org>
In-Reply-To: <20220519004417.2109886-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, elder@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 17:44:17 -0700 you wrote:
> GCC 12 seems upset that we check ipa_irq against array bound
> but then proceed, anyway:
> 
> drivers/net/ipa/ipa_interrupt.c: In function ‘ipa_interrupt_add’:
> drivers/net/ipa/ipa_interrupt.c:196:27: warning: array subscript 30 is above array bounds of ‘void (*[30])(struct ipa *, enum ipa_irq_id)’ [-Warray-bounds]
>   196 |         interrupt->handler[ipa_irq] = handler;
>       |         ~~~~~~~~~~~~~~~~~~^~~~~~~~~
> drivers/net/ipa/ipa_interrupt.c:42:27: note: while referencing ‘handler’
>    42 |         ipa_irq_handler_t handler[IPA_IRQ_COUNT];
>       |                           ^~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: don't proceed to out-of-bound write
    https://git.kernel.org/netdev/net-next/c/1172aa6e4a19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


