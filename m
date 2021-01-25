Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372B230302D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbhAYXbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732031AbhAYXav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 68683229EF;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617410;
        bh=VZKmqca2RnpnjckPt116sGS2q2z0bBHhRkk3KOgxZPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SKVVtj91CRuJCllR7HOOG3YAbqkFV5cQwKBRoVH/3mZnUfeZrO+k/NlW6CdJ6YPWZ
         rjZBt4enHo30rGbpWyhbPFNurzmf0CLCBg1W3pGgceYUVLslR6hXP0Mkj/qBp9O7aH
         ko/H2iG8cm0bUtJEh77q1eKAXKgwsxCnUpTzuHPl9XWxrkaB2IwfELpvggebmkD4ar
         pEQTTYzTBdCLmDWMF+f702X2/ycqUsaJLKQpQ8j8yrcu2fFCjMrUjjUbLeT0jbbODr
         RbZ0JFZvAxRpj+K4D8huxsQKPajvYBUm4jjtvSeOw8+W80vuAtT5Xg1h7JbU/RFVK4
         mCYxSrrL5XQsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55C9361E45;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__
 for MIPS to fix build warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161161741034.15463.7501053480243714931.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jan 2021 23:30:10 +0000
References: <1611551146-14052-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1611551146-14052-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 25 Jan 2021 13:05:46 +0800 you wrote:
> There exists many build warnings when make M=samples/bpf on the Loongson
> platform, this issue is MIPS related, x86 compiles just fine.
> 
> Here are some warnings:
> 
>   CC  samples/bpf/ibumad_user.o
> samples/bpf/ibumad_user.c: In function ‘dump_counts’:
> samples/bpf/ibumad_user.c:46:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>     printf("0x%02x : %llu\n", key, value);
>                      ~~~^          ~~~~~
>                      %lu
>   CC  samples/bpf/offwaketime_user.o
> samples/bpf/offwaketime_user.c: In function ‘print_ksym’:
> samples/bpf/offwaketime_user.c:34:17: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>    printf("%s/%llx;", sym->name, addr);
>               ~~~^               ~~~~
>               %lx
> samples/bpf/offwaketime_user.c: In function ‘print_stack’:
> samples/bpf/offwaketime_user.c:68:17: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
>   printf(";%s %lld\n", key->waker, count);
>               ~~~^                 ~~~~~
>               %ld
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__ for MIPS to fix build warnings
    https://git.kernel.org/bpf/bpf-next/c/190d1c921ad0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


