Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E388454926
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhKQOxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhKQOxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:53:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F71661269;
        Wed, 17 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637160609;
        bh=uOkBXmF0eKEMD5cHiFoZj2GHd8g6R7EKxmFyrk/Xe8g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHbWmiVRsxQpFheMi0kDVhYCtB57wodeEgGT0QBlJphbPgXC3l7oqurye/o4UEuEL
         /9l/4SjiMVjQCfhAsvQ6/yuKjjCotZR7yKISJqIlOw9f9qGVdqTTv+CUqOPPjOkpv0
         sKWQ0icRk7KUNChkSPGffHMUpRT3IhL5iKXrErtLFcq5YjI8J3xzwRTK2amo0FjNMP
         WUW4rziraEFtihMa3e2R4+G1B3jdX22sgNSZC7prIEj8r4X4A7hhcPIb47LzheVPuL
         5Au1I1ct2zfhbxjwzqbv0L9RVNfWffF9eU9FpJVUUmSdaZhts0N1N8JImSNkZ0jK76
         kk3J/FQ9v5VnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F4FB60A4E;
        Wed, 17 Nov 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf, x86: Fix "no previous prototype" warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716060931.12308.3728121323940964364.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 14:50:09 +0000
References: <20211117125708.769168-1-bjorn@kernel.org>
In-Reply-To: <20211117125708.769168-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 17 Nov 2021 13:57:08 +0100 you wrote:
> The arch_prepare_bpf_dispatcher function does not have a prototype,
> and yields the following warning when W=1 is enabled for the kernel
> build.
> 
>   >> arch/x86/net/bpf_jit_comp.c:2188:5: warning: no previous \
>   prototype for 'arch_prepare_bpf_dispatcher' [-Wmissing-prototypes]
>         2188 | int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, \
> 	int num_funcs)
>              |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [bpf] bpf, x86: Fix "no previous prototype" warning
    https://git.kernel.org/bpf/bpf/c/f45b2974cc0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


