Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9D49F19D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiA1DAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiA1DAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A48C061714;
        Thu, 27 Jan 2022 19:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFBCBB82441;
        Fri, 28 Jan 2022 03:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82726C340E5;
        Fri, 28 Jan 2022 03:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643338812;
        bh=Jg9Hwyb79qyFvkk1RTbwP4cux8QEkrHRD4hGdyHxtrc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NpB5VG5q69E5WMHJ9eTCNQxmI3PLeYDaIAB+El67p8M3kjcuZXjD6q0JU6w+J0g2y
         A5uP810DBtA0VaTTzHNzcAuB2YPFPd5qc+vrWSOrRc6syytWk2x/DOH8xoMKWFq2oR
         Lj24Nd9pQ5HKsu6EtqiellqAAPUV393jaXyYMmDvUAnjwS+fwwQAhKOrJRJXKhYXro
         Oy6dBHv+HMUHJrxpZbQ7ZZAZiFeaWx5yd8xBlwDhRWyJ37n7oMQf62kC7spAfDGMqj
         wgk5IBgZCsW8cp+VYqoN5pAFM9oBC3SCp5/C4+JL4MuKflvQrVJlHRQHuabt3WvnpK
         9Q/FipEp33iGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A8D4E5D089;
        Fri, 28 Jan 2022 03:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: Remove flowtable relics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164333881243.25446.10078573263507923141.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 03:00:12 +0000
References: <20220127235235.656931-2-pablo@netfilter.org>
In-Reply-To: <20220127235235.656931-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 28 Jan 2022 00:52:28 +0100 you wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> NF_FLOW_TABLE_IPV4 and NF_FLOW_TABLE_IPV6 are invisble, selected by
> nothing (so they can no longer be enabled), and their last real users
> have been removed (nf_flow_table_ipv6.c is empty).
> 
> Clean up the leftovers.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: Remove flowtable relics
    https://git.kernel.org/netdev/net/c/7355bfe0e0cc
  - [net,2/8] netfilter: nft_ct: fix use after free when attaching zone template
    https://git.kernel.org/netdev/net/c/34243b9ec856
  - [net,3/8] selftests: netfilter: reduce zone stress test running time
    https://git.kernel.org/netdev/net/c/c858620d2ae3
  - [net,4/8] selftests: netfilter: check stateless nat udp checksum fixup
    https://git.kernel.org/netdev/net/c/aad51ca71ad8
  - [net,5/8] netfilter: nft_reject_bridge: Fix for missing reply from prerouting
    https://git.kernel.org/netdev/net/c/aeac4554eb54
  - [net,6/8] netfilter: nft_byteorder: track register operations
    https://git.kernel.org/netdev/net/c/f459bfd4b979
  - [net,7/8] selftests: nft_concat_range: add test for reload with no element add/del
    https://git.kernel.org/netdev/net/c/eda0cf1202ac
  - [net,8/8] netfilter: nf_tables: remove assignment with no effect in chain blob builder
    https://git.kernel.org/netdev/net/c/b07f41373254

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


