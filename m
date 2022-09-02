Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832365AAE2A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbiIBMK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiIBMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEC32CC93
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 05:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B36AB82A86
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2CB2C43143;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662120616;
        bh=OjCxIBT+1k9U6OMUqOSM2sZvL9n1/7i2QeU+2rDtDQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I3dx1sCCP7kOxZiyytak9aFEmf2jgF3u7FJqMwfL3ecsRUN6yhjXyER7W5IW1MGmC
         D4ZazxNVySPQo0W4xe9DoFYB2plGK0Atr6OSJIQsliBbsftFzrbHKTVf8WGTe94HT5
         CePwg4zX7OSvUysg0GmgTBJxfWQNfZy8oKPUbMn7E3UxXveguGW9Wur5/n+3OUt+U3
         KRodlw6LbT3RsGELfQLGu3hX4nzXqpmtXgRb1yopp4NxmpF7ZWvTkSku/wcXW482Zi
         qwyc+aaRJhPxRa5gvD960sIMvmmb17ej6u2Vq2XpAC54iFti6eZEBvGgSg/+fNJuNB
         8pyble+rr9WbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF189E924D5;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove netif_tx_napi_add()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166212061678.16201.15210545924816022886.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 12:10:16 +0000
References: <20220901000058.2585507-1-kuba@kernel.org>
In-Reply-To: <20220901000058.2585507-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 17:00:58 -0700 you wrote:
> All callers are now gone.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/netdevice.h | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: remove netif_tx_napi_add()
    https://git.kernel.org/netdev/net-next/c/c3f760ef1287

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


