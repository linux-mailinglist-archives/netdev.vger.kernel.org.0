Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FAF2EF8FA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbhAHUUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbhAHUUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 15:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1622B23AC1;
        Fri,  8 Jan 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610137208;
        bh=NJQuMYdOPMG9Puz+oozd9AmGt/GBfycz8IPDz57ise0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQmDlTUHig2sgBDbPHcVY01yZ60yG1ZRHReBpy25NF+4w24D48IGF+jxteBPmEsC1
         oKghQ5+0jEGMAeWuCWgMxL8FqllmgEoSuJkgeEhqu+5WLfYagdJ3/Iv6REZ/ZVzcQ3
         b+Grnfjpz3tmfGyI0gCU8dkY1TldXcsTI+GKZ0Ml1CZ8XNFl/3SUqEjyaDptYVrWzz
         xVnWEc7Wk2oj23vytxxDZFqPSxmBLIYUomSkQ+4WDfV422KoiM+pzuGo8TlgojSQJi
         X9ugmFBPeF1s1H6Mty1kOFSoHZR+TVp3jitKueY184qS8f4H1Eo65KEuTEo8c/bNXg
         tr8Oz+syERdMw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 08089605AE;
        Fri,  8 Jan 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/bpf: remove duplicate include in test_lsm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161013720802.13974.7110278125613510508.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jan 2021 20:20:08 +0000
References: <20210105152047.6070-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210105152047.6070-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        jamorris@linux.microsoft.com, dong.menglong@zte.com.cn,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  5 Jan 2021 07:20:47 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> 'unistd.h' included in 'selftests/bpf/prog_tests/test_lsm.c' is
> duplicated.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - selftests/bpf: remove duplicate include in test_lsm
    https://git.kernel.org/bpf/bpf-next/c/17b75d3fe399

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


