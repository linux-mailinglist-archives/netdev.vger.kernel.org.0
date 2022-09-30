Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFED5F02B5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiI3CVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiI3CVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:21:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E6FEC541
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC320B826FC
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CFD4C43140;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504466;
        bh=xbq5Ix5MEdF0nlFDrKOCcefiVpXxB09cadVrfE6i//8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VxRNZTNxarU3ld3AMCagndJpy7xJNicKga5xCV+OlZytkl/nU09BJeRnT5WloW8ZN
         UdfrZ1ZE2qtcbrJkevCHHwdJ2Wn9vmgxZWPgWFnH2u3N+71dxjPpRFaQzTLvA1pS9U
         lg9+izC9IC1cKtI+vBo+gkc7C9OlW6O6GJumbfLH1Vgum9ii58p5RTsvLQ1qdt/ksy
         01y0krXKt/HpmWrTRJMLssc3Fk00okb2zGO5u9N4wSYfwKApADlqce9OJ82SgOfoFq
         TTblg7glYFtfu86PD6aKWSYfiNEWBKYI+EbDgh0u565hvHrcAwelZxqYNnXitIAz4c
         4qAQVyQDccGpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65FE5E49FA3;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450446641.30186.4808131055717975965.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:21:06 +0000
References: <20220927212306.823862-1-kuba@kernel.org>
In-Reply-To: <20220927212306.823862-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net, pablo@netfilter.org,
        fw@strlen.de, jhs@mojatatu.com, jacob.e.keller@intel.com,
        florent.fourcot@wifirst.fr, gnault@redhat.com,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        liuhangbin@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 14:23:06 -0700 you wrote:
> nlmsg_flags are full of historical baggage, inconsistencies and
> strangeness. Try to document it more thoroughly. Explain the meaning
> of the ECHO flag (and while at it clarify the comment in the uAPI).
> Handwave a little about the NEW request flags and how they make
> sense on the surface but cater to really old paradigm before commands
> were a thing.
> 
> [...]

Here is the summary with links:
  - [net-next] docs: netlink: clarify the historical baggage of Netlink flags
    https://git.kernel.org/netdev/net-next/c/5493a2ad0d20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


