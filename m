Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626A53B109E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFVXcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFVXcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 19:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C09460FE3;
        Tue, 22 Jun 2021 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624404605;
        bh=lA2WwzgrGAw6iaBRu8M8pCGv+FlThK8Xw1nzQ+1CDdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jd/iDRU5dLt+o/OE463u2m+T/GrmseVhwVrA8SaIGcZN9GGfD92M5tGfJSebv00VF
         mv1CDhS1yS5KQ8bbDxA73HBoRwV9BHtUOeQJZAH8ryJ/8N2wZFDX9PQqhQe2OMfzK3
         FzyN7ZC4AKz1v8jH1ZbQPqdzlClSXOWV7KC8VCJzOcxwm7tsRUSZuCpwqNPzm7Sg4l
         owl2Y3/MsgEJp5szOHty1PHGLtG+Vv9ZWJOWSv5DxliD5Iy+TD7ps8FudHorX4Gm3S
         iYedi4MnFtCyXdFA/ZHXJPD1kJsjWqsuWzB8w35Rqp/8OVCQQkS769KqwAO72UZFXE
         C2KMMzZx4c1NA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 312A5609AC;
        Tue, 22 Jun 2021 23:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] MAINTAINERS: netfilter: add irc channel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162440460519.10731.278654645646081651.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 23:30:05 +0000
References: <20210622220001.198508-2-pablo@netfilter.org>
In-Reply-To: <20210622220001.198508-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Jun 2021 23:59:54 +0200 you wrote:
> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> The community #netfilter IRC channel is now live on the libera.chat network
> (https://libera.chat/).
> 
> CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Link: https://marc.info/?l=netfilter&m=162210948632717
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/8] MAINTAINERS: netfilter: add irc channel
    https://git.kernel.org/netdev/net/c/8744365e2584
  - [net,2/8] netfilter: nft_exthdr: check for IPv6 packet before further processing
    https://git.kernel.org/netdev/net/c/cdd73cc545c0
  - [net,3/8] netfilter: nft_osf: check for TCP packet before further processing
    https://git.kernel.org/netdev/net/c/8f518d43f89a
  - [net,4/8] netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
    https://git.kernel.org/netdev/net/c/52f0f4e178c7
  - [net,5/8] netfilter: nf_tables: memleak in hw offload abort path
    https://git.kernel.org/netdev/net/c/3c5e44622011
  - [net,6/8] netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
    https://git.kernel.org/netdev/net/c/ea45fdf82cc9
  - [net,7/8] netfilter: nf_tables: skip netlink portID validation if zero
    https://git.kernel.org/netdev/net/c/534799097a77
  - [net,8/8] netfilter: nf_tables: do not allow to delete table with owner by handle
    https://git.kernel.org/netdev/net/c/e31f072ffab0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


