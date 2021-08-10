Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91313E58C0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhHJLAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239965AbhHJLAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F71360F25;
        Tue, 10 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628593208;
        bh=ge0jRCneYZEqMwSOuMXUe8zNmTHYd7skqvU+4dfhkC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=psJWpqsIOukPbbMHEvaL8daFh8rGwMdeqFhQv5GYQNfnLW84Y+5ocfW8rHUPs/2U4
         7faJzxCVae6bN/N5rMmVpS9Kym3SZxbmDVGAi9KK7yrcV7QwkudpwhJkib+9KeMmG2
         G1G9RqiBnHBLyp25htfGxIU2P49ee1qpqj4P941F5J5n6DE1AnpOj0JmYc/nCozK6z
         JV/qhFndcblmxUY2izD2YUFW/DrFr6kwk2KBLtQqzgabxOtcFZ9Ev6xRUfO95vDcpC
         mdpW7ivKxyh1/GC0KBaVpRyFd8tGvXWdqgqJJtTknnqdgai/EKxhLdMrpGMToVumqd
         wwrMW0GDdLKSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6119C60986;
        Tue, 10 Aug 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 00/14] bpf/tests: Extend the eBPF test suite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162859320839.31319.2510220582010693607.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 11:00:08 +0000
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  9 Aug 2021 11:18:15 +0200 you wrote:
> This patch set extends the eBPF test suite in the test_bpf kernel module
> to add more extensive tests of corner cases and new tests for operations
> not previously covered.
> 
> Link: https://lore.kernel.org/bpf/20210728170502.351010-1-johan.almbladh@anyfinetworks.com/
> Link: https://lore.kernel.org/bpf/20210726081738.1833704-1-johan.almbladh@anyfinetworks.com/
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,01/14] bpf/tests: Add BPF_JMP32 test cases
    https://git.kernel.org/bpf/bpf-next/c/b55dfa850015
  - [bpf-next,v2,02/14] bpf/tests: Add BPF_MOV tests for zero and sign extension
    https://git.kernel.org/bpf/bpf-next/c/565731acfcf2
  - [bpf-next,v2,03/14] bpf/tests: Fix typos in test case descriptions
    https://git.kernel.org/bpf/bpf-next/c/e92c813bf119
  - [bpf-next,v2,04/14] bpf/tests: Add more tests of ALU32 and ALU64 bitwise operations
    https://git.kernel.org/bpf/bpf-next/c/ba89bcf78fba
  - [bpf-next,v2,05/14] bpf/tests: Add more ALU32 tests for BPF_LSH/RSH/ARSH
    https://git.kernel.org/bpf/bpf-next/c/0f2fca1ab183
  - [bpf-next,v2,06/14] bpf/tests: Add more BPF_LSH/RSH/ARSH tests for ALU64
    https://git.kernel.org/bpf/bpf-next/c/3b9890ef80f4
  - [bpf-next,v2,07/14] bpf/tests: Add more ALU64 BPF_MUL tests
    https://git.kernel.org/bpf/bpf-next/c/faa576253d5f
  - [bpf-next,v2,08/14] bpf/tests: Add tests for ALU operations implemented with function calls
    https://git.kernel.org/bpf/bpf-next/c/84024a4e86d9
  - [bpf-next,v2,09/14] bpf/tests: Add word-order tests for load/store of double words
    https://git.kernel.org/bpf/bpf-next/c/e5009b4636cb
  - [bpf-next,v2,10/14] bpf/tests: Add branch conversion JIT test
    https://git.kernel.org/bpf/bpf-next/c/66e5eb847455
  - [bpf-next,v2,11/14] bpf/tests: Add test for 32-bit context pointer argument passing
    https://git.kernel.org/bpf/bpf-next/c/53e33f9928cd
  - [bpf-next,v2,12/14] bpf/tests: Add tests for atomic operations
    https://git.kernel.org/bpf/bpf-next/c/e4517b3637c6
  - [bpf-next,v2,13/14] bpf/tests: Add tests for BPF_CMPXCHG
    https://git.kernel.org/bpf/bpf-next/c/6a3b24ca489e
  - [bpf-next,v2,14/14] bpf/tests: Add tail call test suite
    https://git.kernel.org/bpf/bpf-next/c/874be05f525e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


