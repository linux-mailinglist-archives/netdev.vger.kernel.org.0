Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1934347986D
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhLRDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhLRDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAB74B82B7F
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BE05C36AEE;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798216;
        bh=8taeHz+BUzRdPSTxa4o5QO06jqTiQam5266/EQuRb0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A6k8ngg+fDGxnEKKrhEOqnTUQhkZa9HmffiAs35oiyafYv2GxDxbF8xZpbLztGfqM
         HRrhCszo7ZX6fCCVKpCyL2GpKKtY+j7pFqYF9Z1SwYAOG9Q78eWvUptj9TCUi1X6Ee
         W/AeHccopzocNS4fbMxmd9+yLFTr5iGyRNSrs+xsnE358hEpxQ4laA7SIfOynvtP5I
         G0OPRjTqQhG865vIAsECKn0TB2CRZX8kbJVV/sHgD3HbJ8Nqfnci4mKztCYbqFJgYN
         51fxo/SkgpkcogCJfXcg5BvfCk3Ilgr5d+UNsnBYRKpMGsyJzzKmh+Dfzm+cLTB3ZI
         Oo3TYMRl35p3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8AE4E60A54;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mptcp: Miscellaneous changes for 5.17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821656.17814.14058123416680753927.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:16 +0000
References: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 15:36:59 -0800 you wrote:
> These are three unrelated patches that we've been testing in the MPTCP
> tree.
> 
> 
> Patch 1 modifies the packet scheduler that picks which TCP subflow is
> used for each chunk of outgoing data. The updated scheduler improves
> throughput on multiple-subflow connections.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mptcp: enforce HoL-blocking estimation
    https://git.kernel.org/netdev/net-next/c/3ce0852c86b9
  - [net-next,2/3] selftests: mptcp: try to set mptcp ulp mode in different sk states
    https://git.kernel.org/netdev/net-next/c/f730b65c9d85
  - [net-next,3/3] mptcp: clean up harmless false expressions
    https://git.kernel.org/netdev/net-next/c/59060a47ca50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


