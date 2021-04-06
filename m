Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D1B355F93
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245179AbhDFXkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhDFXkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F0AB613A7;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617752409;
        bh=1HVgemWvY93p1cmPSjqD5NAJhsHN+cOW9Fe58MJeC+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tqxHP8F/xYUE/lrej5tR356jqo/v4jdDOYAYDk/kq4ayVZG1KUZ5fysuvk4N8Bcnv
         GoKtSPzmBE7xiHSw7I76sREskqEydHduGw61RB+e+5Sxx+ZRICziHVeWP0vqcGP+l1
         p858F0WwjEO+kMXfZ9lzu0KZCFe8wKtz4N0DD3InFC1a4wQsl2tcZb9sKhU39aCQIF
         vulxFHFyZCeQfmcephP14DgQ6YikXaHIT7oa+4+tjeY/BQJoxx4qmdmU24oeo6nLPc
         IMzs/773ep8qtNu0ILcA07gCEkFg9UBgKORbrntZ/Svzj0V1Y79gM+Vfa0AQTTiye8
         Vtb8+/mRKt/dA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1548F60A2A;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 0/2] bpf, sockmap fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775240908.19905.12958340313849612276.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:40:09 +0000
References: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
In-Reply-To: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     xiyou.wangcong@gmail.com, andrii.nakryiko@gmail.com,
        daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Thu, 01 Apr 2021 14:59:58 -0700 you wrote:
> This addresses an issue found while reviewing latest round of sock
> map patches and an issue reported from CI via Andrii. After this
> CI ./test_maps is stable for me.
> 
> The CI discovered issue was introduced by over correcting our
> previously broken memory accounting. After the fix, "bpf, sockmap:
> Avoid returning unneeded EAGAIN when redirecting to self" we fixed
> a dropped packet and a missing fwd_alloc calculations, but pushed
> it too far back into the packet pipeline creating an issue in the
> unlikely case socket tear down happens with an enqueued skb. See
> patch for details.
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/2] bpf, sockmap: fix sk->prot unhash op reset
    https://git.kernel.org/bpf/bpf/c/1c84b33101c8
  - [bpf,v2,2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
    https://git.kernel.org/bpf/bpf/c/144748eb0c44

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


