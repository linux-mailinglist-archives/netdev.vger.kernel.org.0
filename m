Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C8528997A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388077AbgJIULk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390662AbgJIUKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 16:10:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602274203;
        bh=JVVKQiSpNKj3J1/C2WCrB1KsbLIG0tAQ59TbxzrXjDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RAj871Tuktq4KwtJwoJZXJl9QUtimu/+WL+L6dJqvTxNfGfCAnT1NIxHxYwE8POUn
         Fi/DWFoTPgV3lpmVAmZMBzx6On54Wkh5e+XIbdbGc7gJB72qUq+RvEcZEngxvKV7Kk
         zgG5gqrMFHPQF1Ol6OtrdoX78G5WK5amV6HtBeGI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/4] bpf: Make the verifier recognize llvm
 register allocation patterns.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160227420316.11483.9813871681277848133.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Oct 2020 20:10:03 +0000
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu,  8 Oct 2020 18:12:36 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v1->v2:
> - fixed 32-bit mov issue spotted by John.
> - allowed r2=r1; r3=r2; sequence as suggested by John.
> - added comments, acks, more tests.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/4] bpf: Propagate scalar ranges through register assignments.
    https://git.kernel.org/bpf/bpf-next/c/75748837b7e5
  - [v2,bpf-next,2/4] bpf: Track spill/fill of bounded scalars.
    https://git.kernel.org/bpf/bpf-next/c/5689d49b71ad
  - [v2,bpf-next,3/4] selftests/bpf: Add profiler test
    https://git.kernel.org/bpf/bpf-next/c/03d4d13fab3f
  - [v2,bpf-next,4/4] selftests/bpf: Asm tests for the verifier regalloc tracking.
    https://git.kernel.org/bpf/bpf-next/c/54fada41e8a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


