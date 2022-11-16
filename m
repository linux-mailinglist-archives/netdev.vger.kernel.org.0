Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6986C62B287
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiKPFAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiKPFA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:00:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4B31FB5;
        Tue, 15 Nov 2022 21:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869A6618F5;
        Wed, 16 Nov 2022 05:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D97ECC433D6;
        Wed, 16 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668574819;
        bh=R5l7PZRrhEj7RzLm0We6a+ujpnlLXjczStLuQY95nS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vdj1CWE3OB/sAsVdEv69V7gQs9qYpgsY7iVaazMchz+r3ZarxI+klaDU5PPsETUr1
         CErlSF1d/nELV3usGXzOGhl1yLWOhdMrP3CdTNF+wil8k+qzgmm9UC4vzhouIbrzW7
         18EIk7np4WOK+ZpF5RjfFoOfUkBZ18U21u6R6k3RKGC2fNdqvnIw8MrGYI+yXqaKvV
         9F2pXBS4EDmLrsqg4mt7ekxxr8d2HMfYgDzUMv6bz0UHuhuRy/vV/cNK0dO1sUXRFp
         zOsTMnlD9lVarARbvLSr/UyNH4j2merFQ1GjaDWgRafrdsuLnryRKXOdTO93T2GFNP
         5529Mo92JL3qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8122E21EFE;
        Wed, 16 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] netfilter: nft_payload: use __be16 to store gre
 version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857481974.8148.14898836218257392922.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 05:00:19 +0000
References: <20221115095922.139954-2-pablo@netfilter.org>
In-Reply-To: <20221115095922.139954-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 15 Nov 2022 10:59:17 +0100 you wrote:
> GRE_VERSION and GRE_VERSION0 are expressed in network byte order,
> use __be16. Uncovered by sparse:
> 
> net/netfilter/nft_payload.c:112:25: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_payload.c:112:25:    expected unsigned int [usertype] version
> net/netfilter/nft_payload.c:112:25:    got restricted __be16
> net/netfilter/nft_payload.c:114:22: warning: restricted __be16 degrades to integer
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] netfilter: nft_payload: use __be16 to store gre version
    https://git.kernel.org/netdev/net-next/c/66394126bf20
  - [net-next,2/6] netfilter: nft_inner: fix return value check in nft_inner_parse_l2l3()
    https://git.kernel.org/netdev/net-next/c/7394c2dd62de
  - [net-next,3/6] netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters
    https://git.kernel.org/netdev/net-next/c/7d34aa3e03b6
  - [net-next,4/6] netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET
    https://git.kernel.org/netdev/net-next/c/8daa8fde3fc3
  - [net-next,5/6] netfilter: rpfilter/fib: clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/971095c6fa4a
  - [net-next,6/6] netfilter: conntrack: use siphash_4u64
    https://git.kernel.org/netdev/net-next/c/d2c806abcf0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


