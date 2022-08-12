Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E0590F7D
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiHLKa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238320AbiHLKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:30:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E191659D;
        Fri, 12 Aug 2022 03:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90BAFCE2559;
        Fri, 12 Aug 2022 10:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2151C43143;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300216;
        bh=2llNiipRiRT6i5mBnfanHZMj/KVyERXjYWBc7aW+Bbw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oXGKkFkSbjcrXpjiIgTq4dmGTLRp2o5crAOcBUVu1ddxFyTo9xfSzo0Jq+QNX2Cpp
         GkPspt0qvYhz5WmXxHY+P9on0ksdnsuNqEQ1ix4bZw9No1rNO8MCl2R5K53coyPLsE
         9IRp0QeuSbmaCmrJ+Rg6uIF8xDXQfqCl6BCgeDmKyelnJokDQQpauby9GXcUHR4JDV
         L7umznAtUUYt/6tqdITHdQnwgXq4rZEQmSrXpxmEwvP2IubK5nc2KrrPdM/ukaGaFO
         O4R1GS7DxZk0I1wgC0SlaRJIC3ElUF/4WEQKHfNCALeUh6V0A+2vrJVlzK7dZC2BCH
         1aVBjeGhgpWBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A769DC43145;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: Fix comment typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030021668.10916.14016595032942187489.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:30:16 +0000
References: <20220811115259.64225-1-wangborong@cdjrlc.com>
In-Reply-To: <20220811115259.64225-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     edumazet@google.com, elder@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Aug 2022 19:52:59 +0800 you wrote:
> The double `is' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ipa/ipa_reg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ipa: Fix comment typo
    https://git.kernel.org/netdev/net/c/9221b2898a58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


