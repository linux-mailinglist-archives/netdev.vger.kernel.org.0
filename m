Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D9140AF6A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhINNm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhINNlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 86AE96113B;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626808;
        bh=sY3FYoSmQbHrpuWmnj0pThI/ulhOQVvVphlKpaSOIvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ufF7KNpBDyOJq95ZM5+lpeB3io8r4IdK7p/2kUauOWWFrwgyD9aloImCisrIb7N3Z
         2qNhhTcMDR3Atw3vn9V7j6GFMyDGnOoUamY/ZikU1FHgJ5afcPSzBF4mv1y6DRO+Mj
         igT4r6LUmuvQrMngVjXLrAvRe/kwsAGvei1N/RWwkb5uji0jtibVzxFsaJ1tpiwvt9
         Ei/22SbZsK83Y5JDcaxtGvQAbJXxgImZah/joMdx8h8gEmv4xyz9I5rt7eRl6Pc8lU
         NsxbCzVLYno5rVAlQeeREufqqyi13/BwPAQzM6RLn4pizQIMRtJoBJ8nlx/joEWBNQ
         /fOg6BdLlB5TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 79E4260A6F;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] skbuff: inline page_frag_alloc_align()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162680849.2816.14803547503911298627.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:40:08 +0000
References: <20210914034935.19137-1-yajun.deng@linux.dev>
In-Reply-To: <20210914034935.19137-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 11:49:35 +0800 you wrote:
> The __alloc_frag_align() is short, and only called by two functions,
> so inline page_frag_alloc_align() for reduce the overhead of calls.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/skbuff.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next,v2] skbuff: inline page_frag_alloc_align()
    https://git.kernel.org/netdev/net-next/c/32e3573f7392

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


