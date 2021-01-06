Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB52EC6E7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbhAFXat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbhAFXas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 18:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FE2A2313A;
        Wed,  6 Jan 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609975808;
        bh=h9cvYcIzci27Ptk6NinbKrsmZrHcY5MmuETl7A5EjqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s0Cn45MHifTOtxJb1pNi6wRqOBIgfjmnHYCD6Qw+5pyMIdhuEcAV/vKceATtBQLNL
         b36cZemJXJsLt072J74CZ/7eys44atxVAO9c1sk03Q8KuUPRdf+zCip4doJ4sB2gCC
         60JqeoKfhVvHMjWyY6fKnU3j+5u7I/U2EFLUoW84wTkbyBA0pGcCByZSnyp/w+nk/3
         I3lj+mGlBjOS0/Y0RXxyAPz+Ba/u4a/Gv9DuxrDCb4D8AerNtP9q2DNd644KObKddM
         5jJe3SNKU0fZ84zYkTFC4GuWylQTtBbQzG8qG+PSr4WYnZ+3sb2mLxCKYTggSwB3n1
         EGgCVqNiPHOSQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 112BD60597;
        Wed,  6 Jan 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpftool: fix compilation failure for net.o with older
 glibc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160997580806.29559.1033130735626335263.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jan 2021 23:30:08 +0000
References: <1609948746-15369-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1609948746-15369-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        wanghai38@huawei.com, quentin@isovalent.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed,  6 Jan 2021 15:59:06 +0000 you wrote:
> For older glibc ~2.17, #include'ing both linux/if.h and net/if.h
> fails due to complaints about redefinition of interface flags:
> 
>   CC       net.o
> In file included from net.c:13:0:
> /usr/include/linux/if.h:71:2: error: redeclaration of enumerator ‘IFF_UP’
>   IFF_UP    = 1<<0,  /* sysfs */
>   ^
> /usr/include/net/if.h:44:5: note: previous definition of ‘IFF_UP’ was here
>      IFF_UP = 0x1,  /* Interface is up.  */
> 
> [...]

Here is the summary with links:
  - [bpf] bpftool: fix compilation failure for net.o with older glibc
    https://git.kernel.org/bpf/bpf/c/6f02b540d759

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


