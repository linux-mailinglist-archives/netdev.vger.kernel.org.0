Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8A540CD9D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhIOUBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhIOUB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 16:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B6586105A;
        Wed, 15 Sep 2021 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631736010;
        bh=oxmdwv32cs1SIOMZYotaa5zD3Pwt1dOisq8uIMtDHQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HW3aYqXEx7BrEVCQxZTfw8NXeFyZCjsHm3uFtBlLbQ/H16UeABIimIJ6JhP6w05kI
         OYQftAk6vPbe0XuRgpzbTz+rgSs9IbB63TkhaClzbKBwx+9AZVB9uOuOmCEC0mcn33
         79UCLt6ydvV/SW+TDIh/r/6cNRnpr6972PBb1QAtsf+D2ic8C5Qiw9PfKD6qYYyvP9
         bTjn4xx/iD4mXravMDPy68sXo+Q+015E4vtxJAZOe4I2cxQL4mCn3m0yxzWSfIbHgX
         tSUskf9pj0PxjjwrA7DLlg7XwwJ4WyJPDv4GNIuR3qJ6SuMsckJqBr2D3zLCZRgpaV
         m/MVSYM68zd3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27757609E4;
        Wed, 15 Sep 2021 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4 00/14] bpf/tests: Extend JIT test suite coverage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163173601015.28072.4479999406200567619.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 20:00:10 +0000
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
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

This series was applied to bpf/bpf.git (refs/heads/master):

On Tue, 14 Sep 2021 11:18:28 +0200 you wrote:
> This patch set adds a number of new tests to the test_bpf.ko test suite.
> It also corrects a faulty test case for tail call limits that failed
> erronously on the x86-64 and i386 JITs. The tests are intended to verify
> the correctness of eBPF JITs.
> 
> Changes since v3:
> * New patch 13 to fix faulty test cases for tail call error paths (13/14).
> * Fixed new tail call limit test accordingly (14/14).
> 
> [...]

Here is the summary with links:
  - [bpf,v4,01/14] bpf/tests: Allow different number of runs per test case
    https://git.kernel.org/bpf/bpf/c/540e44daebdf
  - [bpf,v4,02/14] bpf/tests: Reduce memory footprint of test suite
    https://git.kernel.org/bpf/bpf/c/b8eff1a480f7
  - [bpf,v4,03/14] bpf/tests: Add exhaustive tests of ALU shift values
    https://git.kernel.org/bpf/bpf/c/f71e9a1275f0
  - [bpf,v4,04/14] bpf/tests: Add exhaustive tests of ALU operand magnitudes
    https://git.kernel.org/bpf/bpf/c/b7396ec22547
  - [bpf,v4,05/14] bpf/tests: Add exhaustive tests of JMP operand magnitudes
    https://git.kernel.org/bpf/bpf/c/6f8f96955ca5
  - [bpf,v4,06/14] bpf/tests: Add staggered JMP and JMP32 tests
    https://git.kernel.org/bpf/bpf/c/cab8b4c0c9ab
  - [bpf,v4,07/14] bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
    https://git.kernel.org/bpf/bpf/c/d8a47d5a47b6
  - [bpf,v4,08/14] bpf/tests: Add test case flag for verifier zero-extension
    https://git.kernel.org/bpf/bpf/c/de0fd969640f
  - [bpf,v4,09/14] bpf/tests: Add JMP tests with small offsets
    https://git.kernel.org/bpf/bpf/c/f87c6bc98b80
  - [bpf,v4,10/14] bpf/tests: Add JMP tests with degenerate conditional
    https://git.kernel.org/bpf/bpf/c/9121d302531c
  - [bpf,v4,11/14] bpf/tests: Expand branch conversion JIT test
    https://git.kernel.org/bpf/bpf/c/b21999f4bad8
  - [bpf,v4,12/14] bpf/tests: Add more BPF_END byte order conversion tests
    https://git.kernel.org/bpf/bpf/c/d3241598b282
  - [bpf,v4,13/14] bpf/tests: Fix error in tail call limit tests
    https://git.kernel.org/bpf/bpf/c/fe89f6cabaed
  - [bpf,v4,14/14] bpf/tests: Add tail call limit test with external function call
    https://git.kernel.org/bpf/bpf/c/bc23f7244817

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


