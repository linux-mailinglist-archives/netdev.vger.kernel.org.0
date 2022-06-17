Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0265654F5FA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382232AbiFQKuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiFQKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB336BFD4;
        Fri, 17 Jun 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 764BFB829CA;
        Fri, 17 Jun 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C205C3411D;
        Fri, 17 Jun 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655463013;
        bh=Dlexy7QWYg/TkIheC/nhYJ/sRfJObWjZgkqajRN2T2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=At0+kFvmwfs5Xo82sMShkmt2pBpM6hmUWL9OYMj883ZNFw1oSuik3g+jHIB920doZ
         BbaJSmeGVveDOsi5BvC8o6KCjSJlzuB3LNQ3J/0IK3yrfDkeIMmukWbOgkTqsGP7r8
         2eUFZ0eCHajYfCnAJmUwU3MZqsWVlAPNMt/NOLxV7m1rih8PTlvkbGwvp65UCXDcN+
         VjiGUv6mCtHsAJGhBSGS5Qa7ynd7LY+CfVDgeIHakkytmPQAnAs9cgfiiq4GjwbQKa
         3/ui7RAIlnYSWxUzT052p08jeHqIKDtI0NxWr6251UsF00pCvgQHg4RlZcJ5zdkU3O
         D9sKCRvn71aeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11499E56ADF;
        Fri, 17 Jun 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: macb: fix negative max_mtu size for
 sama5d3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546301306.24969.17301326997601395011.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:50:13 +0000
References: <20220617071607.3782772-1-o.rempel@pengutronix.de>
In-Reply-To: <20220617071607.3782772-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 09:16:07 +0200 you wrote:
> JML register on probe will return zero . This register is configured
> later on macb_init_hw() which is called on open.
> Since we have zero, after header and FCS length subtraction we will get
> negative max_mtu size. This issue was affecting DSA drivers with MTU support
> (for example KSZ9477).
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: macb: fix negative max_mtu size for sama5d3
    https://git.kernel.org/netdev/net-next/c/46e31db55da8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


