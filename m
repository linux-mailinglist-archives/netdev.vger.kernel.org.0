Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DFE39481A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhE1VBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhE1VBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E6B061358;
        Fri, 28 May 2021 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622235606;
        bh=y5rknKuoZBP19E7vSNsLf2ZiR2KHEQ7V/mgVmxR799c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X54+TCG+qb1SNfK0VQf+wWwMq9NAjlYqxDsGJkCvGIbVoFHF+XIrIiCcelLo3Fh2f
         PzpqWxn+iNxb4IMZd/4SDpzFXE3XzU+tPsWKHtWQB5fmkNTvu+Lt26sM3mkATvEYRF
         asOTd13urFyqHaptytO0EbL5xmbZGKtSCZsZ72RaGT6JVimznuCDMgVh4YB+P/VnNB
         bgoNZQKCj4qAhMA0ZJYT9qgl5Pw9Ll3F4o6yWjJEWj4IPRo6uTtEYGPG9Ra30erMBB
         2LT7R0HQVhnaLFUPuLwK0/kgUVlqXsDIB3p1hTXhuB6Vtd1FjwWrsHHRtYhZ/FaELn
         ZAI8+UJqbcG0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1EE8E60A39;
        Fri, 28 May 2021 21:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mptcp: Fixes for 5.13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162223560612.19696.18047564340306818571.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 21:00:06 +0000
References: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 27 May 2021 16:31:36 -0700 you wrote:
> These patches address two issues in MPTCP.
> 
> Patch 1 fixes a locking issue affecting MPTCP-level retransmissions.
> 
> Patches 2-4 improve handling of out-of-order packet arrival early in a
> connection, so it falls back to TCP rather than forcing a
> reset. Includes a selftest.
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: fix sk_forward_memory corruption on retransmission
    https://git.kernel.org/netdev/net/c/b5941f066b4c
  - [net,2/4] mptcp: always parse mptcp options for MPC reqsk
    https://git.kernel.org/netdev/net/c/06f9a435b3aa
  - [net,3/4] mptcp: do not reset MP_CAPABLE subflow on mapping errors
    https://git.kernel.org/netdev/net/c/dea2b1ea9c70
  - [net,4/4] mptcp: update selftest for fallback due to OoO
    https://git.kernel.org/netdev/net/c/69ca3d29a755

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


