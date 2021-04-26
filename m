Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66B736BA59
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbhDZTzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 15:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242195AbhDZTy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 15:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 147546135A;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619466827;
        bh=F3RgFvOUJHKHTzDMYyeJTcptA2DL8BX3f6IpXBUKxq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G2Ae/wc4/Mso0egYKHofVBgIY0/tDBEVfoP6zhha/9sOYDGbxxNeZ2Jzzmk3gFZJF
         uqOlTcQrrVezpFApnsQyjs26v6MIq11B8BSMZxZUFwGXLVUtrY4PbSTEfFhmiRVpnX
         ItxNp3iwcsNZSdtSVMcCvBorkbRIOHVwqChi3j6aZMNJkJZaWpn7mH0VJFFRrSaE51
         iAwUNZyDHuq8ZYNY9+AesHTTXZm2nsTpqisKJIbZZaE4CKUTqMkinelV55BuVDrm1X
         1wRKcK86NPLzL2wcjLHPaQXmjVJ5dESQQoOOR7ie0XT7P5o8MGsgY1Lyr3Us49Qmrb
         Gfh7U31+wGvvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02B7D609AE;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/22] netfilter: nat: move nf_xfrm_me_harder to
 where it is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946682700.17823.11285671326765671130.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 19:53:47 +0000
References: <20210426171056.345271-2-pablo@netfilter.org>
In-Reply-To: <20210426171056.345271-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 19:10:35 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> remove the export and make it static.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,01/22] netfilter: nat: move nf_xfrm_me_harder to where it is used
    https://git.kernel.org/netdev/net-next/c/885e8c68247c
  - [net-next,02/22] netfilter: nft_socket: add support for cgroupsv2
    https://git.kernel.org/netdev/net-next/c/e0bb96db96f8
  - [net-next,03/22] netfilter: disable defrag once its no longer needed
    https://git.kernel.org/netdev/net-next/c/de8c12110a13
  - [net-next,04/22] netfilter: ebtables: remove the 3 ebtables pointers from struct net
    https://git.kernel.org/netdev/net-next/c/4c95e0728eee
  - [net-next,05/22] netfilter: x_tables: remove ipt_unregister_table
    https://git.kernel.org/netdev/net-next/c/7716bf090e97
  - [net-next,06/22] netfilter: x_tables: add xt_find_table
    https://git.kernel.org/netdev/net-next/c/1ef4d6d1af2d
  - [net-next,07/22] netfilter: iptables: unregister the tables by name
    https://git.kernel.org/netdev/net-next/c/20a9df33594f
  - [net-next,08/22] netfilter: ip6tables: unregister the tables by name
    https://git.kernel.org/netdev/net-next/c/6c0717545f2c
  - [net-next,09/22] netfilter: arptables: unregister the tables by name
    https://git.kernel.org/netdev/net-next/c/4d705399191c
  - [net-next,10/22] netfilter: x_tables: remove paranoia tests
    https://git.kernel.org/netdev/net-next/c/f68772ed6783
  - [net-next,11/22] netfilter: xt_nat: pass table to hookfn
    https://git.kernel.org/netdev/net-next/c/a4aeafa28cf7
  - [net-next,12/22] netfilter: ip_tables: pass table pointer via nf_hook_ops
    https://git.kernel.org/netdev/net-next/c/ae689334225f
  - [net-next,13/22] netfilter: arp_tables: pass table pointer via nf_hook_ops
    https://git.kernel.org/netdev/net-next/c/f9006acc8dfe
  - [net-next,14/22] netfilter: ip6_tables: pass table pointer via nf_hook_ops
    https://git.kernel.org/netdev/net-next/c/ee177a54413a
  - [net-next,15/22] netfilter: remove all xt_table anchors from struct net
    https://git.kernel.org/netdev/net-next/c/f7163c4882e8
  - [net-next,16/22] netfilter: nf_log_syslog: Unset bridge logger in pernet exit
    https://git.kernel.org/netdev/net-next/c/593268ddf388
  - [net-next,17/22] netfilter: nftables: add nft_pernet() helper function
    https://git.kernel.org/netdev/net-next/c/d59d2f82f984
  - [net-next,18/22] netfilter: nfnetlink: add struct nfnl_info and pass it to callbacks
    https://git.kernel.org/netdev/net-next/c/a65553657174
  - [net-next,19/22] netfilter: nfnetlink: pass struct nfnl_info to rcu callbacks
    https://git.kernel.org/netdev/net-next/c/797d49805ddc
  - [net-next,20/22] netfilter: nfnetlink: pass struct nfnl_info to batch callbacks
    https://git.kernel.org/netdev/net-next/c/7dab8ee3b6e7
  - [net-next,21/22] netfilter: nfnetlink: consolidate callback types
    https://git.kernel.org/netdev/net-next/c/50f2db9e368f
  - [net-next,22/22] netfilter: allow to turn off xtables compat layer
    https://git.kernel.org/netdev/net-next/c/47a6959fa331

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


