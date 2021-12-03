Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B65468025
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 00:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376301AbhLCXDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 18:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhLCXDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 18:03:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1582FC061751;
        Fri,  3 Dec 2021 15:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C6C862D36;
        Fri,  3 Dec 2021 23:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05A46C53FCD;
        Fri,  3 Dec 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638572409;
        bh=PRIzoZduL+FH2eXDCg1xVMlQjUQQpSiAYkeeKFxrpbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mBpLFAQsly/O4ZH1amCQV5Hr/n+l/qXbg52aY4XnmjvSGv8VfDeHa0R5YLDcvPt1H
         smeLLjD102JA28V/dtlikF9Zmr2w91pnroqr4esKpLdinsIM2KqKbw8uyWErK0wgr0
         Zegc3nKuKU9HhxbMyP/mo89RqI/Y89mgwzLFOLF5bunZ6YqC5FVXsdKmSJmHPoruAq
         vwzbqHV0CbQH1I5BnTmgRyB7sfsaXLzvrRT0KojOqlyZ8+YTaO0IXFkIIR1qYaD4SI
         iUfAfnoH7x8lxo7Uf3iW6vJfrfDsoSzJEd/FEo/m/OttLOcKK9+hze+OQFZeA+ZhIU
         FyP19AC07opPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D83E360A50;
        Fri,  3 Dec 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Fix the test_task_vma selftest to support output
 shorter than 1 kB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163857240888.22727.1341673704180599136.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 23:00:08 +0000
References: <20211130181811.594220-1-maximmi@nvidia.com>
In-Reply-To: <20211130181811.594220-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        revest@chromium.org, davemarchevsky@fb.com,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 Nov 2021 20:18:11 +0200 you wrote:
> The test for bpf_iter_task_vma assumes that the output will be longer
> than 1 kB, as the comment above the loop says. Due to this assumption,
> the loop becomes infinite if the output turns to be shorter than 1 kB.
> The return value of read_fd_into_buffer is 0 when the end of file was
> reached, and len isn't being increased any more.
> 
> This commit adds a break on EOF to handle short output correctly. For
> the reference, this is the contents that I get when running test_progs
> under vmtest.sh, and it's shorter than 1 kB:
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Fix the test_task_vma selftest to support output shorter than 1 kB
    https://git.kernel.org/bpf/bpf-next/c/da54ab14953c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


