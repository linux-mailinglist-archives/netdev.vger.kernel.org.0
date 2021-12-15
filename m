Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35F5475767
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhLOLKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbhLOLKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F7DC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E1A618A9
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67FA9C34606;
        Wed, 15 Dec 2021 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566609;
        bh=KwsFPbBy/xk1RDFybUj8dwdRTxtV+mkarUNyxI0mo5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sYV6KMhya4OlNNpZ2qLDH9ScxJcGNh0NQe9Gfd2blq2J1t3d3eChviW3rJoNO8L4Z
         gbXSsQA28pZPdgvMwlLyWNZAagieDg6M09foFW1w6wur8zfCPa5cmBMEEXOQG9PQHz
         QsUgI3+pmeL2bmDE+/DbZZ/Zjv7SmdxYUNAZv8xA++nZTxph4l1CeAC39hGzW5wXwR
         nrkYXgYjrTjvs3v4VMd9C7zPpsq16K/8oKB5TnIJJsZJaE/5Z8Zfzgf3cd/qucgBez
         w2dQKIAjaxCjttQASqXdPJokqLeGlKCFK515l4KtL1n3zmBhVvCLGEvkA7KrFQ4qMm
         MwlIw8IhzVY3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 302B060A4F;
        Wed, 15 Dec 2021 11:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-12-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956660919.16045.10361488396615618103.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:09 +0000
References: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, karol.kolacinski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 14 Dec 2021 11:50:18 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Karol corrects division that was causing incorrect calculations and
> adds a check to ensure stale timestamps are not being used.
> 
> The following are changes since commit 3dd7d40b43663f58d11ee7a3d3798813b26a48f1:
>   Merge branch 'mlxsw-fixes'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Use div64_u64 instead of div_u64 in adjfine
    https://git.kernel.org/netdev/net/c/0013881c1145
  - [net,2/2] ice: Don't put stale timestamps in the skb
    https://git.kernel.org/netdev/net/c/37e738b6fdb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


