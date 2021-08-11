Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8773E8D40
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhHKJah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234869AbhHKJag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 05:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA94A60FC0;
        Wed, 11 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628674206;
        bh=Q71t9zeV9WHU9ikMo8Oz6jPzM0lU/RWhdR/SEYb6cLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qe0gydgB8uHuUZFVHXsFR8u8NjaPZAiYwDFcwJe2zDeKuqoEJXUsiNNv8oLjIuvUT
         Ps6chmh0PsBC2WTSC1kTv83UA/mpjmVw5zLyO4YbJmPYMHP5LPqlnPeFJfZQi6/p7g
         CN2f/AsfdfrbnDsYJEA3yX5/i7Oh+/1BsyYlCW8imKek2ganqBBVgVfwj3o7pnrMh4
         /1qOlxp/qF9UqW1csXlQaJYXQ++in/3JtSg8IW0NfKd7QYmf1P7k+z2HPyply77Wds
         wJFa/rgFzxZ3MKMBcTJa6Wk0Xd3o+LA0JViSCSAHxvi7B7piwA9oqnKQVVd7s2c2gw
         6z9+jNBPimLhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF02C60A54;
        Wed, 11 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/10] netfilter: nft_compat: use nfnetlink_unicast()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162867420671.26695.6502810493491668850.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 09:30:06 +0000
References: <20210811084908.14744-2-pablo@netfilter.org>
In-Reply-To: <20210811084908.14744-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 10:48:59 +0200 you wrote:
> Use nfnetlink_unicast() which already translates EAGAIN to ENOBUFS,
> since EAGAIN is reserved to report missing module dependencies to the
> nfnetlink core.
> 
> e0241ae6ac59 ("netfilter: use nfnetlink_unicast() forgot to update
> this spot.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] netfilter: nft_compat: use nfnetlink_unicast()
    https://git.kernel.org/netdev/net-next/c/241d1af4c11a
  - [net-next,02/10] netfilter: flowtable: remove nf_ct_l4proto_find() call
    https://git.kernel.org/netdev/net-next/c/92fb15513edc
  - [net-next,03/10] netfilter: ipt_CLUSTERIP: only add arp mangle hook when required
    https://git.kernel.org/netdev/net-next/c/7c1829b6aa74
  - [net-next,04/10] netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
    https://git.kernel.org/netdev/net-next/c/ded2d10e9ad8
  - [net-next,05/10] netfilter: remove xt pernet data
    https://git.kernel.org/netdev/net-next/c/f2e3778db7e1
  - [net-next,06/10] netfilter: ebtables: do not hook tables by default
    https://git.kernel.org/netdev/net-next/c/87663c39f898
  - [net-next,07/10] netfilter: ctnetlink: add and use a helper for mark parsing
    https://git.kernel.org/netdev/net-next/c/ff1199db8c3b
  - [net-next,08/10] netfilter: ctnetlink: allow to filter dump by status bits
    https://git.kernel.org/netdev/net-next/c/9344988d2979
  - [net-next,09/10] netfilter: x_tables: never register tables by default
    https://git.kernel.org/netdev/net-next/c/fdacd57c79b7
  - [net-next,10/10] netfilter: nf_queue: move hookfn registration out of struct net
    https://git.kernel.org/netdev/net-next/c/870299707436

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


