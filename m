Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B570439E92B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFGVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhFGVl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:41:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BC9261245;
        Mon,  7 Jun 2021 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623102004;
        bh=1Ynso/1KIAIG5yOFhl1gYy9VV5KZHL8N+eirf9uSnCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VIONcEN/8K1PNtXW8znF2A3C1mZQV9k0cvMRFkaUQKTOxAQNxwwIRieJDZktyGSkH
         iZ49tAd/JYvDaqvUrXBs59KzybGP+6QcBwoRqiQJ9VCPOIz/RqvQp606HDs7IPyAmp
         gGFPeszGws5jyA5yOHlPHiFcxBxvTFAUorGiomapx7HViq5wG4SsYmTH2piG4ZeCEQ
         LbvtdN9mL0BmbQQTN36J+W0vnkai9OQJ/CObc2t4fzEYDdZPDHp+0oCkrfVnQwXqds
         cN8Z74cebO4y7grOqAEldV12UGzvnkA4rS2BegefVJuqEpErYjvHczF0Jn8klMGLW8
         cZlui9jiLSPFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D34860BE2;
        Mon,  7 Jun 2021 21:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/5] page_pool: recycle buffers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310200411.11768.6205430346849160444.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:40:04 +0000
References: <20210607190240.36900-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210607190240.36900-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        thomas.petazzoni@bootlin.com, mw@semihalf.com,
        linux@armlinux.org.uk, mlindner@marvell.com,
        stephen@networkplumber.org, tariqt@nvidia.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, borisp@nvidia.com, arnd@arndb.de,
        akpm@linux-foundation.org, peterz@infradead.org, vbabka@suse.cz,
        yuzhao@google.com, will@kernel.org, fenghua.yu@intel.com,
        guro@fb.com, hughd@google.com, peterx@redhat.com, jgg@ziepe.ca,
        jonathan.lemon@gmail.com, alobakin@pm.me, cong.wang@bytedance.com,
        wenxu@ucloud.cn, haokexin@gmail.com, jakub@cloudflare.com,
        elver@google.com, willemb@google.com, linmiaohe@huawei.com,
        linyunsheng@huawei.com, gnault@redhat.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, willy@infradead.org, edumazet@google.com,
        dsahern@gmail.com, lorenzo@kernel.org, saeedm@nvidia.com,
        andrew@lunn.ch, pabeni@redhat.com, sven.auhagen@voleatech.de,
        yhs@fb.com, walken@google.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, david@redhat.com,
        songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 21:02:35 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> This is a respin of [1]
> 
> This patchset shows the plans for allowing page_pool to handle and
> maintain DMA map/unmap of the pages it serves to the driver. For this
> to work a return hook in the network core is introduced.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/5] mm: add a signature in struct page
    https://git.kernel.org/netdev/net-next/c/c07aea3ef4d4
  - [net-next,v8,2/5] skbuff: add a parameter to __skb_frag_unref
    https://git.kernel.org/netdev/net-next/c/c420c98982fa
  - [net-next,v8,3/5] page_pool: Allow drivers to hint on SKB recycling
    https://git.kernel.org/netdev/net-next/c/6a5bcd84e886
  - [net-next,v8,4/5] mvpp2: recycle buffers
    https://git.kernel.org/netdev/net-next/c/133637fcfab2
  - [net-next,v8,5/5] mvneta: recycle buffers
    https://git.kernel.org/netdev/net-next/c/e4017570daee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


