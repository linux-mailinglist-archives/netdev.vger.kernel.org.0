Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD13D455B1C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344433AbhKRMDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344390AbhKRMDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:03:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 08F20611BF;
        Thu, 18 Nov 2021 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236810;
        bh=ynZK/PG32plmk4OePUX0wrWi3C1KD7cR2YAHZO7TvD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fz/mSh0uDwR/gWupKsVDJfyRnxN4z7pg1LR59oaX+foAegPVAxlrUV8Rh7XN94WAy
         8TstDw/KPz2qj9bqnOSWN0Rpr9RvyHKDRba1qlSKhSHcAbOrcxmo3d8tXN4wXVWKMx
         GmbWaLkokAXwLWQEoM9S0KoEPBrMZzrat474WvzS4KxDw2FreVDLaXQ8mSynZNv9uW
         GBUQcnXnuaHezRexi/9c9fH5fF8v5EfZkDmpXAHQXfLEWpQVg3qc1nLtlnK5Hr6JaG
         NuxJHCdW3DJhjS47PkjFAJ6rRwKNCxQtzGxjHAJIQUtp3a6kPqMn7vmBkGwN/SxB4c
         erbDgfSQyo7EA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB08E609CD;
        Thu, 18 Nov 2021 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7][pull request] Intel Wired LAN Driver Updates
 2021-11-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723680995.21585.5506433442599827995.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:00:09 +0000
References: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 17 Nov 2021 16:31:52 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Eryk adds accounting for VLAN header in packet size when VF port VLAN is
> configured. He also fixes TC queue distribution when the user has changed
> queue counts as well as for configuration of VF ADQ which caused dropped
> packets.
> 
> [...]

Here is the summary with links:
  - [net,1/7] i40e: Fix correct max_pkt_size on VF RX queue
    https://git.kernel.org/netdev/net/c/6afbd7b3c53c
  - [net,2/7] i40e: Fix NULL ptr dereference on VSI filter sync
    https://git.kernel.org/netdev/net/c/37d9e304acd9
  - [net,3/7] i40e: Fix changing previously set num_queue_pairs for PFs
    https://git.kernel.org/netdev/net/c/d2a69fefd756
  - [net,4/7] i40e: Fix ping is lost after configuring ADq on VF
    https://git.kernel.org/netdev/net/c/9e0a603cb7dc
  - [net,5/7] i40e: Fix warning message and call stack during rmmod i40e driver
    https://git.kernel.org/netdev/net/c/3a3b311e3881
  - [net,6/7] i40e: Fix creation of first queue by omitting it if is not power of two
    https://git.kernel.org/netdev/net/c/2e6d218c1ec6
  - [net,7/7] i40e: Fix display error code in dmesg
    https://git.kernel.org/netdev/net/c/5aff430d4e33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


