Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4E34B41F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 04:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhC0DuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 23:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhC0DuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 23:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F3C5B61A26;
        Sat, 27 Mar 2021 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616817011;
        bh=939MZF6WJuj0opMIvm5oRDd4yeiTZFrMGvJydVLk2ns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AXf6g+Iks+UMJyiLOnGfAXu6urFg+c6BrvCZ5D4a7rP8TUSPPk9urUu+G69goJW/d
         RFGBahUVnRrBPvKPzu80GNY6Q7CsGk9dCbDoPIc5Aa6XB/FtEP6uQ+iqrQ5RiMvb0O
         DQeesn4pyx2hXRVfzB0KzJn6FUE24c0I1uZ/DoVpM224rn72lS315Lgs6N63R+UpCI
         WFjtniFXmvqADdSTwPPcJdI16ytSL9hUwda7boecu5CNkSxXqI1He6qz/RlPYShgWi
         /PhBjqo/tfFBwK7qDSZGWTKfhXQbPRtT7Ug3gw81h7isxo2ZXwsx/Ij66UDIPjnKw2
         67/h0GpYSgHVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6A05609EA;
        Sat, 27 Mar 2021 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161681701093.23684.14270712158208793167.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Mar 2021 03:50:10 +0000
References: <20210325015124.1543397-1-kafai@fb.com>
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 24 Mar 2021 18:51:24 -0700 you wrote:
> This series adds support to allow bpf program calling kernel function.
> 
> The use case included in this set is to allow bpf-tcp-cc to directly
> call some tcp-cc helper functions (e.g. "tcp_cong_avoid_ai()").  Those
> functions have already been used by some kernel tcp-cc implementations.
> 
> This set will also allow the bpf-tcp-cc program to directly call the
> kernel tcp-cc implementation,  For example, a bpf_dctcp may only want to
> implement its own dctcp_cwnd_event() and reuse other dctcp_*() directly
> from the kernel tcp_dctcp.c instead of reimplementing (or
> copy-and-pasting) them.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,01/14] bpf: Simplify freeing logic in linfo and jited_linfo
    https://git.kernel.org/bpf/bpf-next/c/e16301fbe183
  - [v2,bpf-next,02/14] bpf: Refactor btf_check_func_arg_match
    https://git.kernel.org/bpf/bpf-next/c/34747c412041
  - [v2,bpf-next,03/14] bpf: Support bpf program calling kernel function
    https://git.kernel.org/bpf/bpf-next/c/e6ac2450d6de
  - [v2,bpf-next,04/14] bpf: Support kernel function call in x86-32
    https://git.kernel.org/bpf/bpf-next/c/797b84f727bc
  - [v2,bpf-next,05/14] tcp: Rename bictcp function prefix to cubictcp
    https://git.kernel.org/bpf/bpf-next/c/d22f6ad18709
  - [v2,bpf-next,06/14] bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
    https://git.kernel.org/bpf/bpf-next/c/e78aea8b2170
  - [v2,bpf-next,07/14] libbpf: Refactor bpf_object__resolve_ksyms_btf_id
    https://git.kernel.org/bpf/bpf-next/c/933d1aa32409
  - [v2,bpf-next,08/14] libbpf: Refactor codes for finding btf id of a kernel symbol
    https://git.kernel.org/bpf/bpf-next/c/774e132e83d0
  - [v2,bpf-next,09/14] libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
    https://git.kernel.org/bpf/bpf-next/c/0c091e5c2d37
  - [v2,bpf-next,10/14] libbpf: Record extern sym relocation first
    https://git.kernel.org/bpf/bpf-next/c/aa0b8d43e953
  - [v2,bpf-next,11/14] libbpf: Support extern kernel function
    https://git.kernel.org/bpf/bpf-next/c/5bd022ec01f0
  - [v2,bpf-next,12/14] bpf: selftests: Rename bictcp to bpf_cubic
    https://git.kernel.org/bpf/bpf-next/c/39cd9e0f6783
  - [v2,bpf-next,13/14] bpf: selftests: bpf_cubic and bpf_dctcp calling kernel functions
    https://git.kernel.org/bpf/bpf-next/c/78e60bbbe8e8
  - [v2,bpf-next,14/14] bpf: selftests: Add kfunc_call test
    https://git.kernel.org/bpf/bpf-next/c/7bd1590d4eba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


