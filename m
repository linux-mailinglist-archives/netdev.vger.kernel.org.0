Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0655425C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356838AbiFVFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356814AbiFVFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098EC36681;
        Tue, 21 Jun 2022 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99FC96199C;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAE40C385A2;
        Wed, 22 Jun 2022 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655877014;
        bh=MqaBSNTc3zwx8gKXuGgLpLSlbrTMWQrPXXz8GmiAluI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lka5OlIubbDJJqJREMvLPAv9I1fae0j3QVJ09hd0P16mt56JJcqjKZGjOQn1cq5Tv
         ewUGa2CwIF4wMXgiKKsKEmgvIAF5IbRSXZKuQxwbtmaagBxWD+iTzO75ktEbr6X8bA
         6CIHR102S0HszGPDW/anh1RtTpCu5WEy84OiY9x41nihiGlCbDjDSFgn9mXgIjTajQ
         qrPihFb4vTpwPFXVtZ3lApOM4f8FGl/QwM421M0Eb4S20LlJMzqy/EOFQJRxOYJaax
         RGxMYHX+W6OkCHjH+3Hbe3YU+7+jr3yLXLSBY5HdT9G6OP0aoLYocWpYP6Q9KZzBts
         B6oZ8soqbfn4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB677E7387A;
        Wed, 22 Jun 2022 05:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: use get_random_u32 instead of prandom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165587701382.11274.3895245039357932069.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 05:50:13 +0000
References: <20220621085618.3975-2-pablo@netfilter.org>
In-Reply-To: <20220621085618.3975-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 21 Jun 2022 10:56:14 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> bh might occur while updating per-cpu rnd_state from user context,
> ie. local_out path.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
> caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
> Call Trace:
>  check_preemption_disabled+0xde/0xe0
>  nft_ng_random_eval+0x24/0x54 [nft_numgen]
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: use get_random_u32 instead of prandom
    https://git.kernel.org/netdev/net/c/b1fd94e70457
  - [net,2/5] netfilter: cttimeout: fix slab-out-of-bounds read typo in cttimeout_net_exit
    https://git.kernel.org/netdev/net/c/394e771684f7
  - [net,3/5] selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh
    https://git.kernel.org/netdev/net/c/5d79d8af8dec
  - [net,4/5] netfilter: nf_dup_netdev: do not push mac header a second time
    https://git.kernel.org/netdev/net/c/574a5b85dc3b
  - [net,5/5] netfilter: nf_dup_netdev: add and use recursion counter
    https://git.kernel.org/netdev/net/c/fcd53c51d037

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


