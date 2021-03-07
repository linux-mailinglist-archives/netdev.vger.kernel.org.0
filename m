Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32BF32FE92
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 04:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCGDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 22:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhCGDkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 22:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F72064FC9;
        Sun,  7 Mar 2021 03:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615088408;
        bh=1olaKk93h+rMyxRE6Tcp8HfI6Hl5cZ4A9NXuI46lGQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cgMkMpdV8W2FMzQbRE49e004XYJ/5nZeF1rwsH2tMmExN74srTUBHYWerZMBnsJF4
         Jaex+g0wZI+vxYtkDNrgPlsK5C4lQc4/hRnvepTI01M1m9xiOKSe9CM06f3crYymh8
         c2Cx4oix5G0y0e/GA9DGlEP3HbZkuPMRBi8q7N/G7GPP17lLR5tpZJFqLte5yfx2g1
         ZkeTGXqeZ42GRdP7HFn+IlQHdY/6fM/F+mf4yLiBeIoR8foBbkHtTYCIddA2m3TjnK
         dZGo6aPSNMzJz/cpBnPv9jxC7baGtIFj+qPH2p6rlfLK6aLSHGuKPwy1h7WnNA5CLt
         23pVf+fOiiEVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30199609D4;
        Sun,  7 Mar 2021 03:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] load-acquire/store-release barriers for
 AF_XDP rings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161508840819.30178.16120166038742511752.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Mar 2021 03:40:08 +0000
References: <20210305094113.413544-1-bjorn.topel@gmail.com>
In-Reply-To: <20210305094113.413544-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, toke@redhat.com,
        will@kernel.org, paulmck@kernel.org, stern@rowland.harvard.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri,  5 Mar 2021 10:41:11 +0100 you wrote:
> This two-patch series introduces load-acquire/store-release barriers
> for the AF_XDP rings.
> 
> For most contemporary architectures, this is more effective than a
> SPSC ring based on smp_{r,w,}mb() barriers. More importantly,
> load-acquire/store-release semantics make the ring code easier to
> follow.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] xsk: update rings for load-acquire/store-release barriers
    https://git.kernel.org/bpf/bpf-next/c/057e8fb782c1
  - [bpf-next,v2,2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
    https://git.kernel.org/bpf/bpf-next/c/60d0e5fdbdf6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


