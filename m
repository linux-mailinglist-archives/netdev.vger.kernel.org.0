Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2643F3F922C
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243918AbhH0CBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 22:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhH0CBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 22:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84A2160FD8;
        Fri, 27 Aug 2021 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630029617;
        bh=Wl+JXwMuwHEkHhn2tvJnRowCeFGA//15Xyui9QiV7pY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lDndKkFkLuC7kfvUrb2/cyj0RmnXReaLu4e4khISSv5+yNg2A73BbT6oszn6gZv2P
         9kkP17wZdNAM9Hh2gksDx2DZO/L4aFeJNarQR/hWtTm0LHvOzGT5BJ2nLHx1bWUiKY
         IN9oUinhfCn7ngFHZwF0EXtVDWe+SIjH+ys3mAzFPCDD68ixQC0NK4Q+PAk5OHXoXF
         MweQCD9Lg1YwpfZdQCn15RJehhh6ML7P/BkXN6IqltjffVFY5oqNGIBSs4JzXBaElr
         zq5a0hvdWPmngS/XpyagE0fFav5nUf1S7CaxK9HbL5sqlE6lxti2GMRceP0T/hB41O
         Mk8zvJksX0Y2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7843E60A14;
        Fri, 27 Aug 2021 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] tcp: enable mid stream window clamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163002961748.18312.1275499142558785309.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 02:00:17 +0000
References: <20210825210117.1668371-1-ntspring@fb.com>
In-Reply-To: <20210825210117.1668371-1-ntspring@fb.com>
To:     Neil Spring <ntspring@fb.com>
Cc:     davem@davemloft.net, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        ncardwell@google.com, ycheng@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 14:01:17 -0700 you wrote:
> The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size
> of the advertised window to this value."  Window clamping is distributed
> across two variables, window_clamp ("Maximal window to advertise" in
> tcp.h) and rcv_ssthresh ("Current window clamp").
> 
> This patch updates the function where the window clamp is set to also
> reduce the current window clamp, rcv_sshthresh, if needed.  With this,
> setting the TCP_WINDOW_CLAMP option has the documented effect of limiting
> the window.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] tcp: enable mid stream window clamp
    https://git.kernel.org/netdev/net-next/c/3aa7857fe1d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


