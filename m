Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5D6F13C1
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbjD1JA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345344AbjD1JAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE122713
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F5164213
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 942C6C433D2;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682672421;
        bh=O6x7YjEjZ6Y0NKpXaBSHwcaKDHVHMtAQBH0DzsN9K9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iej/PaiEgxl5KZopv3ETkA7Z12iKKkfoQ1XPObCtg2ltd/DcJlzk717dqdierM1YK
         9eyYhz8qMx3dw+VLoahZe5HVaWx0kmR8HNRQ+lOQXOsYcsjpARLXidoXWwgAKSGgx5
         ZuVeckT2Y8gwjWB3lqLkUQR3NKfnVkIo39VqsT7IekBauHjQQFsIJYrCubPo717t6V
         rE7GBPOCs7zy/gWap0AuvyrYM5A/nQAsVht2bQncgNfR1GHRPupdF0lDExEzvgW1IN
         AcWcdUYaBcTfsK7LathcTq8dRKdg53d73iuznjsOJcLd3M9IBBGlSl2Xq7Odi+Kd3Z
         VYShtAm7WEVPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71EBBE5FFC5;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipv6: fix skb hash for some RST packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267242145.9185.9427711815694208492.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 09:00:21 +0000
References: <20230427092159.44998-1-atenart@kernel.org>
In-Reply-To: <20230427092159.44998-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Apr 2023 11:21:59 +0200 you wrote:
> The skb hash comes from sk->sk_txhash when using TCP, except for some
> IPv6 RST packets. This is because in tcp_v6_send_reset when not in
> TIME_WAIT the hash is taken from sk->sk_hash, while it should come from
> sk->sk_txhash as those two hashes are not computed the same way.
> 
> Packetdrill script to test the above,
> 
> [...]

Here is the summary with links:
  - [net] net: ipv6: fix skb hash for some RST packets
    https://git.kernel.org/netdev/net/c/dc6456e938e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


