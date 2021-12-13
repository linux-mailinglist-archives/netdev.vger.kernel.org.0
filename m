Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F54473894
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbhLMXap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:30:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51344 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242230AbhLMXao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 18:30:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C47612C7;
        Mon, 13 Dec 2021 23:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75663C34605;
        Mon, 13 Dec 2021 23:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639438243;
        bh=hPBajqcTL7kl3Wv5HUNpmv0VzbUlAc9DXWsyMgUyMGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W4HJXRI4Tl3uHTEeAZFy9H9YkNq+SHYfEzUMYHEjppoy/hvplX3whotT6Y2mHsVDq
         tegW0BcXgf1DWHCB9JkGc/GkeT3gBGs9ge+5iVVpU83i2lqFafuguS55+agEkqsNam
         /jVwwR7pIafHYIwb7DL/XuONjQBGNafTKL1lpzkTtzPs1WAIOVsp3fnRnm3cmhkAQ6
         +cpDjudjpLu4B8bt7Nc3YcfndMJXOJGdb7jtVJfQEvRU65Li47N8+1/V+IM4KPkVsG
         0Rqg5+y2VSPheM6X5CSbarujcFYTUXmnUuS/ZhneSpVMqDhxD6SzGa04CdqPLhLW6s
         B/xPHhlF3Gvlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E91E6098C;
        Mon, 13 Dec 2021 23:30:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] xsk: wipe out dead zero_copy_allocator declarations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163943824338.22239.7621324515753235885.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 23:30:43 +0000
References: <20211210171511.11574-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20211210171511.11574-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 10 Dec 2021 18:15:11 +0100 you wrote:
> zero_copy_allocator has been removed back when Bjorn Topel introduced
> xsk_buff_pool. Remove references to it that were dangling in the tree.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h           | 1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h | 2 --
>  include/net/xdp_priv.h                               | 1 -
>  3 files changed, 4 deletions(-)

Here is the summary with links:
  - [bpf-next] xsk: wipe out dead zero_copy_allocator declarations
    https://git.kernel.org/bpf/bpf-next/c/d27a66229096

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


