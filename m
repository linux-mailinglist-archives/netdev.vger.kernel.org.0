Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566CC6595C9
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiL3Hkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiL3HkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F352BD9
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44AD161A77
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CF51C43398;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386018;
        bh=6WcpNZjoDjKnbeIkVi3wdhK8cCRk+D6CWwbyUawN8aE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GIKANFAMkFnt2MEbb8KMuV4eF4STuZgXgK9NoawBmaiazL1abkVWCdP6F6VWVHkXG
         N2ynZSn1SSqKO9u0EFgIcO9CFUEtOF9cCqhCxYxrMNR//NRfLmkDdIXGYXR6kgR+Km
         T+YMxQxzicBa7donj6MYARpdl6YAvShCYOkUpiU/R+UDhpDWMmr/oquubOu7CdiOzZ
         3nJxWWeYpcmsxevfuXgRdIrDyAwWv3toNhJXauDGOwN51hRQV1fTsonupflIXCYtPk
         ne+1Q55y3Ivduy0m1DIEiooXLs3YW1ThLkQ5/Yfc0MWprBzQRGq+lzCJy1JXkPTPIj
         ieEF2vwaeuEAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76C9AFE0852;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/2] tcp: Fix bhash2 and TIME_WAIT regression.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238601848.1408.15942247005331864831.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:40:18 +0000
References: <20221226132753.44175-1-kuniyu@amazon.com>
In-Reply-To: <20221226132753.44175-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jirislaby@kernel.org, joannelkoong@gmail.com,
        kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Dec 2022 22:27:51 +0900 you wrote:
> We forgot to add twsk to bhash2.  Therefore TIME_WAIT sockets cannot
> prevent bind() to the same local address and port.
> 
> 
> Changes:
>   v1:
>     * Patch 1:
>       * Add tw_bind2_node in inet_timewait_sock instead of
>         moving sk_bind2_node from struct sock to struct
> 	sock_common.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/2] tcp: Add TIME_WAIT sockets in bhash2.
    https://git.kernel.org/netdev/net/c/936a192f9740
  - [v1,net,2/2] tcp: Add selftest for bind() and TIME_WAIT.
    https://git.kernel.org/netdev/net/c/2c042e8e54ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


