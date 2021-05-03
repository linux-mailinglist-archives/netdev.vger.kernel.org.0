Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4282372312
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhECWlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECWlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 18:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E83761244;
        Mon,  3 May 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620081609;
        bh=EId6kf7dYAAcb9NHBMUZHxH/nq1IamnEDqjoldXa8LE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gle9ZM+cMSnoXF4D3LoXcHbgTRJOHDEuhjVz0ijN4Ks9kuKqBZbP0+VhpLetbI9pL
         PHgS+fxblnLAgT3vnf1UQS+W73PQMIQby+lWQZhfQCutL60Dj4cvggAGvzlXXPTb1/
         AMRBARlPkDyT6ZFCNy8ES6xTy8dGKraqnZjHnYnLc+mHDABVyT55ZXacKl8mXfdIWM
         ucN2PJFZJYqOhQyXUwXbtKbOrTc1B2mRJv5pbBG6p+0N3FlDZwy8HfZPilYblbpTqk
         k//5LDE9bQcg0lsqNlys8In0AYqJnv+Rd+crsDsG3RX8TctGTrhCtM9BB/w7NrONpy
         Ad8pCbMTMKtCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C22F60A0A;
        Mon,  3 May 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] xsk: fix for xp_aligned_validate_desc() when len ==
 chunk_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162008160950.21836.7395274309646147573.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 22:40:09 +0000
References: <20210428094424.54435-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210428094424.54435-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf@vger.kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 28 Apr 2021 17:44:24 +0800 you wrote:
> When desc->len is equal to chunk_size, it is legal. But
> xp_aligned_validate_desc() got "chunk_end" by desc->addr + desc->len
> pointing to the next chunk during the check, which caused the check to
> fail.
> 
> Related commit:
> commit 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> commit 26062b185eee ("xsk: Explicitly inline functions and move
>                     definitions")
> 
> [...]

Here is the summary with links:
  - [bpf,v2] xsk: fix for xp_aligned_validate_desc() when len == chunk_size
    https://git.kernel.org/bpf/bpf/c/ac31565c2193

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


