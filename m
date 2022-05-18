Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968E852BC2F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbiERNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiERNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:00:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544711A490A;
        Wed, 18 May 2022 06:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B83CB82011;
        Wed, 18 May 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3E23C3411B;
        Wed, 18 May 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652878811;
        bh=ewLhXzl4evBQ5bhwbwqCw5ixGLCJ1ubKJAU7euCx42E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HG/b97J5w5DCdZpEgOshkSd6i9YtA373Lqzt71AQ1yqssWNJEhZ2+RcV97RUHy8++
         Fv3BRBB7SztL0n5XkQ0UAYUl11Tbm20n4tTng1+1LWgOB5MzdB7r12pIWmXjCSZdz4
         Vx5o27IMtxHf56LfFlPMltaSSUI8XQNwRJ0u0dFx+pxhpnhvTIxf9LKXtSzTre7lBy
         WknQ3cYAbZ4oOHzab8zGHdQaS5OQ5IwyWcFSo7GCWGhivGnAaQoNnAgbdfAvTIricH
         3YPcCUQziVpEPQSuvedL5UQL0pJq7GW21i94nybVQVIB7eqJtRIWZFLoygbdGMWAiG
         8x1ZhW9rj8ZfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1CB3F03935;
        Wed, 18 May 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: remove unused get_addr() callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287881172.21214.7192522722740611844.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:00:11 +0000
References: <20220517081602.1826154-1-vincent.whitchurch@axis.com>
In-Reply-To: <20220517081602.1826154-1-vincent.whitchurch@axis.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        kernel@axis.com, Jose.Abreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 May 2022 10:16:01 +0200 you wrote:
> The last caller of the stmmac_desc_ops::get_addr() callback was removed
> a while ago, so remove the unused callback.
> 
> Note that the callback also only gets half the descriptor address on
> systems with 64-bit descriptor addresses, so that should be fixed if it
> needs to be resurrected later.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: remove unused get_addr() callback
    https://git.kernel.org/netdev/net-next/c/e991d0ed0b7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


