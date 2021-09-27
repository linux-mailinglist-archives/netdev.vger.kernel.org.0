Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C1741A2F6
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbhI0Wbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237501AbhI0Wbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 18:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6849561058;
        Mon, 27 Sep 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632781810;
        bh=P1ibG5tEs61yDknQ9hW4DIyNuABBlL7OHPnfYY6lmqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FkFL60krfglcFoiuxORk1bkxP6rE3No81b9eN2yxE2mrBJ9MX0odzM0sTepwt6tCP
         2h6LCx8U7ycZU9PEBbzQb1GrVr3IWCZxiL0zup76JKB/0RT0zCABIQbT+5D9LZYP3f
         R+6BGcavfKsO90e8zTTumo35GF4NYmtDZLU7WdbflNi6Hj8YVVHIWhF7n4H+w32iCX
         sz2aelexxfsoPoNZNHEaRpbmuAKc7G445Sdvp916e2a/wT6xc3BFDQ2fP55bXtLL+q
         rqpKI4CScikfGUN3n7xIWdlMgnmk9wqQ3uUhva1MtJVL1ACNXQjqPulpJmteUgF6UI
         K5TPQEQfhPphg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5BEB460A59;
        Mon, 27 Sep 2021 22:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/13] xsk: i40e: ice: introduce batching for Rx
 buffer allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163278181036.23478.12354330232651957432.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 22:30:10 +0000
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 22 Sep 2021 09:56:00 +0200 you wrote:
> This patch set introduces a batched interface for Rx buffer allocation
> in AF_XDP buffer pool. Instead of using xsk_buff_alloc(*pool), drivers
> can now use xsk_buff_alloc_batch(*pool, **xdp_buff_array,
> max). Instead of returning a pointer to an xdp_buff, it returns the
> number of xdp_buffs it managed to allocate up to the maximum value of
> the max parameter in the function call. Pointers to the allocated
> xdp_buff:s are put in the xdp_buff_array supplied in the call. This
> could be a SW ring that already exists in the driver or a new
> structure that the driver has allocated.
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/13] xsk: get rid of unused entry in struct xdp_buff_xsk
    https://git.kernel.org/bpf/bpf-next/c/10a5e009b93a
  - [bpf-next,02/13] xsk: batched buffer allocation for the pool
    https://git.kernel.org/bpf/bpf-next/c/47e4075df300
  - [bpf-next,03/13] ice: use xdp_buf instead of rx_buf for xsk zero-copy
    https://git.kernel.org/bpf/bpf-next/c/57f7f8b6bc0b
  - [bpf-next,04/13] ice: use the xsk batched rx allocation interface
    https://git.kernel.org/bpf/bpf-next/c/db804cfc21e9
  - [bpf-next,05/13] i40e: use the xsk batched rx allocation interface
    https://git.kernel.org/bpf/bpf-next/c/6aab0bb0c5cd
  - [bpf-next,06/13] xsk: optimize for aligned case
    https://git.kernel.org/bpf/bpf-next/c/94033cd8e73b
  - [bpf-next,07/13] selftests: xsk: fix missing initialization
    https://git.kernel.org/bpf/bpf-next/c/5b132056123d
  - [bpf-next,08/13] selftests: xsk: put the same buffer only once in the fill ring
    https://git.kernel.org/bpf/bpf-next/c/872a1184dbf2
  - [bpf-next,09/13] selftests: xsk: fix socket creation retry
    https://git.kernel.org/bpf/bpf-next/c/89013b8a2928
  - [bpf-next,10/13] selftests: xsk: introduce pacing of traffic
    https://git.kernel.org/bpf/bpf-next/c/1bf3649688c1
  - [bpf-next,11/13] selftests: xsk: add single packet test
    https://git.kernel.org/bpf/bpf-next/c/96a40678ce53
  - [bpf-next,12/13] selftests: xsk: change interleaving of packets in unaligned mode
    https://git.kernel.org/bpf/bpf-next/c/e4e9baf06a6e
  - [bpf-next,13/13] selftests: xsk: add frame_headroom test
    https://git.kernel.org/bpf/bpf-next/c/e34087fc00f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


