Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A925442510
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhKBBWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhKBBWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 21:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1889610A2;
        Tue,  2 Nov 2021 01:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635816006;
        bh=7ygTD1Mm21sW96aUbajwM3zn19p5y604kj6kGRqhAXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NeR5lZcy0en4juTCM7gVKbTsY/Q5+g6gaKDV1KYjwIAko2Da1+Ns8+gQCjasS2Uos
         4LLkGG04J3EW49y5FNQ1m4mb2aW4eOug7GWXtFCuOp2/PPphgFQxh7KJT1DYx4xA4c
         i/kWGB6u2qjnDVSclVojwsTpg36Rnoyzoz2LnFmApdYcIwd5z9E3cFRxNuDTAolNpF
         FteuSp8hNF055pfPQihP5GfUugTLFmZkLr0SGFcvd0VOMuIPkY4N3Nih07Qf/bsqub
         wWcOCcZGb6KiDzHygqdrYmr9XiuMpXQQl7CY5nqefMzKTaFeS6+za2IUb9XH/7O7Jp
         WUU2okv6DLjyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5CA860BD0;
        Tue,  2 Nov 2021 01:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next] kbuild: Unify options for BTF generation for
 vmlinux and modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163581600680.29215.13986498417182964591.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 01:20:06 +0000
References: <20211029125729.70002-1-jolsa@kernel.org>
In-Reply-To: <20211029125729.70002-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com, lkp@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 29 Oct 2021 14:57:29 +0200 you wrote:
> Using new PAHOLE_FLAGS variable to pass extra arguments to
> pahole for both vmlinux and modules BTF data generation.
> 
> Adding new scripts/pahole-flags.sh script that detect and
> prints pahole options.
> 
> [ fixed issues found by kernel test robot ]
> Cc: kernel test robot <lkp@intel.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next] kbuild: Unify options for BTF generation for vmlinux and modules
    https://git.kernel.org/bpf/bpf-next/c/9741e07ece7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


