Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA759397DB7
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFBAlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhFBAls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 166FA613C1;
        Wed,  2 Jun 2021 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622594406;
        bh=qXbXawDC8sc/qiJMTIVwnFI7+N+jS9KFws81G+M31eU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M+Ju086bFqN705/+ICCJNoCgWmEXI8eQGwFPsr6Kye1Ds8uZFOQEoB6BRIZNzcjie
         wlgidsPBtBNcGTdEwBimFotInhl2nxzAOj4/9e+3JmYtrmXcY4rH68ScYZPOshVxZQ
         z8F7Z77jvAPDLta5FKdSyoFsKFk1gazxeSJ3E645WG4f3Nda0DjZnJqv/IXX/5TQKM
         +bNA6o6DHmMRwDubrw6IUUMG8rZ/aImd5hNr1WDH8922CZ9DRgtJEqTE4gZLmOaAVZ
         +nsyxf3tLjrRD9fcVAD581Vga36vO8wq3aJrAwmiAQYmXkply2abfbWkprgSnIPBiU
         JTlb5RUEcNBiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 083D760A22;
        Wed,  2 Jun 2021 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/16] netfilter: nft_exthdr: Support SCTP chunks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259440602.2786.16553197408865657330.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:40:06 +0000
References: <20210601220629.18307-2-pablo@netfilter.org>
In-Reply-To: <20210601220629.18307-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 00:06:14 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Chunks are SCTP header extensions similar in implementation to IPv6
> extension headers or TCP options. Reusing exthdr expression to find and
> extract field values from them is therefore pretty straightforward.
> 
> For now, this supports extracting data from chunks at a fixed offset
> (and length) only - chunks themselves are an extensible data structure;
> in order to make all fields available, a nested extension search is
> needed.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] netfilter: nft_exthdr: Support SCTP chunks
    https://git.kernel.org/netdev/net-next/c/133dc203d77d
  - [net-next,02/16] netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we don't need a valid MXCSR state
    https://git.kernel.org/netdev/net-next/c/a58db7ad80e8
  - [net-next,03/16] netfilter: add and use nft_set_do_lookup helper
    https://git.kernel.org/netdev/net-next/c/0974cff3eb66
  - [net-next,04/16] netfilter: nf_tables: prefer direct calls for set lookups
    https://git.kernel.org/netdev/net-next/c/f227925e53c3
  - [net-next,05/16] netfilter: Remove leading spaces in Kconfig
    https://git.kernel.org/netdev/net-next/c/06f029930264
  - [net-next,06/16] netfilter: x_tables: improve limit_mt scalability
    https://git.kernel.org/netdev/net-next/c/07df3fc90a03
  - [net-next,07/16] netfilter: xt_CT: Remove redundant assignment to ret
    https://git.kernel.org/netdev/net-next/c/02d85142670b
  - [net-next,08/16] netfilter: use nfnetlink_unicast()
    https://git.kernel.org/netdev/net-next/c/e0241ae6ac59
  - [net-next,09/16] netfilter: x_tables: reduce xt_action_param by 8 byte
    https://git.kernel.org/netdev/net-next/c/586d5a8bcede
  - [net-next,10/16] netfilter: reduce size of nf_hook_state on 32bit platforms
    https://git.kernel.org/netdev/net-next/c/6802db48fc27
  - [net-next,11/16] netfilter: nf_tables: add and use nft_sk helper
    https://git.kernel.org/netdev/net-next/c/85554eb981e5
  - [net-next,12/16] netfilter: nf_tables: add and use nft_thoff helper
    https://git.kernel.org/netdev/net-next/c/2d7b4ace0754
  - [net-next,13/16] netfilter: nf_tables: remove unused arg in nft_set_pktinfo_unspec()
    https://git.kernel.org/netdev/net-next/c/f06ad944b6a9
  - [net-next,14/16] netfilter: nf_tables: remove xt_action_param from nft_pktinfo
    https://git.kernel.org/netdev/net-next/c/897389de4828
  - [net-next,15/16] netfilter: nft_set_pipapo_avx2: fix up description warnings
    https://git.kernel.org/netdev/net-next/c/89258f8e4148
  - [net-next,16/16] netfilter: fix clang-12 fmt string warnings
    https://git.kernel.org/netdev/net-next/c/8a1c08ad19b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


