Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67631348270
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhCXUAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237814AbhCXUAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 16:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B2DD61A26;
        Wed, 24 Mar 2021 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616616013;
        bh=bSkvm8Ve0KphA6K4me8AvjnmQuXSHRfwKYHssvoYzfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fj5jzMU2MyH0n2EYMVzTVGiJ3BdN5hqhUNuDv5qhJjAWkCRImiJLisWQbRkx/kpGn
         cspQjvNa/PJ1ed72gAnFQHqS+5H8WvEtePw7x1O8H+faDvQXX/qq6e3Ax9VLTqFRfw
         AwCfnQqETFlnIhtbzlKbS1hILyC19udf0WWQ6TwkWbuCn9/Vne2aV//XHkZpKVX6vC
         wktpPKDZJO2KlQnWKo9WQwpljrcJMIzL2m2pLUXm95QqRZLXja2dXEBQOjC9MZgZd2
         JtQ8H1yICnTa6Z5+eY1bd1fX7BEV21FCWptLegZpE7j4Xu0W8Tvg4azrWSVK/thMsq
         nsPYPDXUaQ6sQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2901C60A3E;
        Wed, 24 Mar 2021 20:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2 00/24] netfilter: flowtable enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161661601316.29307.18315396957441017075.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 20:00:13 +0000
References: <20210324013055.5619-1-pablo@netfilter.org>
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 02:30:31 +0100 you wrote:
> Hi,
> 
> [ This is v2 that includes documentation enhancements, including
>   existing limitations. This is a rebase on top on net-next. ]
> 
> The following patchset augments the Netfilter flowtable fastpath to
> support for network topologies that combine IP forwarding, bridge,
> classic VLAN devices, bridge VLAN filtering, DSA and PPPoE. This
> includes support for the flowtable software and hardware datapaths.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/24] net: resolve forwarding path from virtual netdevice and HW destination address
    https://git.kernel.org/netdev/net-next/c/ddb94eafab8b
  - [net-next,v2,02/24] net: 8021q: resolve forwarding path for vlan devices
    https://git.kernel.org/netdev/net-next/c/e4417d6950b0
  - [net-next,v2,03/24] net: bridge: resolve forwarding path for bridge devices
    https://git.kernel.org/netdev/net-next/c/ec9d16bab615
  - [net-next,v2,04/24] net: bridge: resolve forwarding path for VLAN tag actions in bridge devices
    https://git.kernel.org/netdev/net-next/c/bcf2766b1377
  - [net-next,v2,05/24] net: ppp: resolve forwarding path for bridge pppoe devices
    https://git.kernel.org/netdev/net-next/c/f6efc675c9dd
  - [net-next,v2,06/24] net: dsa: resolve forwarding path for dsa slave ports
    https://git.kernel.org/netdev/net-next/c/0994d492a1b7
  - [net-next,v2,07/24] netfilter: flowtable: add xmit path types
    https://git.kernel.org/netdev/net-next/c/5139c0c00725
  - [net-next,v2,08/24] netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
    https://git.kernel.org/netdev/net-next/c/c63a7cc4d795
  - [net-next,v2,09/24] netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
    https://git.kernel.org/netdev/net-next/c/7a27f6ab4135
  - [net-next,v2,10/24] netfilter: flowtable: add vlan support
    https://git.kernel.org/netdev/net-next/c/4cd91f7c290f
  - [net-next,v2,11/24] netfilter: flowtable: add bridge vlan filtering support
    https://git.kernel.org/netdev/net-next/c/e990cef6516d
  - [net-next,v2,12/24] netfilter: flowtable: add pppoe support
    https://git.kernel.org/netdev/net-next/c/72efd585f714
  - [net-next,v2,13/24] netfilter: flowtable: add dsa support
    https://git.kernel.org/netdev/net-next/c/a11e7973cf91
  - [net-next,v2,14/24] selftests: netfilter: flowtable bridge and vlan support
    https://git.kernel.org/netdev/net-next/c/79d4071ea4c4
  - [net-next,v2,15/24] netfilter: flowtable: add offload support for xmit path types
    https://git.kernel.org/netdev/net-next/c/eeff3000f240
  - [net-next,v2,16/24] netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled
    https://git.kernel.org/netdev/net-next/c/73f97025a972
  - [net-next,v2,17/24] netfilter: flowtable: bridge vlan hardware offload and switchdev
    https://git.kernel.org/netdev/net-next/c/26267bf9bb57
  - [net-next,v2,18/24] net: flow_offload: add FLOW_ACTION_PPPOE_PUSH
    https://git.kernel.org/netdev/net-next/c/563ae557dd4e
  - [net-next,v2,19/24] netfilter: flowtable: support for FLOW_ACTION_PPPOE_PUSH
    https://git.kernel.org/netdev/net-next/c/17e52c0aaad7
  - [net-next,v2,20/24] dsa: slave: add support for TC_SETUP_FT
    https://git.kernel.org/netdev/net-next/c/3fb24a43c975
  - [net-next,v2,21/24] net: ethernet: mtk_eth_soc: fix parsing packets in GDM
    https://git.kernel.org/netdev/net-next/c/d5c53da2b4a5
  - [net-next,v2,22/24] net: ethernet: mtk_eth_soc: add support for initializing the PPE
    https://git.kernel.org/netdev/net-next/c/ba37b7caf1ed
  - [net-next,v2,23/24] net: ethernet: mtk_eth_soc: add flow offloading support
    https://git.kernel.org/netdev/net-next/c/502e84e2382d
  - [net-next,v2,24/24] docs: nf_flowtable: update documentation with enhancements
    https://git.kernel.org/netdev/net-next/c/143490cde566

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


