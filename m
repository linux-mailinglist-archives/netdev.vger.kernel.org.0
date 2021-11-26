Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5018E45F649
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbhKZVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:25:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244403AbhKZVXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 16:23:22 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F50A6237E;
        Fri, 26 Nov 2021 21:20:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id ACE6F6008E;
        Fri, 26 Nov 2021 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637961608;
        bh=moi86rKF1ITSxySSx4zc0RuevUbXQCMXQfYVDU/TYEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bN1YktrI6PDk/jFYOjBQyVGkjnr31bSYzdmY9IiSPBXR0HeldaYZMU2UCOkQKj0+w
         ql6YSdfjYRHS0HpWQlgBxX+FfA5pZX0gonPVbCqQX7aRFOKbm7c2jKqqe5ddyetkj6
         g+PeY4Nw2K1+egXuC4DAyu/1HJ+KbwCFbJHQebRM9Nyjvnl3LsIQHdVdyfGGNfkZJS
         FGxqR6QNlVuQGeWywYnP/n/yVuUf2mr5pzmpjqZJDODPTQH5TTolHdibdJIOLO2eOx
         u1xDoqi1NC3TIb6YQMCFw38y4ySKOx7lHaE+/skVAK76xGbdh2XqC4AsTVMPegNYPs
         WW+F3GbqvWdhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A332360A6C;
        Fri, 26 Nov 2021 21:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf,
 mips: Fix build errors about __NR_bpf undeclared
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163796160866.30899.10399099274793745280.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 21:20:08 +0000
References: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        lixuefeng@loongson.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 25 Nov 2021 09:36:07 +0800 you wrote:
> Add the __NR_bpf definitions to fix the following build errors for mips.
> 
>  $ cd tools/bpf/bpftool
>  $ make
>  [...]
>  bpf.c:54:4: error: #error __NR_bpf not defined. libbpf does not support your arch.
>   #  error __NR_bpf not defined. libbpf does not support your arch.
>      ^~~~~
>  bpf.c: In function ‘sys_bpf’:
>  bpf.c:66:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
>    return syscall(__NR_bpf, cmd, attr, size);
>                   ^~~~~~~~
>                   __NR_brk
>  [...]
>  In file included from gen_loader.c:15:0:
>  skel_internal.h: In function ‘skel_sys_bpf’:
>  skel_internal.h:53:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
>    return syscall(__NR_bpf, cmd, attr, size);
>                   ^~~~~~~~
>                   __NR_brk
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf, mips: Fix build errors about __NR_bpf undeclared
    https://git.kernel.org/bpf/bpf-next/c/e32cb12ff52a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


