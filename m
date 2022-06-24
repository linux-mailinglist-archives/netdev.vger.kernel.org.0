Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8805F55A4EE
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiFXXkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiFXXkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C189D18
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 16:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D1EB82D06
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32EC6C341CA;
        Fri, 24 Jun 2022 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656114014;
        bh=Jq+Z4F9XTKpzmWs4SVl1QfatZi5GytAxjPanmGa/O0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n/DxLGYuhJ4IncBuVLv6XesKOoX+H7JXAyXucIORYND29RrrDUqniU6hau8k8lf1p
         hAC5vQBVKJSkh6DAtrDJmCXpQxhlUcDi8LMl/3Ssmh8aFx+kBSah//Rl4kuK7s9On+
         EaENGmij8Sui2oW5ySoi6t+xNfumXuptditp1OF9Z//WMWRO507/AdmO6LyWH+WY6U
         wK2lz0BvEz70SoMM+Eix3HbRyCIUXJZ31wu6MT5lJg7HDQOrkMnedRFLRBn9TuXfTB
         kvLqsmU11XqzGKcN6tmBBBRXCbcuGUdLjV5Eq/kerUk+5j5XtV096DRqloR9vb+K+9
         s37Uw2oZjGh4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18A97E737F0;
        Fri, 24 Jun 2022 23:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: add a missing nf_reset_ct() in 3WHS handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165611401409.14577.10873781486001471444.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 23:40:14 +0000
References: <20220623050436.1290307-1-edumazet@google.com>
In-Reply-To: <20220623050436.1290307-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, i.maximets@ovn.org,
        fw@strlen.de, pablo@netfilter.org, steffen.klassert@secunet.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 05:04:36 +0000 you wrote:
> When the third packet of 3WHS connection establishment
> contains payload, it is added into socket receive queue
> without the XFRM check and the drop of connection tracking
> context.
> 
> This means that if the data is left unread in the socket
> receive queue, conntrack module can not be unloaded.
> 
> [...]

Here is the summary with links:
  - [net] tcp: add a missing nf_reset_ct() in 3WHS handling
    https://git.kernel.org/netdev/net/c/6f0012e35160

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


