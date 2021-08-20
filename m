Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3293F2C78
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbhHTMwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240278AbhHTMwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 08:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 59EE8610E6;
        Fri, 20 Aug 2021 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629463929;
        bh=UQqyMBr4CjifbSyBvwHrwok7V98Vkx5B/FpgWfcV0gg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dPLfngGA55N2RQzouwURV53d1e0Tb/YtNj4al0TQSl1AxCHkaY4rKGlWfPPuu5cOR
         d3iSngE9S33MBO3bNLpbeyyln37igP5li9N2I5lJ/ow9L3HcL1gL3/5SMu3HsaOBqN
         O1bQqAOJ3DC9E2zJqUjdaAZuC1ouyBh6KZyQ8eWS4+ZN1tWGBI6pGVu1Ar+uXzpey4
         1ES2k+zZOKrD6YALMI4sB7YHP+E9t5V4rkAzb94eBJWecf8RpV0UOsarggaYp/YwYb
         TUxOVNbDURzGSLRkRHow9iGgDeITcaSY6bYznvLL49IUUz59CkzCaVIj0jzturEir2
         KG8te9CPs/zzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5043C60A89;
        Fri, 20 Aug 2021 12:52:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 1/2] bpf: use kvmalloc for map values in syscall
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946392932.27725.1911854236154842439.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 12:52:09 +0000
References: <20210818235216.1159202-1-sdf@google.com>
In-Reply-To: <20210818235216.1159202-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 18 Aug 2021 16:52:15 -0700 you wrote:
> Use kvmalloc/kvfree for temporary value when manipulating a map via
> syscall. kmalloc might not be sufficient for percpu maps where the value
> is big (and further multiplied by hundreds of CPUs).
> 
> Can be reproduced with netcnt test on qemu with "-smp 255".
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/2] bpf: use kvmalloc for map values in syscall
    https://git.kernel.org/bpf/bpf-next/c/f0dce1d9b7c8
  - [bpf-next,v3,2/2] bpf: use kvmalloc for map keys in syscalls
    https://git.kernel.org/bpf/bpf-next/c/44779a4b85ab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


