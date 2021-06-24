Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17643B2E2B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFXLwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhFXLwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 07:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6026B613C1;
        Thu, 24 Jun 2021 11:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624535403;
        bh=Q7VkymOiEa0zbpG67FoQcj2emcAI4ak1cmp3WonlOY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PwzhyE9g7NuUiqSVIkS8mgTk08laEUabhd//xW9OvZdEBWTVBiMbr951yzpHwvlIP
         8hY5QPXKVbFqIfbCBXkPZKTjWZyJdqq+kFN4z1Hj5LWnwHGS1ZUwaY5kZssNgSAxAV
         3oMw48Zr1HXPzWi0PTtI/YCV3lfFqfGOVkiEPP5nzDt/LrAQjfb+6cWmHM4Q2YTerQ
         dafBLQEA2hZn6zvNjsV17xUjyp7Ii6g195ntScL/Xs/HoNc0u7mNSNZuy7XjDLClyj
         X6d34HN4uJtoN4BDAnnfJotjopSP2/PBRGQwoaJ1gFv3Ie5L6fsfBSbH4x8TUfBr12
         k85+g39+vlwVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 527B260A3C;
        Thu, 24 Jun 2021 11:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 bpf-next] bpf,
 x86: Remove unused cnt increase from EMIT macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162453540333.21455.12193291124753922044.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 11:50:03 +0000
References: <20210623112504.709856-1-jolsa@kernel.org>
In-Reply-To: <20210623112504.709856-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 23 Jun 2021 13:25:04 +0200 you wrote:
> Removing unused cnt increase from EMIT macro together
> with cnt declarations. This was introduced in commit [1]
> to ensure proper code generation. But that code was
> removed in commit [2] and this extra code was left in.
> 
> [1] b52f00e6a715 ("x86: bpf_jit: implement bpf_tail_call() helper")
> [2] ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> 
> [...]

Here is the summary with links:
  - [PATCHv2,bpf-next] bpf, x86: Remove unused cnt increase from EMIT macro
    https://git.kernel.org/bpf/bpf-next/c/ced50fc49f3b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


