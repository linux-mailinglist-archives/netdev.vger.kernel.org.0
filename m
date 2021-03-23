Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8E3453E2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhCWAar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhCWAaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 963D8619AE;
        Tue, 23 Mar 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459411;
        bh=Nuq+Tv2awdUTapm6DlH/yNafv2lauJPVNi1X/r/9HDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K3OjFEz2wxBhipEg5vw9jFF3zA+flbfEMWG8XNwgJCS72sn45qWQGtGy4cKb7160h
         x4u81YFYifvktlqhB9BBEDyghNjICxPZflXt2QB1Y9wA1NPrDNM2/kjmsAXA+XZg/k
         COVtEN6zoxrUkt5ZjFfX3pxZT8azlqAPuDaFzkiniL5f6G1gpodrXAZB2chIGQv15L
         DDCypU1jiQg53pXPqCtmFarczSwgXcHFFolVPc+0wRSBP7sCrPZkVuHzYK/MqPoiVY
         us6rgxw/OFieSIBYsadEoICd4IUkQHp2TZxYUMKI1NP8UiDNYGGiNW5LZJRGG1zeoj
         1trbR5UruBUgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9277660A0B;
        Tue, 23 Mar 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/10] netfilter: flowtable: separate replace,
 destroy and stats to different workqueues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645941159.31154.378858008887571926.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 00:30:11 +0000
References: <20210322235628.2204-2-pablo@netfilter.org>
In-Reply-To: <20210322235628.2204-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 00:56:19 +0100 you wrote:
> From: Oz Shlomo <ozsh@nvidia.com>
> 
> Currently the flow table offload replace, destroy and stats work items are
> executed on a single workqueue. As such, DESTROY and STATS commands may
> be backloged after a burst of REPLACE work items. This scenario can bloat
> up memory and may cause active connections to age.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] netfilter: flowtable: separate replace, destroy and stats to different workqueues
    https://git.kernel.org/netdev/net-next/c/2ed37183abb7
  - [net-next,02/10] netfilter: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/c2168e6bd7ec
  - [net-next,03/10] netfilter: conntrack: Remove unused variable declaration
    https://git.kernel.org/netdev/net-next/c/d4a96be65423
  - [net-next,04/10] netfilter: flowtable: consolidate skb_try_make_writable() call
    https://git.kernel.org/netdev/net-next/c/2fc11745c3ff
  - [net-next,05/10] netfilter: flowtable: move skb_try_make_writable() before NAT in IPv4
    https://git.kernel.org/netdev/net-next/c/2babb46c8c82
  - [net-next,06/10] netfilter: flowtable: move FLOW_OFFLOAD_DIR_MAX away from enumeration
    https://git.kernel.org/netdev/net-next/c/4f08f173d08c
  - [net-next,07/10] netfilter: flowtable: fast NAT functions never fail
    https://git.kernel.org/netdev/net-next/c/f4401262b927
  - [net-next,08/10] netfilter: flowtable: call dst_check() to fall back to classic forwarding
    https://git.kernel.org/netdev/net-next/c/e5075c0badaa
  - [net-next,09/10] netfilter: flowtable: refresh timeout after dst and writable checks
    https://git.kernel.org/netdev/net-next/c/1b9cd7690a1e
  - [net-next,10/10] netfilter: nftables: update table flags from the commit phase
    https://git.kernel.org/netdev/net-next/c/0ce7cf4127f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


