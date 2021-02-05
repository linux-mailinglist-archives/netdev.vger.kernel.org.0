Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87D33102EE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBECky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhBECkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 21:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F47364FB3;
        Fri,  5 Feb 2021 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612492807;
        bh=s3mrUTF85e0lkblvyy5bYFWLYge2WF7tbsn6bJvLuS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X0BKqaPpFTfJ0lSgzu4TKG3CcgL8NeL0YjiM6SROz7PeKVrPijP6rZMnkHA0iG2rQ
         m6LdkqHRvol1BeAxGz64eQ59UFKiXMP5fVnNxp1gX0a+939QQANNi1DoghK//fTkT2
         Pydz9emUZ5H6SiD6A+FZs8uDL/2nxpTiuEy7FgjcTJonf12M3k7XBAHnpq/Nbbm3/r
         80Ke6zJhpqZMMNx/dd0Sq6bNYubhptPpHLDKt1+/0t0tks01lVR/FxQQoy0x8tJff/
         rwE1z4uviUcCOri+VTWvhtr2xR3Na/L7ak3Lwvv8xhtsABYB8aIphGdH4K7VMFbTQw
         ZRs21jg4sYoTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 727A2609F1;
        Fri,  5 Feb 2021 02:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND v3 net-next 0/5] net: consolidate page_is_pfmemalloc()
 usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249280746.9463.15568343687164067943.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 02:40:07 +0000
References: <20210202133030.5760-1-alobakin@pm.me>
In-Reply-To: <20210202133030.5760-1-alobakin@pm.me>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, jhubbard@nvidia.com,
        rientjes@google.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
        akpm@linux-foundation.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        willemb@google.com, rdunlap@infradead.org, pablo@netfilter.org,
        decui@microsoft.com, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 02 Feb 2021 13:30:43 +0000 you wrote:
> page_is_pfmemalloc() is used mostly by networking drivers to test
> if a page can be considered for reusing/recycling.
> It doesn't write anything to the struct page itself, so its sole
> argument can be constified, as well as the first argument of
> skb_propagate_pfmemalloc().
> In Page Pool core code, it can be simply inlined instead.
> Most of the callers from NIC drivers were just doppelgangers of
> the same condition tests. Derive them into a new common function
> do deduplicate the code.
> 
> [...]

Here is the summary with links:
  - [RESEND,v3,net-next,1/5] mm: constify page_is_pfmemalloc() argument
    https://git.kernel.org/netdev/net-next/c/1d7bab6a9445
  - [RESEND,v3,net-next,2/5] skbuff: constify skb_propagate_pfmemalloc() "page" argument
    https://git.kernel.org/netdev/net-next/c/48f971c9c80a
  - [RESEND,v3,net-next,3/5] net: introduce common dev_page_is_reusable()
    https://git.kernel.org/netdev/net-next/c/bc38f30f8dbc
  - [RESEND,v3,net-next,4/5] net: use the new dev_page_is_reusable() instead of private versions
    https://git.kernel.org/netdev/net-next/c/a79afa78e625
  - [RESEND,v3,net-next,5/5] net: page_pool: simplify page recycling condition tests
    https://git.kernel.org/netdev/net-next/c/05656132a874

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


