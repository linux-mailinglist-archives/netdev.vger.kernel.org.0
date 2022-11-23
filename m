Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD93634F4E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiKWFAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiKWFAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:00:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32902E1BC4;
        Tue, 22 Nov 2022 21:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A29B8CE2086;
        Wed, 23 Nov 2022 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD42EC433B5;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179619;
        bh=lNBV+Q/UqI+ObkrPapKWMY3xI0x2y1P1LicpjvUQFuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oqy3S/mOw9ybpeUyKinZMEtQ8mKInOzQp7UDq7I3jqEql6n6x6orYV5nlV1SlPgSj
         PV90qtTTAKXH6mc1T7VC6T3Fk8NMWukwP/lmGMTJG0y76FLfxd9O62V15bPHGUZ0Yp
         XQ76hO/zklGYh6uNGrH6MKgnE8mAyVVoBBd5Acl95TL6hExvlbwMbOW8M8Bd+fKruH
         pJxpd3xD4E93BwQK67sEUobCggZl6qIiQrIbKyzuKRZXm0xtfPie2LjRnXBNiGdsHK
         jNsyw2lO9/eKgfLcQy4W3KSBEgRQb5F9EwJi5x0iwn3gW8zLQmQ/q4VpVdr/djDgHZ
         yoYIA+iBw9d9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA50CE4D039;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: Fix error return code in fib_table_insert()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917961969.4515.11876445421485943249.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 05:00:19 +0000
References: <20221120072838.2167047-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221120072838.2167047-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 20 Nov 2022 15:28:38 +0800 you wrote:
> In fib_table_insert(), if the alias was already inserted, but node not
> exist, the error code should be set before return from error handling path.
> 
> Fixes: a6c76c17df02 ("ipv4: Notify route after insertion to the routing table")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/ipv4/fib_trie.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] ipv4: Fix error return code in fib_table_insert()
    https://git.kernel.org/netdev/net/c/568fe84940ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


