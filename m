Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2543010C
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhJPIFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239884AbhJPICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2963D61263;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371215;
        bh=n0MpGGnG6YCGyCA0N2+K+25FiZq2dm1Y9Iav0fFoH6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HyZlPRsrlPNVM27vl0fK0gp8MR4CXXVQDUHYBMpDDEU5CzoHUHyQJGPDIPy+8shGr
         /7inUOSC9UShjohHm/ewRLVH7Y6lMBgSqLa+iAohCckHSxkIkCeX9Jg8lna5+4a4d6
         jETcgzfXSXo5SoYZgl43PSrsMZDyKBbRBB3Pf+oyAiNGboXVWj1f60e7skFZNcaEQ/
         Ofc8KHTYOFpzx2Ll0ZQi2IZBauQRE11DM6sFUvN/P8lFxsZtsLiztUmwSriNuIqB8V
         PUKSAcl+M68WebWz8Rcs0uCM2upPrHWoTS3G7pkZ6SK10BevZEW/FEXoRax++XRlxH
         S/MsttiCVUsRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 148A960A90;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437121507.28528.14004144964081319278.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:00:15 +0000
References: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kpsingh@kernel.org,
        kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 15 Oct 2021 09:28:59 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Maciej makes improvements centered around XDP. Changes include removing
> an unused field from the ring structure, creating separate Tx and Rx
> ring structures, and using ice_for_each macros for iterating rings.
> Some calls and parameters are changed to reduce unneeded overhead for
> further optimization. New fields are added for tracking to aid in
> improving workloads. He also unifies XDP indexing to a single
> methodology and adds a fallback patch when XDP Tx queue per CPU is not
> met.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ice: remove ring_active from ice_ring
    https://git.kernel.org/netdev/net-next/c/e93d1c37a85b
  - [net-next,2/9] ice: move ice_container_type onto ice_ring_container
    https://git.kernel.org/netdev/net-next/c/dc23715cf30a
  - [net-next,3/9] ice: split ice_ring onto Tx/Rx separate structs
    https://git.kernel.org/netdev/net-next/c/e72bba21355d
  - [net-next,4/9] ice: unify xdp_rings accesses
    https://git.kernel.org/netdev/net-next/c/0bb4f9ecadd4
  - [net-next,5/9] ice: do not create xdp_frame on XDP_TX
    https://git.kernel.org/netdev/net-next/c/a55e16fa330a
  - [net-next,6/9] ice: propagate xdp_ring onto rx_ring
    https://git.kernel.org/netdev/net-next/c/eb087cd82864
  - [net-next,7/9] ice: optimize XDP_TX workloads
    https://git.kernel.org/netdev/net-next/c/9610bd988df9
  - [net-next,8/9] ice: introduce XDP_TX fallback path
    https://git.kernel.org/netdev/net-next/c/22bf877e528f
  - [net-next,9/9] ice: make use of ice_for_each_* macros
    https://git.kernel.org/netdev/net-next/c/2faf63b650bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


