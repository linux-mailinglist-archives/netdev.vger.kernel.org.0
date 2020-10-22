Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1020729652E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370053AbgJVTUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370047AbgJVTUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:20:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603394404;
        bh=8djNLPvWAmclL2ddtNvo78VX2pkl6LPOHC/J3qyxn04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvieYnByl+g/OUBIATbDUxv3Ooh3O8kWTMqwkwMNrwywwcnIqvGLfcFCDoOKCA8EL
         pvww3HY29ZMeVlbyZ0uXgnRQpadAvXyPJYBDAw+vRcFymhCkyE6eXpWOP2sb4l2iPj
         BP9vG+v1HcSwn3LIiBcB6WmNTshuKjHAaOoXMOk8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/7] ipvs: adjust the debug info in function set_tcp_state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160339440440.27493.8723179015537547907.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Oct 2020 19:20:04 +0000
References: <20201022172925.22770-2-pablo@netfilter.org>
In-Reply-To: <20201022172925.22770-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Oct 2020 19:29:19 +0200 you wrote:
> From: "longguang.yue" <bigclouds@163.com>
> 
> Outputting client,virtual,dst addresses info when tcp state changes,
> which makes the connection debug more clear
> 
> Signed-off-by: longguang.yue <bigclouds@163.com>
> Acked-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [1/7] ipvs: adjust the debug info in function set_tcp_state
    https://git.kernel.org/netdev/net/c/79dce09ab027
  - [2/7] netfilter: conntrack: connection timeout after re-register
    https://git.kernel.org/netdev/net/c/4f25434bccc2
  - [3/7] netfilter: Drop fragmented ndisc packets assembled in netfilter
    https://git.kernel.org/netdev/net/c/68f9f9c2c3b6
  - [4/7] netfilter: ebtables: Fixes dropping of small packets in bridge nat
    https://git.kernel.org/netdev/net/c/63137bc5882a
  - [5/7] docs: nf_flowtable: fix typo.
    https://git.kernel.org/netdev/net/c/64747d5ed199
  - [6/7] netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create
    https://git.kernel.org/netdev/net/c/31cc578ae2de
  - [7/7] netfilter: nf_fwd_netdev: clear timestamp in forwarding path
    https://git.kernel.org/netdev/net/c/c77761c8a594

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


