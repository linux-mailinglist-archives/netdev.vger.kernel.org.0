Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773EF32F66B
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCEXKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhCEXKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 18:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 752736509F;
        Fri,  5 Mar 2021 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614985810;
        bh=XDm0a5+1icmFrZ0b+A18H2fhbQT9FNS1HotUDzDQcv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lHJsfkOLRDF5lAxiZeEHM3yfcv/9yrH/rbr27b1IaRvTRB2PFesex/4/c+0+RbsKm
         gUNZt66/k2uNFyeUPlC0TtKhONrF8ep9cXhDf6QQm0x0mPlazL4CPoEGKHOsQ8/P03
         LsHV1wzU5NGi1KevG7CRogMLuVaiYeP+kK3N55b7dmYjWNzDPP2hP8mEChyD8w6wRn
         t2h4bBMy3Us8f9+qN9U7/PacR2lZbko6uYY5tXm6M2fSjWuPIbbTYn+uJmLjjvNRll
         fDV5PgQ1m3UZLE6joDDXM2a62iGnsg4+xmKsPvQFxCe6hdDXqkwdPAQ9hQuVl2lS6q
         pO/3QrAxRUHiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6824260A12;
        Fri,  5 Mar 2021 23:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] veth: store queue_mapping independently of XDP prog
 presence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161498581042.14945.16904385350181859241.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 23:10:10 +0000
References: <20210303152903.11172-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20210303152903.11172-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     makita.toshiaki@lab.ntt.co.jp, daniel@iogearbox.net,
        ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed,  3 Mar 2021 16:29:03 +0100 you wrote:
> Currently, veth_xmit() would call the skb_record_rx_queue() only when
> there is XDP program loaded on peer interface in native mode.
> 
> If peer has XDP prog in generic mode, then netif_receive_generic_xdp()
> has a call to netif_get_rxqueue(skb), so for multi-queue veth it will
> not be possible to grab a correct rxq.
> 
> [...]

Here is the summary with links:
  - [bpf] veth: store queue_mapping independently of XDP prog presence
    https://git.kernel.org/bpf/bpf/c/edbea9220251

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


