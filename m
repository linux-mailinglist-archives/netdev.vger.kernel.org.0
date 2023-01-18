Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC58671EA5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjARN5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjARN4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:56:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346A936FC0;
        Wed, 18 Jan 2023 05:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6909B81B05;
        Wed, 18 Jan 2023 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F859C433F0;
        Wed, 18 Jan 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674048617;
        bh=3SBwUr9d4alhOnPT2Oqv4ZmfIqzw3v565N0QFVNs6oU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2PJWS+LmA3IvNuLkyVOTv63jm2c3Qvtcawdj7dS8jjDzAicoq2tGlLAfcf4tQ8ul
         ttvyQfeptUV2dla5aQ0zVIJ8CiF5f3jaqzTj1VYBq0s3Vi+vUyzizacjcVQSm6MRhD
         WFrssbZwDpZzD36bzPiNOYSFeALQ5LqKO6ZZjJHq1lUxar0xVdvcOgX6md8ZRyuvmQ
         5CFYAkoosR6ByCaGHwMiX6KbAeNBfFGlEkEiq4Ykc6n5x5TyCC2MoFHiyvMFwMnG5J
         QXVEjZU6ofVXKR6rteiG0CDUtc40rd9PRnjwEBV6kfDQoT+M4VABVEC1ni8AZ/kzex
         Gb2+ByxOq2HsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61DD6C3959E;
        Wed, 18 Jan 2023 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] netfilter: conntrack: sctp: use nf log
 infrastructure for invalid packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404861739.15317.15187589008941476459.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:30:17 +0000
References: <20230118123208.17167-2-fw@strlen.de>
In-Reply-To: <20230118123208.17167-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net,
        netfilter-devel@vger.kernel.org
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
by Florian Westphal <fw@strlen.de>:

On Wed, 18 Jan 2023 13:32:00 +0100 you wrote:
> The conntrack logging facilities include useful info such as in/out
> interface names and packet headers.
> 
> Use those in more places instead of pr_debug calls.
> Furthermore, several pr_debug calls can be removed, they are useless
> on production machines due to the sheer volume of log messages.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] netfilter: conntrack: sctp: use nf log infrastructure for invalid packets
    https://git.kernel.org/netdev/net-next/c/f71cb8f45d09
  - [net-next,2/9] netfilter: conntrack: remove pr_debug calls
    https://git.kernel.org/netdev/net-next/c/50bfbb8957ab
  - [net-next,3/9] netfilter: conntrack: avoid reload of ct->status
    https://git.kernel.org/netdev/net-next/c/4883ec512c17
  - [net-next,4/9] netfilter: conntrack: move rcu read lock to nf_conntrack_find_get
    https://git.kernel.org/netdev/net-next/c/2a2fa2efc65f
  - [net-next,5/9] netfilter: ip_tables: remove clusterip target
    https://git.kernel.org/netdev/net-next/c/9db5d918e2c0
  - [net-next,6/9] netfilter: nf_tables: add static key to skip retpoline workarounds
    https://git.kernel.org/netdev/net-next/c/d8d760627855
  - [net-next,7/9] netfilter: nf_tables: avoid retpoline overhead for objref calls
    https://git.kernel.org/netdev/net-next/c/2032e907d8d4
  - [net-next,8/9] netfilter: nf_tables: avoid retpoline overhead for some ct expression calls
    https://git.kernel.org/netdev/net-next/c/d9e789147605
  - [net-next,9/9] netfilter: nf_tables: add support to destroy operation
    https://git.kernel.org/netdev/net-next/c/f80a612dd77c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


