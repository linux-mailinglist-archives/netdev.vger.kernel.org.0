Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D9731A98A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBMBqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhBMBqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:46:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D5DED64E95;
        Sat, 13 Feb 2021 01:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613180752;
        bh=Mn2mG2SVvklOMDrJMwzuqvPR3jRvR5XWACTCtm7vfBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Slkas+kHua/30yzzONQJ1B8xrFc8R8z03mbfZZcjI24aJGoYjgqsfxOZt35TI58Lz
         qk/nVqAx9NcgIVS28yVsOHqTuodohdST2rFm5YgXYa5YkHyGY1ujSS3JsbnipW4tk7
         xo8tvBv6xAWUYz70PMy1W6g2d5774AEHiEI8otjIJDjnsOkXPtf2BLYiehg0wHNoc1
         XANJMZ0fvgcMWo0yvZNNbShxJUE4Trm3MdVF7luZxIVpouQEze5gWW8UEk0gLXa9OV
         kOIQ3chEBtLTCPZXqBHb08qZHwHYME+x2n+7efM9NLC9WmU2ygJPuMCjVKrbOIEHvR
         fr2wD6d+6DaZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D03DD60A2F;
        Sat, 13 Feb 2021 01:45:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-02-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161318075284.24767.17651928696969091168.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:45:52 +0000
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 14:39:41 -0800 you wrote:
> This series contains updates to i40e, ice, and ixgbe drivers.
> 
> Maciej does cleanups on the following drivers.
> For i40e, removes redundant check for XDP prog, cleans up no longer
> relevant information, and removes an unused function argument.
> For ice, removes local variable use, instead returning values directly.
> Moves skb pointer from buffer to ring and removes an unneeded check for
> xdp_prog in zero copy path. Also removes a redundant MTU check when
> changing it.
> For i40e, ice, and ixgbe, stores the rx_offset in the Rx ring as
> the value is constant so there's no need for continual calls.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] i40e: drop redundant check when setting xdp prog
    https://git.kernel.org/netdev/net-next/c/99f097270a18
  - [net-next,02/11] i40e: drop misleading function comments
    https://git.kernel.org/netdev/net-next/c/4a14994a921e
  - [net-next,03/11] i40e: adjust i40e_is_non_eop
    https://git.kernel.org/netdev/net-next/c/d06e2f05b4f1
  - [net-next,04/11] ice: simplify ice_run_xdp
    https://git.kernel.org/netdev/net-next/c/59c97d1b51b1
  - [net-next,05/11] ice: move skb pointer from rx_buf to rx_ring
    https://git.kernel.org/netdev/net-next/c/29b82f2a09d5
  - [net-next,06/11] ice: remove redundant checks in ice_change_mtu
    https://git.kernel.org/netdev/net-next/c/43a925e49d46
  - [net-next,07/11] ice: skip NULL check against XDP prog in ZC path
    https://git.kernel.org/netdev/net-next/c/5c57e507f247
  - [net-next,08/11] i40e: Simplify the do-while allocation loop
    https://git.kernel.org/netdev/net-next/c/f892a9af0cd8
  - [net-next,09/11] i40e: store the result of i40e_rx_offset() onto i40e_ring
    https://git.kernel.org/netdev/net-next/c/f7bb0d71d658
  - [net-next,10/11] ice: store the result of ice_rx_offset() onto ice_ring
    https://git.kernel.org/netdev/net-next/c/f1b1f409bf79
  - [net-next,11/11] ixgbe: store the result of ixgbe_rx_offset() onto ixgbe_ring
    https://git.kernel.org/netdev/net-next/c/c0d4e9d223c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


