Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA2B6370EE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiKXDUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKXDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF96CE9D3;
        Wed, 23 Nov 2022 19:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A357B826A2;
        Thu, 24 Nov 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F601C433D6;
        Thu, 24 Nov 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669260016;
        bh=s1bGrAA2vabfYIAZtnMn+igQA13fKZc8BZyXOowaNGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oi8gHLShWrnevPSd3OGAT3LFqfr6BkNwr+ZYmQsPGylk+IF9qU5ixhIwXMiV0xtf7
         Jdix5b2RjHjJGEpBhk26nYgZvBKkSnrIBJUVLBlAERGRTrK9c8nL3gxPXLh+Cv95y6
         SlKJrsEaKg9o3m+RUka4skljlihA0GrTxUIgwQUn3tTnSBfse8zwGJur6uqo3ts2S+
         cAfwLa5Dk+0OBSz8Mh6K6bolB1q29tw/FAGAJ1oQUI3y6+FakYok1j2fF3KS6sE/1h
         o0l+2dlFl+Ndo70V/aGkxkzwB2k/z/HNg1vhu2bDsddp2nXGTlMFvCSFgkO4hWLVxR
         Cvhe4TAmil9OQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39D11E21EFD;
        Thu, 24 Nov 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: ipset: regression in ip_set_hash_ip.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926001623.25602.5385380497642350937.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 03:20:16 +0000
References: <20221122212814.63177-2-pablo@netfilter.org>
In-Reply-To: <20221122212814.63177-2-pablo@netfilter.org>
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 22 Nov 2022 22:28:12 +0100 you wrote:
> From: Vishwanath Pai <vpai@akamai.com>
> 
> This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
> ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
> 
> The variable e.ip is passed to adtfn() function which finally adds the
> ip address to the set. The patch above refactored the for loop and moved
> e.ip = htonl(ip) to the end of the for loop.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: ipset: regression in ip_set_hash_ip.c
    https://git.kernel.org/netdev/net/c/c7aa1a76d4a0
  - [net,2/3] netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface
    https://git.kernel.org/netdev/net/c/6a66ce44a51b
  - [net,3/3] netfilter: flowtable_offload: add missing locking
    https://git.kernel.org/netdev/net/c/bcd9e3c1656d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


