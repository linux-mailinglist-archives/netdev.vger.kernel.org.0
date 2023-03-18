Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7457A6BFA0B
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCRMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 08:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B6939BBF
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15B760DEA
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 12:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C469C4339B;
        Sat, 18 Mar 2023 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679142620;
        bh=qOHtfX9AAU/l2E5CIiuFw/lnyyohKqpQGZFG2ekSwWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kMHBNvGaC4GZugckQXeM2rbe9pT5Ha8AHzGdHmyhqWFQbQ+nmvLaVTrazGIgZcy7T
         pRX62s5haZvy05jGCr9xV0+Vq1tmw1zg8cr8LzFSolg8RGICBCY+mlD6sHsv2KZBTS
         yCnBUbn7jS2CqZX3BNgB1NDjyox7VxLKmmymVpyNnUCXh5w00g1ifQVDUujiFrcBzQ
         8EbA53541RdLF6MFW+qaduxqMyR/aRPhju4qSTC86mP07uApzbLWO7WGnG/q4ALH3J
         DWKW8gx/VGGv6F5SVMqAWp7YSQDYCD4zEmbICsd0X2PKQCf5eKTvB31Bepe/DROiLl
         /4Lqv1xGQAm+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30EE5E21EE6;
        Sat, 18 Mar 2023 12:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: better const qualifier awareness
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167914262019.17217.8034633587099302733.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 12:30:20 +0000
References: <20230317155539.2552954-1-edumazet@google.com>
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dsahern@kernel.org,
        simon.horman@corigine.com, willemb@google.com,
        matthieu.baerts@tessares.net, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 15:55:29 +0000 you wrote:
> This is a follow-up of d27d367d3b78 ("inet: better const qualifier awareness")
> 
> Adopting container_of_const() to perform (struct sock *)->(protocol sock *)
> operation is allowing us to propagate const qualifier and thus detect
> misuses at compile time.
> 
> Most conversions are trivial, because most protocols did not adopt yet
> const sk pointers where it could make sense.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] udp: preserve const qualifier in udp_sk()
    https://git.kernel.org/netdev/net-next/c/94c540fbfc80
  - [net-next,02/10] af_packet: preserve const qualifier in pkt_sk()
    https://git.kernel.org/netdev/net-next/c/68ac9a8b6e65
  - [net-next,03/10] raw: preserve const qualifier in raw_sk()
    https://git.kernel.org/netdev/net-next/c/0a2db4630b72
  - [net-next,04/10] ipv6: raw: preserve const qualifier in raw6_sk()
    https://git.kernel.org/netdev/net-next/c/47fcae28b9ec
  - [net-next,05/10] dccp: preserve const qualifier in dccp_sk()
    https://git.kernel.org/netdev/net-next/c/ae6084b73992
  - [net-next,06/10] af_unix: preserve const qualifier in unix_sk()
    https://git.kernel.org/netdev/net-next/c/b064ba9c3cfa
  - [net-next,07/10] smc: preserve const qualifier in smc_sk()
    https://git.kernel.org/netdev/net-next/c/407db475d505
  - [net-next,08/10] x25: preserve const qualifier in [a]x25_sk()
    https://git.kernel.org/netdev/net-next/c/c7154ca8e075
  - [net-next,09/10] mptcp: preserve const qualifier in mptcp_sk()
    https://git.kernel.org/netdev/net-next/c/403a40f2304d
  - [net-next,10/10] tcp: preserve const qualifier in tcp_sk()
    https://git.kernel.org/netdev/net-next/c/e9d9da91548b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


