Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED0342751
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCSVAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhCSVAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F2AE6197D;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616187609;
        bh=HLMjRKxTK5+1hR2hihf9PrdNNcm1ykRwtfVZLx1iLIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bEqpPXa0Z9wtxOr5w1XO3BesMtuCwg4caguX6QgAmPpuiprg1NP4lSqjMRyphrsxH
         Jdy9cLDkknT5iB19QUlxwNwWftgFgCJCUqTem1v9PfbFla0lw4lYHAnpjvsBBC86dQ
         c6S18fej71NHb47s3UkmopL6viBsMJg3NDFQ7N6oT9BWECeiBEzkNqPMB7WubG+GMP
         flVYku0JL+WtQwHLX+rPnkGyqhgQDZ4Yy9dUF4ASeVu3bKXPB7fiRi8VGqDqDRf9j7
         7JtCQFVvXERBjvDW5BozSkQGy7FdHHvfTxKv0Q2qbZBrKV6zrZYr9aycfracnlPjeE
         4+B/iG6WQ1t9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F29B1626EB;
        Fri, 19 Mar 2021 21:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2021-03-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618760898.12397.2789199746014133414.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 21:00:08 +0000
References: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 09:19:54 -0700 you wrote:
> This series contains updates to e1000e and igb drivers.
> 
> Tom Seewald fixes duplicate guard issues by including the driver name in
> the guard for e1000e and igb.
> 
> Jesse adds checks that timestamping is on and valid to avoid possible
> issues with a misinterpreted time stamp for igb.
> 
> [...]

Here is the summary with links:
  - [net,1/3] e1000e: Fix duplicate include guard
    https://git.kernel.org/netdev/net/c/896ea5dab25e
  - [net,2/3] igb: Fix duplicate include guard
    https://git.kernel.org/netdev/net/c/a75519a84855
  - [net,3/3] igb: check timestamp validity
    https://git.kernel.org/netdev/net/c/f0a03a026857

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


