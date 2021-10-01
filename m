Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A8841F0A6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354817AbhJAPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354923AbhJAPLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4297061A40;
        Fri,  1 Oct 2021 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633101008;
        bh=aBmWbdKE920lYfPe2lpnamFCqKqSudWCenTSOYeyvs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jqYI3v9nJgw8pbJMJmKCTbqtf9yYwGYHcFnXULqDq/napJDTVoN+6NHzi7TRe8SkS
         oeDctrLHJ4vZueYoQbz8VonRlxfa9zmAlpz42MV66ym7pciydiujw3LHKPNys1WyOc
         wbxEKAzaDTMeF2Z4TLDcVrCEtr11f1RF8ToCdmhlgUMaOuyGoWGjA7mRIoFeRLtvmK
         3K+jCWcGaNOsyy/wWeMhaf94vMH8ExFhbeSg4CIQ56e/cozBgFdzCSu1f9P5QsOMtA
         Ey8BUae2OTnqm3G+jOa4gewUQRkszOLRBcrCFn5XfE1b3Mcz/WiVNDK7mTZeLFloAO
         qb/2OxEaJ39yQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2FEB460A3C;
        Fri,  1 Oct 2021 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/10] bpf/tests: Extend eBPF JIT test suite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163310100819.11228.15860171916823233197.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 15:10:08 +0000
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri,  1 Oct 2021 15:03:38 +0200 you wrote:
> This patch set adds a number of new tests to the test_bpf.ko test suite.
> The new tests focus on the behaviour of operations with different
> combinations of register operands, and in particular, when two or more
> register operands are in fact the same register. It also verifies things
> like a src register not being zero-extended in-place in ALU32 operations,
> and that operations implemented with function calls do not clobber any
> other eBPF registers.
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/10] bpf/tests: Add tests of BPF_LDX and BPF_STX with small sizes
    https://git.kernel.org/bpf/bpf-next/c/caaaa1667bf1
  - [bpf-next,02/10] bpf/tests: Add zero-extension checks in BPF_ATOMIC tests
    https://git.kernel.org/bpf/bpf-next/c/89b63462765c
  - [bpf-next,03/10] bpf/tests: Add exhaustive tests of BPF_ATOMIC magnitudes
    https://git.kernel.org/bpf/bpf-next/c/f68e8efd7fa5
  - [bpf-next,04/10] bpf/tests: Add tests to check source register zero-extension
    https://git.kernel.org/bpf/bpf-next/c/0bbaa02b4816
  - [bpf-next,05/10] bpf/tests: Add more tests for ALU and ATOMIC register clobbering
    https://git.kernel.org/bpf/bpf-next/c/e2f9797b3c73
  - [bpf-next,06/10] bpf/tests: Minor restructuring of ALU tests
    https://git.kernel.org/bpf/bpf-next/c/e42fc3c2c40e
  - [bpf-next,07/10] bpf/tests: Add exhaustive tests of ALU register combinations
    https://git.kernel.org/bpf/bpf-next/c/daed6083f4fb
  - [bpf-next,08/10] bpf/tests: Add exhaustive tests of BPF_ATOMIC register combinations
    https://git.kernel.org/bpf/bpf-next/c/6fae2e8a1d9e
  - [bpf-next,09/10] bpf/tests: Add test of ALU shifts with operand register aliasing
    https://git.kernel.org/bpf/bpf-next/c/68813605dea6
  - [bpf-next,10/10] bpf/tests: Add test of LDX_MEM with operand aliasing
    https://git.kernel.org/bpf/bpf-next/c/7bceeb95726b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


