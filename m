Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443A03E0AC9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhHDXUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhHDXUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0725061029;
        Wed,  4 Aug 2021 23:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628119205;
        bh=P/GGs8hlIh48v0Ciq1huoL+JlgaeydT9wU8h0v0AKic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C+eTAB78oZjct6ke8KG1Yg3kg4H+Rx9b5adxSA+oSJBFUrjd5x4WkCUvQFyJBPcA+
         QZ67oNgNBa0GTqTUPVICFjPbSZXMwXTN7k6S3lrI7uL8lLtGA8xPiIG/3xK2k6APSC
         vRK1Bn/jzNELsDP2wevxdlwgEBSlHFxj0lQvymgvpzIScQ6j5f4+5e/dRYgzozmkjZ
         Jn8ulXR0G0aGKTvKuy/BzW4iLPetorVRJ6vwKKk7NDMPUjyoKwiMMgG4rsr6ye5Nxa
         02X1B0gzGTT8qOCK9LGe5Yo7unQjYUeRBSOmxhcmm79OpdgKnuMtJE9Erjj4lj53JR
         4EAtxboAuZomw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F06E960A6A;
        Wed,  4 Aug 2021 23:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] selftests/bpf: move netcnt test under test_progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162811920498.26909.17665443585932522385.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 23:20:04 +0000
References: <20210804205524.3748709-1-sdf@google.com>
In-Reply-To: <20210804205524.3748709-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, yhs@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  4 Aug 2021 13:55:24 -0700 you wrote:
> Rewrite to skel and ASSERT macros as well while we are at it.
> 
> v3:
> - replace -f with -A to make it work with busybox ping.
>   -A is available on both busybox and iputils, from the man page:
>   On networks with low RTT this mode is essentially equivalent to
>   flood mode.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] selftests/bpf: move netcnt test under test_progs
    https://git.kernel.org/bpf/bpf-next/c/372642ea83ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


