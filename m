Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C353D2E230A
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 01:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgLXAkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 19:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgLXAkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 19:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 790CC225AC;
        Thu, 24 Dec 2020 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608770406;
        bh=94qq2a88O4UAhDMa3Pv1l8arck0fLWE7UsqaI/dClEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GI+apQBWRS8leHw9lV0pxN7tu5OZxdLBhCZhjxVUUFehQXZ8kLPPEZx+9iFkWYG39
         FsGaVg/xB0te5A13R8ZBCGLVUImWjkVxqjfIxEKTOcDGxtNix+pAZmoWsHig+L8SH0
         SPmHT0OnahA/8CHvK4MOsORZqakGxegENczBSXT63IHtxtofjUh2TEqI1QAvCxX3EQ
         JAWu7U2vEl504KB5iZ5l+xzjWcgCLk3KUB8e2VuoOm1ODDrdmHSIe1hXTgdng0UkfD
         vF2WAKHoi2LlRY8c6jB/T6p1Kq4VLOi1AZH9i4NRFgTbrcCdDpgJoMXcQmygInwp70
         zWDkOS5XR2CNQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 6D5CE60154;
        Thu, 24 Dec 2020 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf] selftests/bpf: work-around EBUSY errors from hashmap
 update/delete
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160877040644.1898.11857535496181994978.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Dec 2020 00:40:06 +0000
References: <20201223200652.3417075-1-andrii@kernel.org>
In-Reply-To: <20201223200652.3417075-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 23 Dec 2020 12:06:52 -0800 you wrote:
> 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked") introduced
> a possibility of getting EBUSY error on lock contention, which seems to happen
> very deterministically in test_maps when running 1024 threads on low-CPU
> machine. In libbpf CI case, it's a 2 CPU VM and it's hitting this 100% of the
> time. Work around by retrying on EBUSY (and EAGAIN, while we are at it) after
> a small sleep. sched_yield() is too agressive and fails even after 20 retries,
> so I went with usleep(1) for backoff.
> 
> [...]

Here is the summary with links:
  - [v2,bpf] selftests/bpf: work-around EBUSY errors from hashmap update/delete
    https://git.kernel.org/bpf/bpf/c/11b844b0b7c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


