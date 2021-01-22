Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661363010B0
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbhAVXLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:11:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbhAVXKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B0F4B23B52;
        Fri, 22 Jan 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611357009;
        bh=V2U34p1/NCV5FrfodxFyi0V4q4qOz3sfwuf6/38+ZhI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HhzwLyN7nJJeaYVriJ37ZTX3G/e59dCa1S+DwmTOZC+J1ndQ7fFpDQLPYRMJqNDlw
         LjaO7u/T2s/fS3LrAx+fShYzRrRmTcbBi3JDdvpnnK2u5MqKReUj82DawYCrfoKUh9
         3Iy98aKQ7tE7K93s4cAtLDTmmWmN7FYqoQvyqd+RT053ckUV7JTEmc/+UaD1RT6fvA
         Ddyf8OsN6zUrYh12s2Vh28VMrIIc5GfCnPpN/P8Ztg/CLE6OZ0ROqsU+dOXR97V94p
         wgD/cFIeBfyMUpyvkMvW72PwZ175V6QKjnXYquPIIotyyhPjK0/2DqQ5RQhhB6gvtp
         A9ujnkfKBpujw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FC32652D9;
        Fri, 22 Jan 2021 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4] samples/bpf: Update build procedure for manually
 compiling LLVM and Clang
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161135700964.32582.5741971594319443447.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 23:10:09 +0000
References: <1611279584-26047-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1611279584-26047-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn, maskray@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 22 Jan 2021 09:39:44 +0800 you wrote:
> The current LLVM and Clang build procedure in samples/bpf/README.rst is
> out of date. See below that the links are not accessible any more.
> 
> $ git clone http://llvm.org/git/llvm.git
> Cloning into 'llvm'...
> fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> $ git clone --depth 1 http://llvm.org/git/clang.git
> Cloning into 'clang'...
> fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4] samples/bpf: Update build procedure for manually compiling LLVM and Clang
    https://git.kernel.org/bpf/bpf-next/c/628add78b07a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


