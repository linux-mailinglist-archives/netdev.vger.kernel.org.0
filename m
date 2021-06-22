Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8226F3B0B8F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhFVRmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVRmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BE84C61075;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383604;
        bh=tpBsfDkY3E53/AFW1edCU49Ah6d6X+jlnI5Iz1WttEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dbs02EHUhBOPbVlKOjy6LlONjoKtVwopTibFBlwgd6XbeAGmCQnDCTV8MdHB/vdli
         8ceuAHEkDWsrhnaU+o37ObWJ1tVidV67gUJrP33OWc+G2d9CwYLDPceTiVNAYsFbU7
         O7wuDxRrPWNzwsx9RE8HfMvVqu7tiIlQ6Eb2Rlq0Of6Bf9xC2j1WcSBaShIuFbpXZ7
         U54JC3YIo9MMqdDbyC+hckPliNxZFJGPagcWn9rc03oCotKbaPqjVNNEIYiZWtaRqt
         p+IpG0hQbaiv/ndpAK0AiJfoKjOusa+bWAI59EWzwC0aXmK2EXB/ZPtm4EZJ4dtxHQ
         tzRBlczuFE0ag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B2F53609FF;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438360472.26881.13515544903857687352.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:40:04 +0000
References: <20210622015254.1967716-1-kuba@kernel.org>
In-Reply-To: <20210622015254.1967716-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, vfedorenko@novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Jun 2021 18:52:54 -0700 you wrote:
> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
> its callee ip6_tnl_xmit(). The latter is also used by GRE.
> 
> Since commit 38720352412a ("gre: Use inner_proto to obtain inner
> header protocol") GRE had been depending on skb->inner_protocol
> during segmentation. It sets it in gre_build_header() and reads
> it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
> the protocol, resulting in GSO skbs getting dropped.
> 
> [...]

Here is the summary with links:
  - [net] ip6_tunnel: fix GRE6 segmentation
    https://git.kernel.org/netdev/net/c/a6e3f2985a80

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


