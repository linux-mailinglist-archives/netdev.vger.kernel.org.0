Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088C64C3E26
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiBYGAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiBYGAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:00:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3AC1FE54E;
        Thu, 24 Feb 2022 22:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C70DB82B2D;
        Fri, 25 Feb 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2B7EC340F2;
        Fri, 25 Feb 2022 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645768812;
        bh=INUQnBa4ByNJSY2dB4LhyAy5Am/Vtks8Yp1vfK/0skQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZ2IDEKWV4/7BT9xe8+cCB/fW3BvRpLFZIwRbiED7YhvNcX7G2AEgNEa2XhUU2xdb
         oK45GQ5pBbLHQFk+gmf3L1WYUI275XbCA0GRBmBiKT7j8XwdY/gf6Tb8Sn4HlPA5mo
         h7kqOXGLVlB6x8Kk6BB99digU3Ycvv+lmydy7o/rslOibJVstR9623QGSGhNsVV5U1
         t/+9goFd1rGmbqx3FdaUqZjO0XhWG3zUfkjM9AJyUq5ZKmxQ0XdoWkT8Dz7HEmuaR7
         LkZSZ05tXr7RGkB1rZg9i5Elr58K3kQMxqGfoexfXIz4LMbRVtBnnm1r8nzpIO5nol
         F0ij7Ym04jr5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4300EAC09C;
        Fri, 25 Feb 2022 06:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net/tcp: Merge TCP-MD5 inbound callbacks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576881273.21574.2254886562472065645.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 06:00:12 +0000
References: <20220223175740.452397-1-dima@arista.com>
In-Reply-To: <20220223175740.452397-1-dima@arista.com>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, 0x7f454c46@gmail.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 17:57:40 +0000 you wrote:
> The functions do essentially the same work to verify TCP-MD5 sign.
> Code can be merged into one family-independent function in order to
> reduce copy'n'paste and generated code.
> Later with TCP-AO option added, this will allow to create one function
> that's responsible for segment verification, that will have all the
> different checks for MD5/AO/non-signed packets, which in turn will help
> to see checks for all corner-cases in one function, rather than spread
> around different families and functions.
> 
> [...]

Here is the summary with links:
  - [v3] net/tcp: Merge TCP-MD5 inbound callbacks
    https://git.kernel.org/netdev/net-next/c/7bbb765b7349

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


