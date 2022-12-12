Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A8164AB05
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiLLXAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiLLXAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1470FD15;
        Mon, 12 Dec 2022 15:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DC11B80E9D;
        Mon, 12 Dec 2022 23:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D840C433EF;
        Mon, 12 Dec 2022 23:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886021;
        bh=bbN07mpAf6h2Fh6KexGYZJ2412NthMdOvJqbO9hQDeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gxs3es5rpQrdhN1saI7tiRMz8hP/fDJ2u4k/AOuQfAKCPMxQeU1uPQalvQ0xQrYxf
         Cw/QRFvC/k0Pf97RSwlr9dQ8yUamFRiUxX/dNUueLoQ/9+qdKxuGahfx8JyMZDxvM6
         WhC/J3C8pKVWkxbWFjOP38ze+PfaDCH7/b7KwZD2/pDNs5KTkcJu5rzU3FvlneAFmy
         iNbsxEoW94fZ18zcApJeUbxG1jsShEUf7+kqib1rvw8xq8OTogUEP1k6qqLM8CLK8l
         J5tbkuXlgd+eyLkRuoUgXgmu92za8ecPNaQ2jfKNwNXbzUSTNwzKBmR7LzNvZ/A0wF
         R2zL97WYoatYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE3C4C00445;
        Mon, 12 Dec 2022 23:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/12] netfilter: nft_inner: fix IS_ERR() vs NULL
 check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088602097.14719.3291558869117710249.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:00:20 +0000
References: <20221211101204.1751-2-pablo@netfilter.org>
In-Reply-To: <20221211101204.1751-2-pablo@netfilter.org>
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

On Sun, 11 Dec 2022 11:11:53 +0100 you wrote:
> From: Dan Carpenter <error27@gmail.com>
> 
> The __nft_expr_type_get() function returns NULL on error.  It never
> returns error pointers.
> 
> Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] netfilter: nft_inner: fix IS_ERR() vs NULL check
    https://git.kernel.org/netdev/net-next/c/98cbc40e4f7d
  - [net-next,02/12] netfilter: conntrack: add sctp DATA_SENT state
    https://git.kernel.org/netdev/net-next/c/bff3d0534804
  - [net-next,03/12] netfilter: conntrack: merge ipv4+ipv6 confirm functions
    https://git.kernel.org/netdev/net-next/c/a70e483460d5
  - [net-next,04/12] netfilter: ipset: Add support for new bitmask parameter
    https://git.kernel.org/netdev/net-next/c/e93745249505
  - [net-next,05/12] netfilter: conntrack: set icmpv6 redirects as RELATED
    https://git.kernel.org/netdev/net-next/c/7d7cfb48d813
  - [net-next,06/12] netfilter: flowtable: add a 'default' case to flowtable datapath
    https://git.kernel.org/netdev/net-next/c/895fa59647cd
  - [net-next,07/12] ipvs: add rcu protection to stats
    https://git.kernel.org/netdev/net-next/c/5df7d714d8cb
  - [net-next,08/12] ipvs: use common functions for stats allocation
    https://git.kernel.org/netdev/net-next/c/de39afb3d811
  - [net-next,09/12] ipvs: use u64_stats_t for the per-cpu counters
    https://git.kernel.org/netdev/net-next/c/1dbd8d9a82e3
  - [net-next,10/12] ipvs: use kthreads for stats estimation
    https://git.kernel.org/netdev/net-next/c/705dd3444081
  - [net-next,11/12] ipvs: add est_cpulist and est_nice sysctl vars
    https://git.kernel.org/netdev/net-next/c/f0be83d54217
  - [net-next,12/12] ipvs: run_estimation should control the kthread tasks
    https://git.kernel.org/netdev/net-next/c/144361c1949f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


