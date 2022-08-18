Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA9597DC6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbiHRFAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiHRFAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF5893521;
        Wed, 17 Aug 2022 22:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28360B81FC7;
        Thu, 18 Aug 2022 05:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5C46C433D6;
        Thu, 18 Aug 2022 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660798817;
        bh=ZkCiJD8d64W4BrQyucUgzkoAUyBXdh3zCp0YdfFpLsI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mtUoiOciYpJMR34qH+V3MZ0jcsGLvtw39KciOKZMbpjnn2Vna7sqyTNkmO5sitcje
         Ka7DiuSgk1nf71TgDOVRcya/jbrcqheqJAhem7HTDO953iQf3gBSdwhq7+O5hryPob
         vuGyDoaR2thN7KIC0QfLR04dT26Nk2ce5wtGI2VPuk8fSjZWx7LOWo8+umZ0v9elJh
         8KusaHconsOja+d4ZwiplJagoXPp7RDfyAIGyy0A7wxpW3w69JYv/mnvsvPzqLSFFh
         r39WVwnNEHlb4C7oz5hSv/r4HuCr3DqFaFOr7aTemo8eiPdTYUJ81dtOx5yTEjNsxU
         jVmEn4A16fcbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8833C4166F;
        Thu, 18 Aug 2022 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/17] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE
 for shared generation id access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166079881768.30070.17888086152925379966.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:00:17 +0000
References: <20220817140015.25843-2-fw@strlen.de>
In-Reply-To: <20220817140015.25843-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
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

This series was applied to netdev/net.git (master)
by Florian Westphal <fw@strlen.de>:

On Wed, 17 Aug 2022 15:59:59 +0200 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> The generation ID is bumped from the commit path while holding the
> mutex, however, netlink dump operations rely on RCU.
> 
> This patch also adds missing cb->base_eq initialization in
> nf_tables_dump_set().
> 
> [...]

Here is the summary with links:
  - [net,01/17] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
    https://git.kernel.org/netdev/net/c/340027832828
  - [net,02/17] netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
    https://git.kernel.org/netdev/net/c/4963674c2e71
  - [net,03/17] netfilter: nf_tables: possible module reference underflow in error path
    https://git.kernel.org/netdev/net/c/c485c35ff678
  - [net,04/17] netfilter: nf_ct_sane: remove pseudo skb linearization
    https://git.kernel.org/netdev/net/c/a664375da76c
  - [net,05/17] netfilter: nf_ct_h323: cap packet size at 64k
    https://git.kernel.org/netdev/net/c/f3e124c36f70
  - [net,06/17] netfilter: nf_ct_ftp: prefer skb_linearize
    https://git.kernel.org/netdev/net/c/c783a29c7e59
  - [net,07/17] netfilter: nf_ct_irc: cap packet search space to 4k
    https://git.kernel.org/netdev/net/c/976bf59c69cd
  - [net,08/17] netfilter: nf_tables: fix scheduling-while-atomic splat
    https://git.kernel.org/netdev/net/c/2024439bd5ce
  - [net,09/17] netfilter: nfnetlink: re-enable conntrack expectation events
    https://git.kernel.org/netdev/net/c/0b2f3212b551
  - [net,10/17] netfilter: nf_tables: really skip inactive sets when allocating name
    https://git.kernel.org/netdev/net/c/271c5ca826e0
  - [net,11/17] netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
    https://git.kernel.org/netdev/net/c/5a2f3dc31811
  - [net,12/17] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
    https://git.kernel.org/netdev/net/c/88cccd908d51
  - [net,13/17] netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
    https://git.kernel.org/netdev/net/c/fc0ae524b5fd
  - [net,14/17] netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified
    https://git.kernel.org/netdev/net/c/1b6345d4160e
  - [net,15/17] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
    https://git.kernel.org/netdev/net/c/aa5762c34213
  - [net,16/17] testing: selftests: nft_flowtable.sh: use random netns names
    https://git.kernel.org/netdev/net/c/b71b7bfeac38
  - [net,17/17] testing: selftests: nft_flowtable.sh: rework test to detect offload failure
    https://git.kernel.org/netdev/net/c/c8550b9077d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


