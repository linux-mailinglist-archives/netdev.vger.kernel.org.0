Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D3F54221B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiFHEGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 00:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbiFHEFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 00:05:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7924F29B172;
        Tue,  7 Jun 2022 18:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E032B82510;
        Wed,  8 Jun 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC56BC3411F;
        Wed,  8 Jun 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654651212;
        bh=MQRPsAV6Vy1dIdbfnrFfh1xR5VTgXLhHDM9lc6+65nM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUM/9NHs3PspR1eb+AK23FOkMXN8vkMVHatE6n+0OaifW4jVLGbjV4NDce9jHli9z
         p91p9s0jTARbXKofTuhS/sHM47OMREC5rlzT68Ti1H9CAg8J0x6GOE83BtWwJkBms8
         RnB1Qsb54ab4GRisxP35phaGAso62os7PnybNpNlKrvO9Sda6tjk3L5TircvmBNYob
         DjLQ4+sITz4j0MRG8H3BflDW28IqRUoS2NU1ApsbIxZM0ZB/XUjKiWco+XP3DR+GmA
         JPVN1HdwU7b+yMxP+CJPWSeBok4NIoW9J5l8/rnCkNWmU2ySU3E4EhAgOuskvvefIy
         LbyCeH7V9s+/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD220E737F4;
        Wed,  8 Jun 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nat: really support inet nat without l3
 address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165465121270.21593.8118957727937720312.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 01:20:12 +0000
References: <20220606212055.98300-2-pablo@netfilter.org>
In-Reply-To: <20220606212055.98300-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  6 Jun 2022 23:20:49 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> When no l3 address is given, priv->family is set to NFPROTO_INET and
> the evaluation function isn't called.
> 
> Call it too so l4-only rewrite can work.
> Also add a test case for this.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nat: really support inet nat without l3 address
    https://git.kernel.org/netdev/net/c/282e5f8fe907
  - [net,2/7] netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
    https://git.kernel.org/netdev/net/c/ab5e5c062f67
  - [net,3/7] netfilter: nf_tables: delete flowtable hooks via transaction list
    https://git.kernel.org/netdev/net/c/b6d9014a3335
  - [net,4/7] netfilter: nf_tables: always initialize flowtable hook list in transaction
    https://git.kernel.org/netdev/net/c/2c9e4559773c
  - [net,5/7] netfilter: nf_tables: release new hooks on unsupported flowtable flags
    https://git.kernel.org/netdev/net/c/c271cc9febaa
  - [net,6/7] netfilter: nf_tables: memleak flow rule from commit path
    https://git.kernel.org/netdev/net/c/9dd732e0bdf5
  - [net,7/7] netfilter: nf_tables: bail out early if hardware offload is not supported
    https://git.kernel.org/netdev/net/c/3a41c64d9c11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


