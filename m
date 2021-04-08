Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F587358F90
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhDHWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhDHWAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 18:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9FF7610D1;
        Thu,  8 Apr 2021 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617919209;
        bh=t0ziCL2xGc97kPnTSsOYozxuSzgJR92i5ZnA2Pli4DU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TlsES/sr6qMJCDgZHrtNh5tsFvGaRTUhwQ2vCMd7o4Ph2XXEp9SROpa+jlC8XpBtZ
         qVmjdk4XwnJBUS6WLExSkEGVGO0GBh99E1gbRZ0nEERe9YlpRuOqWBXIE64eAZLwoQ
         T/goJa+1zVmKv6W9VqJVwO1RccY7aE3fgNpUBOpzyJhtYlnKXDeSj+JA5Qnca5rFov
         X4m+Ua6cZkBFdf3BTnwbtCDs7LshZEG/+dF1xEwECyztO0yHwb4k1YSgXQHWp7DKIW
         8GBgpBxbTmj0Tu73i/OT8e49HUhtt1mX3qgNciaGNpwF+v6QKKb3eMvVEfJa0+ZHro
         dpgx9FuGhTgPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA061609B6;
        Thu,  8 Apr 2021 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates
 2021-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791920982.30481.6177451047983591215.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 22:00:09 +0000
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Apr 2021 10:35:31 -0700 you wrote:
> This series contains updates to i40e and ice drivers.
> 
> Grzegorz fixes the ordering of parameters to i40e_aq_get_phy_register()
> which is causing incorrect information to be reported.
> 
> Arkadiusz fixes various sparse issues reported on the i40e driver.
> 
> [...]

Here is the summary with links:
  - [net,1/6] i40e: Fix parameters in aq_get_phy_register()
    https://git.kernel.org/netdev/net/c/b2d0efc4be7e
  - [net,2/6] i40e: Fix sparse errors in i40e_txrx.c
    https://git.kernel.org/netdev/net/c/12738ac4754e
  - [net,3/6] i40e: Fix sparse error: uninitialized symbol 'ring'
    https://git.kernel.org/netdev/net/c/d6d04ee6d2c9
  - [net,4/6] i40e: Fix sparse error: 'vsi->netdev' could be null
    https://git.kernel.org/netdev/net/c/6b5674fe6b9b
  - [net,5/6] i40e: Fix sparse warning: missing error code 'err'
    https://git.kernel.org/netdev/net/c/8a1e918d833c
  - [net,6/6] ice: fix memory leak of aRFS after resuming from suspend
    https://git.kernel.org/netdev/net/c/1831da7ea5bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


