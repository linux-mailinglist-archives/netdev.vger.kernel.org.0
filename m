Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993963EF71E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhHRBAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235496AbhHRBAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 21:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1ADF261075;
        Wed, 18 Aug 2021 01:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629248406;
        bh=EKOiXY72DPlk1gQ3uLJHF8jXdTMHtHS+fvSos4PkH1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dx5f3sjcfLyl3EX/xZj56QXyvv0c22+B4U7rbVay2ygQElkbKci0LqN3gojFzSP2r
         udTcw4e15VmQHvA8gJ/DH68b/ZZjYHv3zpDqJo7LEJSqTJSOvGp34TC4rH9C9R6ubM
         fOE1HZCForEKLNAz+43qOmIFigsTSzXPObWl73miYikC9OZTs8WIhAXtZM5ZEXWDGC
         0mMuFrFTOaLUsvbEZXme9xZqn59LhlFGqPjH3dHavOxnXDCOXLNI30Hr8VjTakoeu3
         vnRyya+NwLyokXLf6RNpg2+VohBSdBu4qZjSnMseUDI9XQkYLnH5MUbDR1aV4lV9CX
         Di3CZFUmlTvbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1578560721;
        Wed, 18 Aug 2021 01:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-08-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162924840608.10457.1708488445673369739.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 01:00:06 +0000
References: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 13:35:47 -0700 you wrote:
> This series contains updates to iavf and i40e drivers.
> 
> Stefan Assmann converts use of flag based locking of critical sections
> to mutexes for iavf.
> 
> Colin King fixes a spelling error for i40e.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] iavf: use mutexes for locking of critical sections
    https://git.kernel.org/netdev/net-next/c/5ac49f3c2702
  - [net-next,2/2] i40e: Fix spelling mistake "dissable" -> "disable"
    https://git.kernel.org/netdev/net-next/c/6e9078a667a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


