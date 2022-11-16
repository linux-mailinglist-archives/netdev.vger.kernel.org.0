Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5D762B718
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiKPKAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKPKAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7D4C25
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3274B61B89
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91728C433D7;
        Wed, 16 Nov 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668592816;
        bh=fudrNaUjfPlFa7/mNGejoo76o/yFFO+9U+E+rmTxyOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EiLnwHN0DIiHy4o2FQ7zbBiN6+hrN8DVSiftJvwNCoNuLrpaKtpPRfUTo7o8R7SqW
         /rK0kMgwWPOpPD2aqKEfRKr1tsV5A2gdTtdZUiiilVHm2NxrQ2tgzZjBHdvut/esoX
         z6Awi6aYHbhAFAgcOEkP6vjTDIMu/u/DaQf57USrK3DruHj0OehVPyA/q7DO/xvLo7
         v+3XFzl8iSUWq6+hdk7H2xHQCtUMwSgDkLHA6gUu/sOss3swkHkGn7b5HKzmpHT9pX
         yxHz53nWzbvOf26hbK3XFu54BQcDb1HxfHc9yToIa2Av1UamsqSOyELP5kxUxxf0d+
         pX4T9ndvi0HvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B149C395F6;
        Wed, 16 Nov 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/5] udp: Introduce optional per-netns hash table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166859281650.28317.12657445251712223826.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 10:00:16 +0000
References: <20221114215757.37455-1-kuniyu@amazon.com>
In-Reply-To: <20221114215757.37455-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Nov 2022 13:57:52 -0800 you wrote:
> This series is the UDP version of the per-netns ehash series [0],
> which were initially in the same patch set. [1]
> 
> The notable difference with TCP is the max table size is 64K and the min
> size is 128.  This is because the possible hash range by udp_hashfn()
> always fits in 64K within the same netns and because we want to keep a
> bitmap in udp_lib_get_port() on the stack.  Also, the UDP per-netns table
> isolates both 1-tuple and 2-tuple tables.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/5] udp: Clean up some functions.
    https://git.kernel.org/netdev/net-next/c/919dfa0b20ae
  - [v4,net-next,2/5] udp: Set NULL to sk->sk_prot->h.udp_table.
    https://git.kernel.org/netdev/net-next/c/67fb43308f4b
  - [v4,net-next,3/5] udp: Set NULL to udp_seq_afinfo.udp_table.
    https://git.kernel.org/netdev/net-next/c/478aee5d6bf6
  - [v4,net-next,4/5] udp: Access &udp_table via net.
    https://git.kernel.org/netdev/net-next/c/ba6aac151677
  - [v4,net-next,5/5] udp: Introduce optional per-netns hash table.
    https://git.kernel.org/netdev/net-next/c/9804985bf27f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


