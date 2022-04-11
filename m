Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3B4FBA18
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344111AbiDKKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345770AbiDKKwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:52:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC492D1E1;
        Mon, 11 Apr 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410EEB81212;
        Mon, 11 Apr 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF89DC385A5;
        Mon, 11 Apr 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649674213;
        bh=gvoDnNjt59lyMEFbcbbSBDVF+ULbWSxzf4WNS/4KSRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eyMsIFdtYgazy+FMJ8SM385+azMXD46X9t3lbk/FHeuFNRRgD/23EaUB/eAe1Sj2A
         RcPwNWMzh80TueG7m8pXmTaVPtYrOsZMVEeRoOb1fJCnDyqpdHCawTCHsOYxcCKLRD
         xzmhqezLNwuJ/D1fna2/ehicdWg/VKmju7d5tOlkK4I1+ku4j5dQ/QTm6URLXyHwKz
         Idq6oORa17H9OkuYsW6iVjD3ohd0PRAoPRLOvJ9xMPk2AK/GOqQ/gTw8i/kLf+b92/
         3rXfoM/bBESSw8DdEgu+VmKtMnUNIZBugWDH1AbGQSJAgjFAfdNN1K0Mb9PFutyUsX
         x2PHSI1lBpa0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C36CAE85B76;
        Mon, 11 Apr 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] netfilter: nf_tables: replace unnecessary use
 of list_for_each_entry_continue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967421379.15720.10656114207505475482.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 10:50:13 +0000
References: <20220411102744.282101-2-pablo@netfilter.org>
In-Reply-To: <20220411102744.282101-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 11 Apr 2022 12:27:34 +0200 you wrote:
> From: Jakob Koschel <jakobkoschel@gmail.com>
> 
> Since there is no way for list_for_each_entry_continue() to start
> interating in the middle of the list they can be replaced with a call
> to list_for_each_entry().
> 
> In preparation to limit the scope of the list iterator to the list
> traversal loop, the list iterator variable 'rule' should not be used
> past the loop.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()
    https://git.kernel.org/netdev/net-next/c/10377d42281e
  - [net-next,02/11] netfilter: ecache: move to separate structure
    https://git.kernel.org/netdev/net-next/c/9027ce0b071a
  - [net-next,03/11] netfilter: conntrack: split inner loop of list dumping to own function
    https://git.kernel.org/netdev/net-next/c/49001a2e83a8
  - [net-next,04/11] netfilter: cttimeout: inc/dec module refcount per object, not per use refcount
    https://git.kernel.org/netdev/net-next/c/523895e5b278
  - [net-next,05/11] netfilter: nf_log_syslog: Merge MAC header dumpers
    https://git.kernel.org/netdev/net-next/c/39ab798fc14d
  - [net-next,06/11] netfilter: nf_log_syslog: Don't ignore unknown protocols
    https://git.kernel.org/netdev/net-next/c/0c8783806f63
  - [net-next,07/11] netfilter: nf_log_syslog: Consolidate entry checks
    https://git.kernel.org/netdev/net-next/c/c3e348666713
  - [net-next,08/11] netfilter: bitwise: replace hard-coded size with `sizeof` expression
    https://git.kernel.org/netdev/net-next/c/c70b921fc1e8
  - [net-next,09/11] netfilter: bitwise: improve error goto labels
    https://git.kernel.org/netdev/net-next/c/00bd435208e5
  - [net-next,10/11] netfilter: nft_fib: reverse path filter for policy-based routing on iif
    https://git.kernel.org/netdev/net-next/c/be8be04e5ddb
  - [net-next,11/11] selftests: netfilter: add fib expression forward test case
    https://git.kernel.org/netdev/net-next/c/0c7b27616fbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


