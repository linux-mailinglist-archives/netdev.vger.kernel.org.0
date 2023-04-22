Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1336EB951
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 15:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDVNU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 09:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDVNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 09:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522561B1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 06:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFF44610D5
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 13:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BEA9C4339C;
        Sat, 22 Apr 2023 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682169620;
        bh=8dTlfJfIPAzyyb6aSdWbBTJpUMrGmwlsH7mStOQB494=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+kOBc59e88QRUd2JBM5QZ0eomIaubnouVisq3iPs4ykV6MLJEeaPdcbIs2g9n8IQ
         z7Y5ZXmo0F7jRgQTRz5kPG25FEAZuUVbZoql8GYpgTN9azywe9kXWPYYceZTaoa2pk
         AocmfIUe6FdzUg3WnCQCSmmCZm+lsijmbrtN+dYWky3nYets/xby3431mvhTRFx16y
         bRMMowEZccXf7Lu04D/fzCMyo/BobCIOKc/Jpi1aGwIQgQkk58ukpIcMMdSglCTf4t
         43atGJ7NCsdkL20oGVeX8KUbAU6L+4sbTiZm3mBmUdzsab+id0w8fHiXcLofycA57U
         O0huv/wvtYSxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A323E270E2;
        Sat, 22 Apr 2023 13:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] ipv4: Fix potential uninit variable access bug in
 __ip_make_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168216962003.26753.1306408405089201442.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 13:20:20 +0000
References: <20230420124035.2061588-1-william.xuanziyang@huawei.com>
In-Reply-To: <20230420124035.2061588-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Apr 2023 20:40:35 +0800 you wrote:
> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
> __ip6_make_skb()"). icmphdr does not in skb linear region under the
> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
> trigger the uninit variable access bug.
> 
> Use a local variable icmp_type to carry the correct value in different
> scenarios.
> 
> [...]

Here is the summary with links:
  - [net,v3] ipv4: Fix potential uninit variable access bug in __ip_make_skb()
    https://git.kernel.org/netdev/net/c/99e5acae193e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


