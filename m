Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56894742E8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhLNMuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbhLNMuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4596BC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E25CD614CA
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C9F3C34607;
        Tue, 14 Dec 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486209;
        bh=uPHr/tonmHxEhS3hYMaTQQm3NYuddOQV9j4mYvxV7hg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=actzadc8G1jMxtSqr8EA6CdRk7vImmGtaXR/OsgYRw6T1Q4dOk9lpD0gB8LCFZXme
         oe3Nh/hmQLjDZYt47NwZbPMDGxO2QdFZic+tZtJeWzvs3BH9DmYrvUfvoevotD1O3+
         a34ZMMGQrd3Rx3Et8CnY/BGPhVY1LuvIPDnjx8adDAut8aniek9bgYnWupZ3SvkCOM
         kDn2zXS1EW6UKJBnb0iza+10B/dDWd5sCrTJWmDgOi0OuUDTFD6bCRN5UmAYBtSQY9
         O+MklSN8Y8cjiJ8hBaXli94823Bmw8zTmDhiRM6o/kBf/LFaYGL0SDpr2dwLcbz0hn
         ECcWJypufWKew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E780609BA;
        Tue, 14 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-12-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948620918.17056.16114564569611083911.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:50:09 +0000
References: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 13 Dec 2021 15:37:48 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Dan Carpenter fixes some missing mutex unlocking.
> 
> Stefan Assmann restores stopping watchdog from overriding to reset state.
> 
> The following are changes since commit 884d2b845477cd0a18302444dc20fe2d9a01743e:
>   net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] iavf: missing unlocks in iavf_watchdog_task()
    https://git.kernel.org/netdev/net/c/bc2f39a6252e
  - [net,2/2] iavf: do not override the adapter state in the watchdog task (again)
    https://git.kernel.org/netdev/net/c/fe523d7c9a83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


