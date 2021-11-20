Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6E457DDD
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhKTMdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237400AbhKTMdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C983A60EBC;
        Sat, 20 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637411408;
        bh=a5ZlCiJdrs1GmKK5h7ZVKHg6goSOrtmmiBanDpxbKOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=axyB6lhNnudyNhNXJHPD1oyrdF2SlToKvBO9VGVSsq7LbwahPKdfZdn3h8jvBzyqN
         3+5NPwwIG8HdKZw/S2lNCaigE+lBfe7ObgOGlU/1YmwKV+8LwVh7edKOYpRm8ZVCVi
         wgfLtIqcoNzQVyt5PdbWMLd9lvInNeJkY9btqaqyzb65Ig4bJFnshqpsUTUW/3BhtY
         Dx8EpzqCCTDqNCI7VJkQ0PKQAnaHYDehRFDSN7h+R+UjBZ8C8OFwpKhehwLIDS9TCw
         0BWXOdEWs5bpNw2jtbsWQPC/roOlRrbNcsoJoieqYp/LMedI1VZAOGEEtTOx+RvVHs
         Y739dpf6YOPnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD2D5609B4;
        Sat, 20 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2021-11-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163741140877.21964.3648428025185548176.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 12:30:08 +0000
References: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 19 Nov 2021 10:12:39 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Nitesh prevents user from changing interrupt settings when adaptive
> interrupt moderation is on.
> 
> Jedrzej resolves a hang that occurred when interface was closed while a
> reset was occurring and fixes statistics to be updated when requested to
> prevent stale values.
> 
> [...]

Here is the summary with links:
  - [net,1/4] iavf: Prevent changing static ITR values if adaptive moderation is on
    https://git.kernel.org/netdev/net/c/e792779e6b63
  - [net,2/4] iavf: Fix deadlock occurrence during resetting VF interface
    https://git.kernel.org/netdev/net/c/0cc318d2e840
  - [net,3/4] iavf: Fix refreshing iavf adapter stats on ethtool request
    https://git.kernel.org/netdev/net/c/3b5bdd18eb76
  - [net,4/4] iavf: Fix VLAN feature flags after VFR
    https://git.kernel.org/netdev/net/c/5951a2b9812d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


