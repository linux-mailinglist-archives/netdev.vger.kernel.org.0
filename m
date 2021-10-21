Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD2436DD0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJUXC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhJUXC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 19:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2318861354;
        Thu, 21 Oct 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634857208;
        bh=tdVpo0B8iqU3aJ7sFVoi9zdKByKPSPPLh/7wtpF1f/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mLWnmVapdcYy6LlNPmnw+fSq/edUrADMiW9fWRbJwFpa2pJERQAPDIkSyAv0Fmaqe
         JOc9K0A04er2aGiOBAvxp9C72mYY6vgyie6TyY+Vj+qEyqe0Sh4liVsfZQs6DpFnQf
         AJ+5BXHSpYusL2fgM3Qt9QQTRWk4DzPIcVGR/Qj4mKYpFL1z+V1ICFhq7ls+JlOeEe
         gGOCWKhOBAlokqUKIBWfwDaUUkYUw0X8ap4E/7AKKOnChEojFI4G621kSmdcXE9TgZ
         RuJLcR49oiRnuN3QCdRSJV57K/mSQCXn4/6r2H7f4X18A4iWLtNt5ivGmA6FMv3jbQ
         dUnkYVWuM8M+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1642860A21;
        Thu, 21 Oct 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next 0/2] bpf: keep track of verifier insn_processed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163485720808.7837.14437456240711976469.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 23:00:08 +0000
References: <20211020074818.1017682-1-davemarchevsky@fb.com>
In-Reply-To: <20211020074818.1017682-1-davemarchevsky@fb.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 20 Oct 2021 00:48:16 -0700 you wrote:
> This is a followup to discussion around RFC patchset "bpf: keep track of
> prog verification stats" [0]. The RFC elaborates on my usecase, but to
> summarize: keeping track of verifier stats for programs as they - and
> the kernels they run on - change over time can help developers of
> individual programs and BPF kernel folks.
> 
> The RFC added a verif_stats to the uapi which contained most of the info
> which verifier prints currently. Feedback here was to avoid polluting
> uapi with stats that might be meaningless after major changes to the
> verifier, but that insn_processed or conceptually similar number would
> exist in the long term and was safe to expose.
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next,1/2] bpf: add verified_insns to bpf_prog_info and fdinfo
    https://git.kernel.org/bpf/bpf-next/c/aba64c7da983
  - [v3,bpf-next,2/2] selftests/bpf: add verif_stats test
    https://git.kernel.org/bpf/bpf-next/c/e1b9023fc7ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


