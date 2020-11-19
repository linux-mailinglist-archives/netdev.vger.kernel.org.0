Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F652B89F2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 03:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgKSCAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 21:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgKSCAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 21:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605751206;
        bh=IF109IuW33A32oN56MmCn4OdUieDnOvrSzFgXKKeaww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IfNsNGqL8P6/0ZS8CPrApiyHyaVvEEREcGBNiCui45PTXIU05h/3C47/2EcSrksr5
         ep2fZfXELDpxFiDXabdPQYkkASBZ90Hoxl4eLiG2HiytLIp0KaElM7dJMY80bj2kSt
         a0w6rVGXKMrvWDobpQRVlPiS+jgybFYKmEvmAzk8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] RISC-V selftest/bpf fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160575120591.17801.17784029868149830449.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 02:00:05 +0000
References: <20201118071640.83773-1-bjorn.topel@gmail.com>
In-Reply-To: <20201118071640.83773-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org, andrii.nakryiko@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 18 Nov 2020 08:16:37 +0100 you wrote:
> This series contain some fixes for selftests/bpf when building/running
> on a RISC-V host. Details can be found in each individual commit.
> 
> 
> Cheers,
> Björn
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] selftests/bpf: Fix broken riscv build
    https://git.kernel.org/bpf/bpf-next/c/6016df8fe874
  - [bpf-next,v2,2/3] selftests/bpf: Avoid running unprivileged tests with alignment requirements
    https://git.kernel.org/bpf/bpf-next/c/c77b0589ca29
  - [bpf-next,v2,3/3] selftests/bpf: Mark tests that require unaligned memory access
    https://git.kernel.org/bpf/bpf-next/c/6007b23cc755

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


